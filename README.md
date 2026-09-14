# Automated Multi-Environment Azure Infrastructure with Terraform + Jenkins CI/CD

A self-contained Infrastructure-as-Code project that provisions a 3-tier Azure
environment (network → compute → database, with centralized secrets in Key
Vault) using modular Terraform, deployed through a Jenkins pipeline with a
manual approval gate before any apply.

Runs entirely **locally** against the [floci-az](https://floci.io/az/) Azure
emulator for development/demo purposes — the same code targets real Azure by
swapping a handful of provider values.

## Architecture

```
                         ┌─────────────────────────────┐
                         │        Resource Group        │
                         │                              │
   Internet ──▶ Public IP│  ┌────────────┐   ┌────────┐ │
                         │  │  App VM     │   │  Key   │ │
                         │  │ (Nginx,     │──▶│ Vault  │ │
                         │  │  Ubuntu)    │   │(secrets)│ │
                         │  └─────┬──────┘   └────────┘ │
                         │        │  App Subnet          │
                         │        │  (NSG: 22, 80)       │
                         │  ══════╪══════════════════    │
                         │        │  DB Subnet            │
                         │        ▼  (delegated)          │
                         │  ┌────────────────────┐        │
                         │  │ PostgreSQL Flexible │        │
                         │  │ Server (private)    │        │
                         │  └────────────────────┘        │
                         └─────────────────────────────┘
                                     VNet
```

**Modules** (`terraform/modules/`):
- `networking` — Resource Group, VNet, app/db subnets, NSG
- `keyvault` — Key Vault + auto-generated DB admin password stored as a secret
- `database` — PostgreSQL Flexible Server (private, VNet-integrated) + private DNS zone
- `compute` — Linux VM (Ubuntu, SSH key auth) bootstrapped via cloud-init

**Environments** (`terraform/environments/`): `dev` and `prod` — same modules,
separate state files, separate sizing (see [state isolation](#why-separate-state-per-environment) below).

## Why this project is worth putting on a resume

- Demonstrates **modular Terraform design** (not one giant `main.tf`) — the
  kind of structure real teams use to keep environments consistent and DRY.
- Demonstrates **secrets management done correctly** — the DB password is
  generated with `random_password`, stored only in Key Vault, and never
  appears in `.tfvars`, `.tf` files, or Jenkins console output.
- Demonstrates **environment isolation** — dev and prod have separate state
  files and independently-sized infrastructure, not a shared workspace with
  conditionals sprinkled through the code.
- Demonstrates a **real CI/CD gate** — Jenkins runs `fmt`/`validate`/a
  security scan/`plan` automatically, then requires a human to click
  "Proceed" before anything is actually applied to prod.
- Runs **without needing a real Azure subscription** to demo, using a local
  Azure-compatible emulator — a good talking point about resourcefulness and
  cost-conscious development in an interview.

## Prerequisites

- Terraform >= 1.5
- Jenkins with the Pipeline plugin
- `tfsec` installed on the Jenkins agent (`brew install tfsec` / see tfsec docs for Linux)
- [floci-az](https://floci.io/az/) running locally (see main conversation history for setup), or a real Azure subscription

## Local setup (against floci-az)

```bash
cd terraform/environments/dev

# Generate an SSH key if you don't have one
ssh-keygen -t rsa -b 4096 -f ~/.ssh/devopsdemo_rsa -N ""

terraform init
terraform plan -var="ssh_public_key=$(cat ~/.ssh/devopsdemo_rsa.pub)"
terraform apply -var="ssh_public_key=$(cat ~/.ssh/devopsdemo_rsa.pub)"
```

## Switching to real Azure

1. In `providers.tf`, replace the `backend "local"` block with an `azurerm`
   remote-state backend (Storage Account) — see the earlier project notes on
   state isolation per environment.
2. In `variables.tf`, replace the `azure_*` defaults with real Service
   Principal credentials (ideally injected via Jenkins Credentials / OIDC,
   never committed).
3. Remove `resource_provider_registrations = "none"` if you want Terraform
   to auto-register providers on your real subscription (or keep it and
   register providers manually — see Azure's least-privilege guidance).

## Jenkins pipeline

The `Jenkinsfile` at the repo root defines a parameterized pipeline:

- **ENVIRONMENT**: `dev` or `prod`
- **ACTION**: `plan`, `apply`, or `destroy`

Stages: Checkout → Init → `fmt -check` → `validate` → `tfsec` scan → `plan`
→ **manual approval** (only for apply/destroy) → apply or destroy.

Set these up first in Jenkins under **Manage Jenkins → Credentials**:
`azure-subscription-id`, `azure-tenant-id`, `azure-client-id`, `azure-client-secret`.

## Why separate state per environment

Each environment folder has its own `providers.tf` with its own backend
`path`/`key`, so a mistake or destructive action in dev's state cannot touch
prod's state. See `docs/design-decisions.md` for the fuller reasoning
(workspaces vs. separate state vs. separate backends).

## Suggested resume bullets

> Built a modular Terraform + Jenkins CI/CD pipeline provisioning a 3-tier
> Azure environment (VNet, Linux VM, PostgreSQL Flexible Server, Key Vault)
> across isolated dev/prod state, with automated plan/validate/security-scan
> stages and a manual approval gate before apply.

> Implemented secrets-management best practices using Terraform's
> `random_password` and Azure Key Vault, eliminating plaintext credentials
> from version control and CI logs.

> Designed a reusable Terraform module library (networking, compute,
> database, key vault) consumed by independent environment configurations,
> reducing environment provisioning time and code duplication.

## Next steps to extend this further

- Add `terraform-docs` generation as a pipeline stage
- Add Azure Monitor / Log Analytics module for observability
- Add a blue/green or canary deploy stage for the app tier
- Swap the single VM for a VM Scale Set behind a Load Balancer
