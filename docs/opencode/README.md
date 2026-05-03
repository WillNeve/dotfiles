# OpenCode Architecture

This doc describes how OpenCode is configured in this dotfiles repo and how global and repo-local behavior composes.

## Goals

- Keep global defaults in dotfiles.
- Allow repos to override behavior where needed.
- Keep skills globally available without forcing stack-specific skills everywhere.

## Source of Truth

- Global OpenCode config: `opencode/opencode.json`
- Global agent instructions: `opencode/AGENTS.md`
- Canonical global skills: `opencode/skills/`
- Installer wiring: `install.sh`

## Install-Time Wiring

`install.sh` sets symlinks so dotfiles remains the primary source:

- `~/.config/opencode/opencode.json` -> `~/code/dotfiles/opencode/opencode.json`
- `~/.config/opencode/AGENTS.md` -> `~/code/dotfiles/opencode/AGENTS.md`
- `~/.agents/skills` -> `~/code/dotfiles/opencode/skills`
- `~/.config/opencode/skills` -> `~/.agents/skills`

This makes `~/.agents/skills` the canonical runtime location, with `~/.config/opencode/skills` as compatibility alias.

## Config Layering Model

OpenCode merges config from multiple locations. At a high level:

1. Global defaults from `~/.config/opencode/opencode.json`
2. Project overrides from repo `opencode.json`
3. Project directory overrides from `.opencode/` (agents, commands, skills, etc.)

Result: dotfiles defines baseline behavior, while each repository can override or extend commands, skills, and model behavior.

## Skills Architecture

### Global skills

Global skills live in `opencode/skills/` and are installed to `~/.agents/skills` via symlink.

### Repo-local skills

Repos can add skills in:

- `.opencode/skills/`
- `.agents/skills/`
- `.claude/skills/` (OpenCode compatibility path)

These are discovered by OpenCode for that repo session and can augment or override global behavior.

### Scope policy

- Keep global skills broadly reusable and tool-agnostic.
- Keep stack- or repo-specific skills local to the relevant repository.
- Avoid globally installing skills that require optional MCP/tooling not present everywhere.

## Commands Architecture

Lifecycle commands are defined globally in `opencode/opencode.json` under `command`:

- `/define`
- `/plan`
- `/build`
- `/verify`
- `/review`
- `/ship`

Each command is a lightweight entrypoint that routes to the corresponding skill workflow. Repos can define local commands in `.opencode/commands/` to customize behavior without changing global defaults.

## Operating Notes

- Restart OpenCode sessions after changing global config/skills.
- Use `opencode debug config` to inspect merged config.
- Use `opencode debug skill` to inspect skill discovery and source locations.
