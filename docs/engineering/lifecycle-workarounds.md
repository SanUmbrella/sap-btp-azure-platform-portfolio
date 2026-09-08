# Lifecycle Workarounds

Terraform lifecycle workarounds should be documented with the same care as primary architecture decisions.

## `ignore_changes = [app]`

The reference implementation includes `ignore_changes = [app]` on selected Cloud Foundry service credential bindings.

Why it exists:

```text
cloudfoundry_app.backend.id
-> known after apply during plan
-> binding app reference appears unstable
-> binding replacement planned
```

What it prevents:

```text
unintended delete/create of service credential bindings during normal app lifecycle changes
```

What risk it introduces:

```text
an independent app replacement may require explicit binding review or controlled recreation
```

When it is acceptable in the lab:

| Scenario | Risk posture |
| --- | --- |
| Normal in-place app deployment | Acceptable with verification. |
| Full destroy/rebuild | Acceptable because bindings are recreated with the stack. |
| Independent app replacement without binding review | Requires explicit review. |

This workaround is not presented as a universal best practice. It is a documented response to observed provider behavior during adoption.
