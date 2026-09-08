package main

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/security/keyvault/azsecrets"
)

type response struct {
	Status          string `json:"status"`
	Service         string `json:"service"`
	CorrelationID   string `json:"correlationId"`
	WorkloadIdentity *bool   `json:"workloadIdentity,omitempty"`
	KeyVaultAccess  *bool   `json:"keyVaultAccess,omitempty"`
	Error           string `json:"error,omitempty"`
}

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/health", handleHealth)
	mux.HandleFunc("/identity-check", handleIdentityCheck)
	mux.HandleFunc("/keyvault-check", handleKeyVaultCheck)

	server := &http.Server{
		Addr:              ":8080",
		Handler:           loggingMiddleware(mux),
		ReadHeaderTimeout: 5 * time.Second,
	}

	log.Printf("service=aks-probe-api event=start port=8080")

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, response{
		Status:        "ok",
		Service:       "aks-probe-api",
		CorrelationID: correlationID(r),
	})
}

func handleIdentityCheck(w http.ResponseWriter, r *http.Request) {
	ok := os.Getenv("AZURE_CLIENT_ID") != "" &&
		os.Getenv("AZURE_TENANT_ID") != "" &&
		os.Getenv("AZURE_FEDERATED_TOKEN_FILE") != ""

	status := http.StatusOK
	state := "ok"

	if !ok {
		status = http.StatusServiceUnavailable
		state = "error"
	}

	writeJSON(w, status, response{
		Status:           state,
		Service:          "aks-probe-api",
		CorrelationID:    correlationID(r),
		WorkloadIdentity: &ok,
	})
}

func handleKeyVaultCheck(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 10*time.Second)
	defer cancel()

	kvURL := os.Getenv("KEYVAULT_URL")
	if kvURL == "" {
		writeJSON(w, http.StatusInternalServerError, response{
			Status:        "error",
			Service:       "aks-probe-api",
			CorrelationID: correlationID(r),
			Error:         "KEYVAULT_URL is not configured",
		})
		return
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		writeKeyVaultError(w, r, err)
		return
	}

	client, err := azsecrets.NewClient(kvURL, cred, nil)
	if err != nil {
		writeKeyVaultError(w, r, err)
		return
	}

	pager := client.NewListSecretPropertiesPager(nil)

	// Calling NextPage proves that the pod can authenticate and is
	// authorized to access the Key Vault data plane. An empty vault is OK.
	_, err = pager.NextPage(ctx)
	if err != nil {
		writeKeyVaultError(w, r, err)
		return
	}

	ok := true

	writeJSON(w, http.StatusOK, response{
		Status:          "ok",
		Service:         "aks-probe-api",
		CorrelationID:   correlationID(r),
		KeyVaultAccess:  &ok,
	})
}

func writeKeyVaultError(w http.ResponseWriter, r *http.Request, err error) {
	log.Printf(
		"correlation_id=%s event=keyvault_access status=error error=%q",
		correlationID(r),
		err.Error(),
	)

	writeJSON(w, http.StatusServiceUnavailable, response{
		Status:        "error",
		Service:       "aks-probe-api",
		CorrelationID: correlationID(r),
		Error:         "Key Vault access failed",
	})
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		id := r.Header.Get("X-Correlation-ID")
		if id == "" {
			id = newCorrelationID()
		}

		r.Header.Set("X-Correlation-ID", id)
		w.Header().Set("X-Correlation-ID", id)

		start := time.Now()

		log.Printf(
			"correlation_id=%s method=%s path=%s event=request_start",
			id,
			r.Method,
			r.URL.Path,
		)

		next.ServeHTTP(w, r)

		log.Printf(
			"correlation_id=%s method=%s path=%s event=request_end duration_ms=%d",
			id,
			r.Method,
			r.URL.Path,
			time.Since(start).Milliseconds(),
		)
	})
}

func correlationID(r *http.Request) string {
	id := r.Header.Get("X-Correlation-ID")
	if id == "" {
		return newCorrelationID()
	}
	return id
}

func newCorrelationID() string {
	b := make([]byte, 16)

	if _, err := rand.Read(b); err != nil {
		return "correlation-id-unavailable"
	}

	return hex.EncodeToString(b)
}

func writeJSON(w http.ResponseWriter, status int, body response) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)

	if err := json.NewEncoder(w).Encode(body); err != nil {
		log.Printf("event=response_encode status=error error=%q", err.Error())
	}
}
