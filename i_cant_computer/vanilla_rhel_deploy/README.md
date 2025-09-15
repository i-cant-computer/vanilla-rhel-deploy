# Ansible Collection — i_cant_computer.vanilla_rhel_deploy

Opinionated Ansible collection to deploy and harden RHEL‑based home‑lab servers.
It covers TPM‑backed LUKS unlock, recovery key management, auto‑mounts, core
packages, system users, Podman, virtualization, and automated updates.

## Requirements

- ansible-core: >= 2.16 (matches `meta/runtime.yml`)
- Platform: Enterprise Linux 9 family and derivatives (e.g., RHEL 9, AlmaLinux
  9, Rocky Linux 9)
- Access: SSH to target hosts with a privileged user (e.g., `ansible` in
  `wheel`)

## Compatibility

- Collection runtime: `requires_ansible: '>=2.16.0'`
- Target platforms: EL9 and derivatives (no EL8 support)
- Tested Ansible versions: 2.19 (in addition to the minimum)
- Additional notes: Functionality has also been tested on AlmaLinux 10; confirm
  whether EL10 should be considered supported.
- Per‑role minimums (when using roles standalone):
  - tpm: `min_ansible_version: '2.10'`
  - luks: `min_ansible_version: '2.10'`
  - auto_mount: `min_ansible_version: '2.10'`
  - core: `min_ansible_version: '2.16'` (uses `ansible.builtin.systemd_service`)
  - system_users: `min_ansible_version: '2.10'`
  - podman: `min_ansible_version: '2.16'` (uses
    `ansible.builtin.systemd_service`)
  - virtualization: `min_ansible_version: '2.10'`
  - system_update: `min_ansible_version: '2.10'`
  - automate_container_updates: `min_ansible_version: '2.10'`
  - automate_system_updates: `min_ansible_version: '2.16'` (uses
    `ansible.builtin.systemd_service`)

Note: When installing/using the collection, the collection‑level
`requires_ansible` applies. Per‑role minimums are relevant only if vendoring or
reusing roles outside the collection.

## Installation

- From source (build and install locally)

  ```bash
  git clone https://github.com/i-cant-computer/vanilla-rhel-deploy.git
  cd vanilla-rhel-deploy/i_cant_computer/vanilla_rhel_deploy
  ansible-galaxy collection build
  ansible-galaxy collection install ./i_cant_computer-vanilla_rhel_deploy-*.tar.gz -p ~/.ansible/collections
  ```

Distribution: Published on Ansible Galaxy only (not Automation Hub/certified).

## Using This Collection

Use fully qualified collection names (FQCN) for roles. Avoid the `collections`
keyword in playbooks. Example `update.yml`:

```yaml
---
- name: Update RHEL hosts
  hosts: rhel
  gather_facts: false
  become: true
  roles:
    - i_cant_computer.vanilla_rhel_deploy.system_update
    - i_cant_computer.vanilla_rhel_deploy.automate_system_updates
```

Inventory example (YAML):

```yaml
all:
  children:
    rhel:
      hosts:
        host1:
        host2:
```

Run the play against your inventory:

```bash
ansible-playbook -i inventory/hosts.yml update.yml
```

## Included Content

Roles (FQCN) and docs:

- `i_cant_computer.vanilla_rhel_deploy.tpm` — TPM‑backed clevis bind for LUKS
  unlock on boot. See `roles/tpm/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.luks` — Manage/verify LUKS recovery keys
  and header backups. See `roles/luks/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.auto_mount` — Auto‑mount a secondary LUKS
  filesystem at boot. See `roles/auto_mount/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.core` — Base packages, SSH hardening,
  base service accounts. See `roles/core/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.system_users` — Manage users, groups, and
  SSH keys. See `roles/system_users/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.podman` — Install Podman and prep a
  rootless service account. See `roles/podman/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.virtualization` — Install virtualization
  tooling; enable libvirt usage. See `roles/virtualization/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.system_update` — Update all packages;
  reboot if required. See `roles/system_update/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.automate_system_updates` — Configure
  `dnf-automatic` timer. See `roles/automate_system_updates/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.automate_container_updates` — Configure
  Podman auto‑update timer (user scope). See
  `roles/automate_container_updates/README.md`.
- `i_cant_computer.vanilla_rhel_deploy.automate_backups` — Configure container
  backups with Borg and email notifications. See
  `roles/automate_backups/README.md`.

Plugins

- None currently shipped. The `plugins/` tree is reserved for future use.

## Dependencies

- Collection dependencies: None (`galaxy.yml: dependencies: {}`)
- External: Roles may install/enable distribution packages and services on EL9.

## Configuration and Variables

- Variables and defaults are documented per role in each role’s README and
  `defaults/main.yml`.
- Highlights:
  - LUKS/TPM: `luks_uuid`, `luks_passphrase`, `luks_slot`, `clevis_tpm_config.*`
  - Auto‑updates: `automate_system_updates_schedule`,
    `automate_system_updates_randomize_delay`
  - Podman auto‑updates: `automate_container_updates_podman_user`,
    `automate_container_updates_schedule`,
    `automate_container_updates_randomize_delay`

## Security Notes

- Store secrets in vaulted files (e.g., `group_vars/*/vault.yml`), not in VCS.
- LUKS keys and headers are sensitive; restrict permissions on controller and
  targets.

## Support

- Community support on a best‑effort basis via GitHub Issues. No SLA or
  commercial support is provided.
- Please include `ansible --version`, OS details, playbook snippets, and
  `--check --diff` output when filing issues.

### Bug Report Template

When filing a bug, include the following (redact secrets):

```
Title: <concise summary>

Environment
- Ansible core version: output of `ansible --version`
- Collection version: output of `ansible-galaxy collection list | grep i_cant_computer`
- OS/platform of target(s): e.g., RHEL/Alma/Rocky 9.x (and controller OS)
- Python version on controller: `python3 --version`

Scope
- Role(s) involved: e.g., system_update, tpm
- Playbook/task snippet: minimal reproducer (YAML)
- Inventory snippet: host/group vars relevant to the issue

Reproduction Steps
1. …
2. …

Expected Result
<what you expected>

Actual Result
<what happened>

Outputs
- `--check --diff` output (relevant excerpt)
- `-vvv` logs (relevant excerpt)
```

### Security Reporting Template

If you suspect a security issue:

- Do not include sensitive material or secrets. Provide only minimal details
  necessary to identify the issue.
- Prefer GitHub’s private vulnerability reporting (“Report a vulnerability”) if
  enabled for the repository. If not available, open an issue with the title
  prefix `[SECURITY]` and provide the following template:

```
Title: [SECURITY] <concise summary>

Impact
- Briefly describe potential impact (e.g., credential exposure, privilege escalation)

Affects
- Role(s) and versions affected
- Platforms affected (e.g., RHEL/Alma/Rocky 9.x)

Minimal Reproducer
- Steps required to demonstrate the issue (omit sensitive data)

Mitigations/Workarounds
- Any known mitigations or configuration flags that reduce exposure
```

## Contributing

- PRs and issues are welcome. Follow Conventional Commits in subject lines.
- Lint locally with `ansible-lint` and `yamllint`.
- Test with `ansible-playbook --check --diff` where possible. Avoid committing
  secrets.

## License

- MIT License. See `LICENSE`.

## Release Notes

- See `CHANGELOG.md` for user‑visible changes and breaking updates.

## Links

- Source: <https://github.com/i-cant-computer/vanilla-rhel-deploy>
- Issues: <https://github.com/i-cant-computer/vanilla-rhel-deploy/issues>
