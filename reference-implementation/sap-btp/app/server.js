"use strict";

const express = require("express");
const passport = require("passport");
const xsenv = require("@sap/xsenv");
const xssec = require("@sap/xssec");
const { getDestination } = require("@sap-cloud-sdk/connectivity");
const { executeHttpRequest } = require("@sap-cloud-sdk/http-client");

const app = express();
const port = process.env.PORT || 8080;
const requiredScopeSuffix = "Read";

function loadXsuaaCredentials() {
  const services = xsenv.getServices({
    xsuaa: { tag: "xsuaa" }
  });
  return services.xsuaa;
}

function buildJwtStrategy() {
  const credentials = loadXsuaaCredentials();
  return new xssec.JWTStrategy(credentials);
}

function hasReadScope(req) {
  const securityContext = req.authInfo;
  if (!securityContext || typeof securityContext.checkScope !== "function") {
    return false;
  }

  const xsappname = securityContext.getAppToken
    ? securityContext.getAppToken().ext_attr?.xsappname
    : undefined;

  if (xsappname && securityContext.checkScope(`${xsappname}.${requiredScopeSuffix}`)) {
    return true;
  }

  return securityContext.checkScope(requiredScopeSuffix);
}

function requireReadScope(req, res, next) {
  if (!hasReadScope(req)) {
    return res.status(403).json({
      status: "forbidden",
      requiredScope: requiredScopeSuffix
    });
  }
  return next();
}

function correlationId(req) {
  return req.get("x-correlation-id") || `demo-${Date.now()}`;
}

async function callDestination(destinationName, path, req) {
  const destination = await getDestination({ destinationName });
  if (!destination) {
    const error = new Error(`Destination not found: ${destinationName}`);
    error.statusCode = 502;
    throw error;
  }

  const response = await executeHttpRequest(
    destination,
    {
      method: "GET",
      url: path,
      headers: {
        "x-correlation-id": correlationId(req)
      }
    },
    {
      fetchCsrfToken: false
    }
  );

  return response.data;
}

passport.use(buildJwtStrategy());
app.use(passport.initialize());

app.get("/health", (_req, res) => {
  res.json({
    status: "ok",
    service: "sap-btp-platform-probe-backend"
  });
});

app.get(
  "/destination-check",
  passport.authenticate("JWT", { session: false }),
  requireReadScope,
  async (req, res, next) => {
    try {
      const data = await callDestination(
        process.env.AKS_PROBE_DESTINATION || "AKS_PROBE_API",
        process.env.AKS_PROBE_PATH || "/health",
        req
      );
      res.json({
        status: "ok",
        correlationId: correlationId(req),
        downstream: data
      });
    } catch (error) {
      next(error);
    }
  }
);

app.get(
  "/onprem-check",
  passport.authenticate("JWT", { session: false }),
  requireReadScope,
  async (req, res, next) => {
    try {
      const data = await callDestination(
        process.env.ONPREM_DESTINATION || "ONPREM_MOCK_API",
        process.env.ONPREM_PATH || "/health",
        req
      );
      res.json({
        status: "ok",
        correlationId: correlationId(req),
        downstream: data
      });
    } catch (error) {
      next(error);
    }
  }
);

app.use((error, _req, res, _next) => {
  const statusCode = error.statusCode || error.response?.status || 500;
  res.status(statusCode).json({
    status: "error",
    message: error.message,
    code: statusCode
  });
});

app.listen(port, () => {
  console.log(`SAP BTP backend listening on port ${port}`);
});
