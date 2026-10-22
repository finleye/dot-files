#!/bin/csh

ln -s ./git/.* ~
ln -s ./tmux.conf ~/.tmux.conf
ln -s ./tmuxinator ~
ln -s ./vim/.* ~
# ln -s ./vim/.vimrc ~
# ln -s ./vim/.vimrc.after ~
# ln -s ./vim/.vimrc.before ~
# ln -s ./vim/.vimrc.bundles ~
ln -s ./zsh/.zshrc ~
ln -s /Users/corey.finley/dot-files/nvim/init.lua ~/.config/nvim/init.lua

# herdr (only config.toml; the rest of ~/.config/herdr is runtime state)
mkdir -p ~/.config/herdr
ln -sf ~/dot-files/herdr/config.toml ~/.config/herdr/config.toml

# pi (only config; auth.json, models-store.json, sessions, caches stay local)
mkdir -p ~/.pi/agent/extensions
ln -sf ~/dot-files/pi/agent/settings.json ~/.pi/agent/settings.json
ln -sf ~/dot-files/pi/agent/vision.json ~/.pi/agent/vision.json
ln -sf ~/dot-files/pi/agent/extensions/bits-pet.ts ~/.pi/agent/extensions/bits-pet.ts
ln -sf ~/dot-files/pi/agent/extensions/session-cost-prompt.ts ~/.pi/agent/extensions/session-cost-prompt.ts

# claude (settings, status line and bits hooks; herdr-agent-state.sh comes from
# `herdr integration install claude`; .claude.json, history and caches stay local)
mkdir -p ~/.claude/hooks
ln -sf ~/dot-files/claude/settings.json ~/.claude/settings.json
ln -sf ~/dot-files/claude/statusline-command.sh ~/.claude/statusline-command.sh
ln -sfn ~/dot-files/claude/hooks/bits ~/.claude/hooks/bits
