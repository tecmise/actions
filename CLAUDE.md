# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is Tecmise's centralized CI/CD and infrastructure repository. It provides:
- **Reusable GitHub Actions** (composite actions in `.github/actions/`)
- **Reusable workflow templates** (called by other repos via `workflow_call` in `.github/workflows/`)
- **Terraform modules** for AWS infrastructure (`terraform/`)
- **Python utility scripts** (`.github/scripts/`)

## Architecture Overview

### GitHub Actions (`.github/actions/`)
Each subdirectory is a composite action with an `action.yaml`. Key ones:
- `aws-authenticate` — OIDC-based role assumption; branch name (`main`, `sandbox`, etc.) determines which AWS role to assume
- `discord-notifier` — sends embed notifications with severity levels (info/warn/error)
- `versionament` — parses semver git tags (vX.Y.Z) and outputs major/minor/patch
- `hash-content` — wraps `md5_calculator.py` to detect content changes
- `terraform_plan/apply/init/destroy` — composite Terraform orchestration with S3 backend and plugin caching
- `upload-artifact` / `download-artifact` — S3-based artifact storage (separate from GitHub native artifacts)

### Reusable Workflows (`.github/workflows/`)
All workflows use `workflow_call` trigger so they can be called from other repositories. The main build workflows:
- `building-go.yaml` — Go builds; supports Lambda mode (arm64, zipped `bootstrap`) and container mode (Linux, vendored)
- `building-go-v2.yaml` — matrix-based multi-app Go builds using YAML app config
- `building-maven.yaml` — Java/Maven builds targeting Lambda S3 buckets
- `building-nuxt.yaml` — Node.js/Nuxt static site builds deploying to S3 + SSM updates
- `building-docker-image.yaml` — ECR image builds with existing tag detection
- `flyway-migration.yaml` — database schema migrations with validation step before apply
- `generate-hashcode.yaml` — MD5-based change detection against SSM-stored hashes
- `terraform-plan.yaml` / `terraform-apply.yaml` — Terraform orchestration workflows
- `terraform-apply-api-gateway.yaml` — generates API Gateway Terraform from Python script then applies

### Terraform Modules (`terraform/`)
AWS-focused modules: `lambda`, `fargate-container`, `api-gateway-resource-verbs`, `async-event-channel`, `async-event-channel-consumer`, `methods-with-cors`, `lambda_health`, `redis`.

### Python Scripts (`.github/scripts/`)
- `md5_calculator.py` — takes JSON input `{"source": ".", "ignore_path": [...]}`, returns MD5 hex digest of directory contents
- `terraform/api-gateway.py` — generates Terraform HCL for API Gateway routes from route model definitions

### Docker Runner (`.github/docker/Dockerfile`)
Alpine 3.19-based custom self-hosted runner image. Timezone set to `America/Sao_Paulo`.

## Key Design Patterns

**AWS Authentication**: All AWS access uses OIDC via `aws-oidc-role` GitHub secret + branch-conditional role assumption. Never uses static credentials.

**Artifact Flow**: Build artifacts go to S3 (not just GitHub artifacts). Terraform variable files are also passed via S3 artifacts between jobs.

**Change Detection**: `generate-hashcode.yaml` calculates MD5 of source files and compares against SSM Parameter Store — downstream workflows skip if no changes.

**Runner Labels**: Self-hosted runners are categorized (`building`, `infrastructure`, `release`, `s4s`). The `running-on` action resolves the correct runner label from input category + name.

**Private Go Modules**: Go builds write a `.netrc` file for `github.com/tecmise/*` private module access using the calling workflow's GitHub token.

## Common Build Commands

### Go (Lambda)
```bash
GOOS=linux GOARCH=arm64 go build -tags lambda.norpc \
  -ldflags "-X config.Sha=$SHA" -o bootstrap ./cmd/...
zip artifact.zip bootstrap
```

### Go (Container)
```bash
go build -a -buildvcs=false -installsuffix cgo -o app ./cmd/...
```

### Maven
```bash
mvn -B clean package -DskipTests
```

### Terraform
```bash
terraform init -backend-config=bucket=<bucket>
terraform plan
terraform apply -auto-approve
```

### MD5 Hash Script
```bash
python .github/scripts/md5_calculator.py '{"source": ".", "ignore_path": ["terraform", ".github", ".idea", ".git"]}'
```

### API Gateway Terraform Generation
```bash
python .github/scripts/terraform/api-gateway.py
```
