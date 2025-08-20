# Repository Guidelines

## Project Structure & Module Organization

- Root collection: `i_cant_computer/vanilla_rhel_deploy`
- Roles: `roles/*` (e.g., `roles/system_update/tasks/main.yml`)
- Templates: `roles/*/templates/*.j2`; Files: `roles/*/files/*`; Defaults/Vars
  under `defaults/` and `vars/`
- Metadata: `galaxy.yml`, `meta/runtime.yml`; Changelog: `CHANGELOG.md`
- Plugins: `plugins/` (reserved for future collection plugins)

## Build, Test, and Development Commands

- Build collection tarball:
  `cd i_cant_computer/vanilla_rhel_deploy && ansible-galaxy collection build`
- Install locally:
  `ansible-galaxy collection install ./i_cant_computer-vanilla_rhel_deploy-*.tar.gz -p ~/.ansible/collections`
- Dry‑run a role via a minimal playbook:
  `ansible-playbook -i localhost, -c local playbook.yml --check --diff`
- Lint (recommended): `ansible-lint i_cant_computer/vanilla_rhel_deploy` and
  `yamllint i_cant_computer/vanilla_rhel_deploy`

## Coding Style & Naming Conventions

- YAML: 2‑space indent; wrap lines at ~100 cols
- Variables: `snake_case`; role names use underscores (e.g., `system_update`)
- Prefer FQCN for modules/collections (e.g., `ansible.builtin.systemd_service`)
- Jinja2: minimal logic in templates; keep defaults in `defaults/main.yml`
- Idempotence: tasks safe to re‑run; use `creates`, `removes`, and
  `changed_when` sensibly

## Testing Guidelines

- No Molecule scenarios in repo; use `--check --diff` locally for roles
- Add temporary playbooks under a local `scratch/` (not committed) to exercise
  roles
- Aim for meaningful diffs and zero changes on second run (idempotent)

## Commit & Pull Request Guidelines

- Use Conventional Commits (e.g., `feat:`, `fix:`, `docs:`); keep subject ≤72
  chars
- PRs: include scope (roles/files touched), motivation, and testing evidence
  (`--check --diff` output snippet)
- Update `CHANGELOG.md` for user‑visible changes; avoid bumping `galaxy.yml`
  version in PRs unless releasing

## Security & Configuration Tips

- Never commit secrets; store sensitive data in vaulted files (e.g.,
  `group_vars/*/vault.yml`)
- Protect LUKS keys/headers and recovery material; limit permissions on
  controller and targets
- Target platform: EL9; collection requires `ansible-core >=2.16` per
  `meta/runtime.yml`
