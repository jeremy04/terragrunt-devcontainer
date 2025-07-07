# install.sh
#!/usr/bin/env bash
set -euo pipefail

append="$HOME/.bashrc"
marker="# --- dotfiles-codespace-marker ---"
if ! grep -q "$marker" "$append"; then
cat >> "$append" <<'EOF'
# --- dotfiles-codespace-marker ---
# Your bashrc goodness goes here

parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ (\0)/'
}
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] \$ "

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

alias awslocal='aws --endpoint-url=http://localstack:4566'

# tfenv and tgenv paths
export PATH="$HOME/.tfenv/bin:$HOME/.tgenv/bin:$PATH"

# --- dotfiles-codespace-marker ---
EOF
  echo "▶ Appended shell customizations to ~/.bashrc"
fi

# -----------------------------------------------------------------------------
# Ensure dummy AWS profile exists (for LocalStack / offline dev)
# Runs as the Codespace user
# -----------------------------------------------------------------------------
AWS_DIR="$HOME/.aws"
if [[ ! -f "$AWS_DIR/credentials" ]]; then
  mkdir -p "$AWS_DIR"

  cat > "$AWS_DIR/credentials" <<'EOF'
[default]
aws_access_key_id = dummy
aws_secret_access_key = dummy
EOF

  cat > "$AWS_DIR/config" <<'EOF'
[default]
region = us-east-1
output = json
EOF

  echo "✔️  Created dummy AWS profile in $AWS_DIR"
fi

# -----------------------------------------------------------------------------
# Ensure Claude Code CLI is installed globally
# Provides the 'claude' command for AI-powered development
# -----------------------------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  echo "▶ Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
  echo "✔️  Claude Code CLI installed successfully"
elif ! claude --version 2>/dev/null | grep -q "Claude Code"; then
  echo "▶ Updating to official Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
  echo "✔️  Claude Code CLI updated successfully"
else
  CLAUDE_VERSION=$(claude --version 2>/dev/null | head -n1)
  echo "✔️  Claude Code CLI already installed: $CLAUDE_VERSION"
fi