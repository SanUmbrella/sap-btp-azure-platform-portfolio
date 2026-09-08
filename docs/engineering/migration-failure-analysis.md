# Migration Failure Analysis

This document captures migration and adoption cases that are more useful than a clean `terraform apply` transcript because they show how the implementation handled real platform behavior.

## Case 1: XSUAA Parameters

Problem:

```text
XSUAA service parameters could not be fully read back.
```

Analysis:

The service broker/API did not expose all instance parameters needed for full drift comparison. Terraform could still manage desired configuration and lifecycle, but it could not prove every remote parameter value after creation.

Outcome:

The limitation was documented and not treated as a provider bug.

## Case 2: Cloud Foundry App ID Unknown During Plan

Problem:

```text
cloudfoundry_app.backend.id
-> known after apply
-> service credential bindings planned for replacement
```

Analysis:

Bindings reference the application ID. If the provider marks the app ID as unknown during a plan, downstream bindings can become ForceNew replacements even when the operator did not intend to recreate bindings.

Observed plan JSON shape:

```text
replace_paths = [["app"]]
after_unknown.app = true
```

Outcome:

A targeted lifecycle workaround was applied and documented. This issue is a candidate for upstream reproduction against the current Cloud Foundry provider.

## Case 3: Role Collection Assignment Adoption

Problem:

```text
Existing role collection assignment could not be imported.
```

Analysis:

The resource could be declared, but the adoption path did not support direct import of the existing assignment. Manual and Terraform ownership could not be allowed to conflict.

Outcome:

The migration checked identity, origin and role collection, removed the manual assignment, recreated it through Terraform, and verified access afterward.

## Case 4: Stable Route Migration

Problem:

```text
Manual random-route deployment did not match the desired Terraform-managed stable route model.
```

Analysis:

AppRouter redirect behavior and backend route references need stable route configuration. The migration had to avoid breaking redirect URI expectations while moving away from manual route assumptions.

Outcome:

The final public reference implementation documents stable Terraform-managed routes and keeps the older manifest pattern in evolution documentation only.
