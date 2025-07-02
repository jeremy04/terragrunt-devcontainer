# terragrunt-devcontainer

## Overview

**terragrunt-devcontainer** is an experimental project that uses [Claude Code](https://www.anthropic.com/claude-code) to generate a typical [Terragrunt](https://terragrunt.gruntwork.io/)-powered Rails application, designed for deployment to AWS. The setup targets a medium-sized company with a multi-environment and multi-AWS account infrastructure.

## Features

- DRY, maintainable Terraform/Terragrunt configurations
- Multi-account, multi-environment AWS setup (dev, uat, prd, etc.)
- Dev Container support for reproducible local development
- Example Rails app infrastructure (ECS, RDS, Redis, Route53)
- Local AWS emulation with LocalStack

## Getting Started

1. **Open in a Codespace**

   - Visit [https://github.com/jeremy04/terragrunt-devcontainer/](https://github.com/jeremy04/terragrunt-devcontainer/)
   - Click the **Code** dropdown, then **Create codespace on main**

   This will launch a ready-to-use development environment in your browser, with Terragrunt, AWS CLI, and all dependencies pre-installed.

2. **Local Development (optional)**

   - Alternatively, clone the repo and open it in VS Code with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [LocalStack](https://docs.localstack.cloud/)
- [Dev Containers](https://containers.dev/)

---

*This project is for experimentation and demonstration purposes. Feedback and contributions are