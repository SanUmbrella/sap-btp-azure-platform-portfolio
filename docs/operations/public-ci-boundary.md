# Public CI Boundary

Public GitHub Actions validates repository quality and provider schemas. It does not run live infrastructure integration tests.

## What Public CI May Do

- Run the public repository sanitizer.
- Check whitespace with `git diff --check`.
- Run `terraform fmt -check -recursive`.
- Copy Terraform modules to a temporary directory.
- Remove backend configuration from the temporary copy only.
- Run `terraform init -backend=false`.
- Run `terraform validate`.
- Run Go tests for the AKS probe API.
- Run Node.js syntax checks where configured.
- Check Markdown local links where configured.

## What Public CI Must Not Do

- Reach the private MinIO Terraform backend.
- Use real Terraform state.
- Run `terraform plan` or `terraform apply` against live infrastructure.
- Authenticate to Azure, SAP BTP, Cloudflare or Infisical.
- Use VPN or private routing to the lab network.
- Store backend credentials or infrastructure secrets in GitHub.

## MinIO Boundary

The real lab uses Terraform's S3-compatible backend protocol against a private MinIO deployment behind the authorized lab network boundary. GitHub-hosted runners intentionally cannot reach it.

The validation script preserves that boundary:

```text
repository Terraform source
-> temporary validation copy
-> backend configuration removed from temporary copy
-> terraform init -backend=false
-> terraform validate
-> temporary files removed on script exit
```

Real end-to-end verification is performed only from the authorized private lab environment.
