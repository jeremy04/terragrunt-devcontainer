# CLAUDE.md - Project Knowledge Base

This file contains essential knowledge, best practices, and lessons learned for working with this Terragrunt/Terraform project.

## 🚨 GOLDEN RULES

### 1. Always Test Before Changes
**CRITICAL**: Before making ANY changes to Terraform/Terragrunt files, ALWAYS run:
```bash
cd /workspace/aws-account-development/dev
terragrunt init
terragrunt plan
```
This is the **GOLD STANDARD** for ensuring everything works. If these commands fail, DO NOT proceed with changes.

### 2. Working Directory
**ALWAYS** run terragrunt commands from: `/workspace/aws-account-development/dev`
- This is the only verified working directory
- Other directories may not have proper configurations

### 3. Test After Changes
After making any modifications, immediately run:
```bash
cd /workspace/aws-account-development/dev
terragrunt init  # Re-initialize if module sources changed
terragrunt plan  # Verify plan generates successfully
```

### 4. Commit Standards (FOR CLAUDE IN CODESPACE)
**AUTONOMOUS OPERATION**: In GitHub Codespace, Claude should:
- ✅ **Commit freely** when gold standard passes (`terragrunt init` + `terragrunt plan` succeed)
- ✅ **Push branches** and **edit PRs** without asking permission
- ✅ **Make atomic commits** - each commit must be cohesive and self-contained
- ✅ **Use conventional commit format** - follow conventional commit standard
- ✅ **Ensure every commit works** - never commit broken/partial changes
- ❌ **Never commit** if gold standard fails - always fix issues first

**Atomic Commit Rules**:
- Each commit represents a complete, working change
- Related changes bundled together (e.g., parameter update + documentation)
- Can be safely reverted without breaking other functionality
- Gold standard must pass before any commit

**Conventional Commit Format**:
```
<type>(<scope>): <description>

<body>

<footer>
```
- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `upgrade`
- **Scope**: optional, e.g., `rds`, `redis`, `terragrunt`, `modules`
- **Description**: imperative mood, lowercase, no period

## 🛠️ How to Create a Pull Request in Codespace

### Prerequisites
- Ensure you're on a feature branch (not main)
- All changes are committed

### Step-by-Step Process
```bash
# 1. Check git status
git status

# 2. Stage and commit changes (if needed)
git add .
git commit -m "$(cat <<'EOF'
Description of changes

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# 3. Push branch to remote
git push -u origin your-branch-name

# 4. Create PR using GitHub CLI
gh pr create --title "Your PR Title" --body "$(cat <<'EOF'
## Summary
- Brief description of changes

## Changes Made
- Detailed list of modifications

## Test Results
- ✅ terragrunt init succeeds
- ✅ terragrunt plan succeeds

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"
```

## 🏗️ Project Architecture

### Development Environment Setup
The project includes automatic setup of development tools via `/workspace/install.sh`:

#### Version Management
- **Terraform**: `latest:^1.12` (managed by tfenv)
- **Terragrunt**: `0.69.7` (managed by tgenv)
- Version files: `.terraform-version`, `.terragrunt-version`

#### LocalStack Services
The dev container includes comprehensive AWS service emulation:
```yaml
services: s3,ssm,lambda,iam,sts,ec2,ecs,rds,route53,cloudformation,
         cloudwatch,dynamodb,secretsmanager,ses,sns,sqs,apigateway,apigatewayv2
endpoint: http://localstack:4566
```

#### Development Services
- **Redis**: localhost:6381 (for local development)
- **PostgreSQL**: localhost:5432 (for local development)
- **LocalStack**: localhost:4566 (AWS services emulation)

#### Claude Code CLI Installation
```bash
# Automatic installation in install.sh
npm install -g @anthropic-ai/claude-code
```

**Features**:
- ✅ **One-time installation** - Automatically installs Claude Code CLI if not present
- ✅ **Version detection** - Skips installation if already present
- ✅ **Update handling** - Updates to official version if different CLI is detected
- ✅ **Status reporting** - Shows current version when already installed


**What install.sh provides**:
- Shell customizations (git branch in prompt, history settings)
- LocalStack AWS aliases (`awslocal`)
- Terraform/Terragrunt environment paths (tfenv/tgenv)
- Dummy AWS credentials for LocalStack development
- **Claude Code CLI** for AI-powered development assistance

#### Environment Variables
```bash
# LocalStack configuration
export AWS_ENDPOINT_URL=http://localstack:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

# Development services
export REDIS_URL=redis://redis:6379
```

### Directory Structure
```
/workspace/
├── aws-account-development/
│   ├── dev/                    # Main working directory
│   │   └── terragrunt.hcl     # Terragrunt configuration
│   ├── dev-aws/               # Alternative dev environment
│   └── shared.hcl             # Shared dev account config
├── aws-account-live/
│   ├── uat/                   # UAT environment
│   ├── prd/                   # Production environment
│   └── shared.hcl             # Shared live account config
├── modules/
│   ├── app/                   # Main application module
│   ├── rds/                   # RDS database module
│   ├── redis/                 # Redis cache module
│   └── route53/               # DNS module
├── .devcontainer/             # Dev container configuration
├── .terraform-version         # Terraform version spec
├── .terragrunt-version        # Terragrunt version spec
└── install.sh                 # Environment setup script
```

### Module Dependencies
- **app** module references: `rds`, `redis`, `route53`
- All modules are copied together using Terragrunt's `include_in_copy`
- Relative paths used: `../rds`, `../redis`, `../route53`

## 🔧 Key Technical Solutions

### 1. Module Path Resolution
**Problem**: Terraform doesn't allow variables in module sources
```hcl
# ❌ This doesn't work
module "rds" {
  source = "${var.modules_path}/rds"
}

# ❌ This doesn't work  
module "rds" {
  source = "${path.root}/modules/rds"
}
```

**Solution**: Use Terragrunt functions and relative paths
```hcl
# In terragrunt.hcl
terraform {
  source = "${get_terragrunt_dir()}/../../modules//app"
  
  include_in_copy = [
    "${get_terragrunt_dir()}/../../modules/rds",
    "${get_terragrunt_dir()}/../../modules/redis", 
    "${get_terragrunt_dir()}/../../modules/route53"
  ]
}

# In modules/app/main.tf
module "rds" {
  source = "../rds"  # Relative path works after copying
}
```

### 2. Terragrunt Functions
- `get_terragrunt_dir()`: Returns current terragrunt.hcl directory
- Double slash `//` in source: Copies entire directory tree
- `include_in_copy`: Explicitly copies additional directories

### 3. Common Module Issues & Fixes

#### RDS Module
```hcl
# ❌ Old/broken configuration
module "rds" {
  create_random_password = false  # Unsupported parameter
  # Missing family parameter
}

# ✅ Current configuration (PostgreSQL 17.5)
module "rds" {
  source = "terraform-aws-modules/rds/aws"
  
  engine         = "postgres"
  engine_version = "17.5"        # Latest PostgreSQL version
  family         = "postgres17"  # Required parameter family
  # create_random_password removed
  
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.kms_key_id
}

# 📝 PostgreSQL Version History
# - Started with: PostgreSQL 14.9 (family: postgres14)  
# - Upgraded to: PostgreSQL 17.5 (family: postgres17) - 2025-07-07
#   AWS RDS supports PostgreSQL 17.5 as latest minor version
```

#### Redis Module
```hcl
# ❌ Old/deprecated syntax
resource "aws_elasticache_replication_group" "redis" {
  replication_group_description = "Redis for Sidekiq"  # Deprecated
}

# ✅ Modern syntax
resource "aws_elasticache_replication_group" "redis" {
  description = "Redis for Sidekiq"  # Current parameter
}
```

## 🚫 What Doesn't Work

### 1. Dynamic Module Sources
```hcl
# ❌ All of these fail
module "example" {
  source = "${var.modules_path}/example"
  source = "${path.root}/modules/example"  
  source = "${path.module}/../example"
}
```

### 2. Hardcoded Absolute Paths
```hcl
# ❌ Not portable
module "rds" {
  source = "/workspace/modules/rds"
}
```

### 3. Wrong Working Directory
```bash
# ❌ Don't run from these locations
cd /workspace && terragrunt plan
cd /workspace/modules && terragrunt plan

# ✅ Always use this location
cd /workspace/aws-account-development/dev && terragrunt plan
```

## ✅ Best Practices

### 1. Module Development
- Always use relative paths between sibling modules
- Test module changes with `terragrunt plan` before committing
- Use modern Terraform syntax and current provider versions

### 2. Terragrunt Configuration
- Use `get_terragrunt_dir()` for dynamic paths
- Use `include_in_copy` when modules reference each other
- Double slash `//` for copying entire directory trees

### 3. Git Workflow
- Work on feature branches
- **Commit autonomously** when gold standard passes (in Codespace)
- Always test before and after changes
- Use GitHub CLI for PR creation and updates
- Push branches without asking permission (in Codespace)

### 4. Testing Protocol
```bash
# Before making changes
cd /workspace/aws-account-development/dev
terragrunt init
terragrunt plan

# Make your changes...

# After making changes
cd /workspace/aws-account-development/dev
terragrunt init  # If module sources changed
terragrunt plan  # Should succeed without errors
```

## 🐛 Common Errors & Solutions

### Error: "Unreadable module directory"
**Cause**: Module path doesn't exist or isn't copied properly
**Solution**: Check `include_in_copy` in terragrunt.hcl

### Error: "Variables not allowed" in module source
**Cause**: Trying to use variables/expressions in module source
**Solution**: Use static relative paths and Terragrunt functions

### Error: "Missing required argument" 
**Cause**: Module using outdated parameters
**Solution**: Check module documentation and update parameters

### Error: "Unsupported argument"
**Cause**: Using deprecated parameters
**Solution**: Update to current parameter names

## 📚 Resources Created

When `terragrunt plan` succeeds, it should show ~8 resources:
- ECS execution IAM role and policy attachment
- RDS PostgreSQL 17.5 instance with monitoring role
- ElastiCache Redis replication group
- Route53 DNS record
- DB parameter group and subnet group

**Note**: Actual resource creation is conditional based on `use_localstack` variable. When `true`, most ECS resources are skipped for local development.

## 🔍 Debugging Tips

1. **Always check module sources**: Ensure paths are correct
2. **Use terragrunt init**: Re-run when module sources change
3. **Check provider versions**: Ensure compatibility
4. **Read error messages carefully**: Usually point to exact issue
5. **Test incrementally**: Make small changes and test frequently

## 📝 Commit Message Template (Conventional Commits)

```
<type>(<scope>): <description>

Detailed explanation of what was changed and why.

✅ Tested: terragrunt init and plan succeed
✅ All modules resolve correctly
✅ Atomic commit - cohesive and self-contained

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Conventional Commit Examples
```bash
# Feature addition
feat(rds): add PostgreSQL 17 support with parameter family

# Bug fix
fix(redis): replace deprecated replication_group_description parameter

# Documentation
docs(claude): add autonomous operation guidelines for Codespace

# Infrastructure upgrade
upgrade(rds): PostgreSQL 14.9 to 17.5 with family compatibility

# Configuration change
chore(terragrunt): implement dynamic module paths with include_in_copy

# Refactoring
refactor(modules): standardize relative path references
```

## 🤖 Claude Codespace Guidelines

### Autonomous Operation Rules
When working in GitHub Codespace, Claude should operate with autonomy:

1. **Gold Standard First**: Always validate with `terragrunt init` and `terragrunt plan`
2. **Atomic Commits**: Bundle related changes together in single commits
3. **Commit Freely**: No need to ask permission when tests pass
4. **Push Branches**: Update remote branches automatically
5. **Edit PRs**: Update PR descriptions and manage pull requests
6. **Never Break**: Only commit when everything works perfectly

### Commit Decision Flow
```
Changes Made → Run Gold Standard → Pass? → Commit & Push
                                 ↓
                               Fail → Fix Issues → Retry
```

### What Constitutes an Atomic Commit
- ✅ Feature addition with tests and documentation
- ✅ Bug fix with related parameter updates
- ✅ Version upgrade with compatibility changes
- ✅ Refactoring with updated configurations
- ❌ Partial implementations that don't work
- ❌ Mixed unrelated changes

---

**Last Updated**: 2025-07-07
**Project**: terragrunt-devcontainer
**Environment**: LocalStack + AWS