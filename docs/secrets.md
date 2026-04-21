# Managing secrets and API tokens

**Never** put tokens into:
- `home/zsh.nix` (or any `.nix` file in this repo) — public on GitHub.
- `home.sessionVariables` — lands in the Nix store, which is world-readable.
- `/etc/environment` — also world-readable.

Use one of the two patterns below.

## Pattern A — global tokens via `~/.config/secrets.env`

For tokens you want available everywhere (e.g. `GITHUB_TOKEN`, `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`).

Create the file once, outside the repo and outside the Nix store:

```bash
mkdir -p ~/.config
cat > ~/.config/secrets.env <<'EOF'
export GITHUB_TOKEN=ghp_xxxxx
export ANTHROPIC_API_KEY=sk-ant-xxxxx
export OPENAI_API_KEY=sk-xxxxx
EOF
chmod 600 ~/.config/secrets.env
```

`home/zsh.nix` already sources this file from `initContent` if it exists:

```nix
[ -f ~/.config/secrets.env ] && source ~/.config/secrets.env
```

Open a new shell — the variables are in `env`. No rebuild needed when you add or change a token; just reopen the shell (or `source ~/.config/secrets.env`).

Properties:
- Readable only by your user (`chmod 600`).
- Lives in `$HOME`, not in `/nix/store`.
- Not tracked by git — the file isn't in the repo at all.

## Pattern B — project-specific tokens via `direnv`

For tokens bound to a single project (DB URLs, project API keys).

`direnv` + `nix-direnv` are enabled via `home/development.nix`, so this works out of the box.

```bash
cd ~/work/some-project
cat > .envrc <<'EOF'
export API_KEY=xyz
export DATABASE_URL=postgres://...
EOF

# Make sure .envrc is gitignored in that project
echo '.envrc' >> .gitignore

direnv allow
```

Properties:
- Variables are loaded automatically on `cd` into the project directory.
- Unloaded on `cd` out — no pollution of your global environment.
- Shadowing: a project `.envrc` can override values from `~/.config/secrets.env`.

## When to use which

| Situation | Pattern |
|-----------|---------|
| CLI tool that runs anywhere (`gh`, `claude`, `openai`) | A |
| Token only relevant inside one project | B |
| Shared team secret | [sops-nix](https://github.com/Mic92/sops-nix) — out of scope for this minimal flake |

## Common mistakes

- **Committing `secrets.env` by accident**: keep it in `~/.config/`, never inside the repo.
- **Putting tokens into `shellAliases`**: aliases end up in the Nix store via the home-manager-managed `.zshrc`.
- **Editing `~/.zshrc` manually**: home-manager overwrites it on every switch. Use `initContent` in `home/zsh.nix` if you need to add *non-secret* shell code.
