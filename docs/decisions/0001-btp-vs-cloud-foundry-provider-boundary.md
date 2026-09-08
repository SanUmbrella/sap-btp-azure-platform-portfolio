# ADR 0001: BTP vs Cloud Foundry Provider Boundary

## Status

Accepted

## Context

SAP BTP has multiple management layers. Some resources belong to account or subaccount administration, while others belong to the Cloud Foundry runtime model.

Conceptually, the SAP/btp provider fits BTP account and subaccount concerns such as role collections and destinations where appropriate. The cloudfoundry/cloudfoundry provider fits Cloud Foundry org, space, application, service-instance and route concerns.

## Decision

Split provider ownership intentionally instead of forcing all resources through one abstraction. Adopt existing resources into Terraform where possible and document provider import or read-back limitations as explicit engineering constraints.

## Consequences

The configuration better reflects platform ownership boundaries. The trade-off is that operators must understand two provider models and avoid assuming complete drift detection where provider support is limited.

## Alternatives Considered

Managing everything manually was rejected because it weakens repeatability. Forcing all resources through one provider was rejected because it hides real platform boundaries.
