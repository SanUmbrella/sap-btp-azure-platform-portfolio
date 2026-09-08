const http = require("http");
const { randomUUID } = require("crypto");

const {
  createSecurityContext,
  XsuaaService
} = require("@sap/xssec");

const {
  executeHttpRequest
} = require("@sap-cloud-sdk/http-client");

const port = process.env.PORT || 3000;

function getXsuaaCredentials() {
  if (!process.env.VCAP_SERVICES) {
    throw new Error("VCAP_SERVICES is not available");
  }

  const services = JSON.parse(process.env.VCAP_SERVICES);

  if (!services.xsuaa || services.xsuaa.length === 0) {
    throw new Error("No XSUAA service binding found");
  }

  return services.xsuaa[0].credentials;
}

const xsuaaService = new XsuaaService(getXsuaaCredentials());

function getCorrelationId(req) {
  return req.headers["x-correlation-id"] || randomUUID();
}

function sendJson(res, statusCode, payload, headers = {}) {
  res.writeHead(statusCode, {
    "Content-Type": "application/json",
    ...headers
  });

  res.end(JSON.stringify(payload));
}

const server = http.createServer(async (req, res) => {

  // Public health endpoint
  if (req.url === "/health") {
    return sendJson(res, 200, {
      status: "UP"
    });
  }

  let securityContext;

  try {
    securityContext = await createSecurityContext(
      xsuaaService,
      { req }
    );
  } catch {
    return sendJson(res, 401, {
      error: "Unauthorized"
    });
  }

  if (!securityContext.checkLocalScope("Read")) {
    return sendJson(res, 403, {
      error: "Forbidden"
    });
  }

  // Programmatic Destination Service test
  if (req.url === "/destination-check") {
    try {
      const response = await executeHttpRequest(
        {
          destinationName: "hello-backend"
        },
        {
          method: "GET",
          url: "/health"
        }
      );

      return sendJson(res, 200, {
        message: "Destination Service lookup succeeded",
        destination: "hello-backend",
        backendResponse: response.data
      });

    } catch (error) {
      console.error(
        "Destination request failed:",
        error.message
      );

      return sendJson(res, 502, {
        error: "Destination request failed"
      });
    }
  }

  if (req.url === "/onprem-check") {
    try {
      const response = await executeHttpRequest(
        {
          destinationName: "onprem-hello"
        },
        {
          method: "GET",
          url: "/health.json"
        }
      );

      return sendJson(res, 200, {
        message: "On-premise connectivity succeeded",
        destination: "onprem-hello",
        backendResponse: response.data
      });

    } catch (error) {
      console.error(
        "On-premise request failed:",
        error.message
      );

      return sendJson(res, 502, {
        error: "On-premise request failed"
      });
    }
  }

  if (req.url === "/azure-check") {
    const correlationId = getCorrelationId(req);

    console.log(
      `correlation_id=${correlationId} target=azure-aks-probe event=request_start`
    );

    try {
      const response = await executeHttpRequest(
        {
          destinationName: "azure-aks-probe"
        },
        {
          method: "GET",
          url: "/keyvault-check",
          headers: {
            "X-Correlation-ID": correlationId
          }
        }
      );

      console.log(
        `correlation_id=${correlationId} target=azure-aks-probe event=request_end status=success`
      );

      return sendJson(
        res,
        200,
        {
          status: "ok",
          correlationId,
          destination: "azure-aks-probe",
          azure: response.data
        },
        {
          "X-Correlation-ID": correlationId
        }
      );

    } catch (error) {
      console.error(
        `correlation_id=${correlationId} target=azure-aks-probe event=request_end status=error error=${JSON.stringify(error.message)}`
      );

      return sendJson(
        res,
        502,
        {
          status: "error",
          correlationId,
          error: "Azure AKS request failed"
        },
        {
          "X-Correlation-ID": correlationId
        }
      );
    }
  }

  return sendJson(res, 200, {
    message: "Authorized request accepted",
    platform: "SAP BTP",
    runtime: "Cloud Foundry"
  });
});

server.listen(port, "0.0.0.0", () => {
  console.log(`Listening on port ${port}`);
});
