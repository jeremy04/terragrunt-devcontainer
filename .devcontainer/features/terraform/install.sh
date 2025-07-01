#!/bin/bash

set -e

echo "Installing tfenv and tgenv..."

# Install tfenv (Terraform version manager)
if [[ ! -d "$HOME/.tfenv" ]]; then
  git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
fi

# Install tgenv (Terragrunt version manager)  
if [[ ! -d "$HOME/.tgenv" ]]; then
  git clone --depth=1 https://github.com/cunymatthieu/tgenv.git ~/.tgenv
fi

# Export PATH to make tools available
export PATH="$HOME/.tfenv/bin:$HOME/.tgenv/bin:$PATH"

# Install versions from .terraform-version and .terragrunt-version if they exist
if [ -f "/workspace/.terraform-version" ]; then
    echo "Installing Terraform version from .terraform-version..."
    tfenv install
    tfenv use
else
    echo "Installing latest Terraform..."
    tfenv install latest
    tfenv use latest
fi

if [ -f "/workspace/.terragrunt-version" ]; then
    echo "Installing Terragrunt version from .terragrunt-version..."
    tgenv install
    tgenv use
else
    echo "Installing latest Terragrunt..."
    tgenv install latest
    tgenv use latest
fi

echo "tfenv and tgenv installation complete!"