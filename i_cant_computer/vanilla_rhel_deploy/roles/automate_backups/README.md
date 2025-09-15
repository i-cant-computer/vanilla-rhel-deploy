# Role: i_cant_computer.vanilla_rhel_deploy.automate_backups

Configures a backup agent for Podman containers, sets up a Borg repository
backup, and wires Microsoft 365 email notifications for success/failure via
systemd units and timer.

Variables

- `automate_backups_mailer_version` (string, optional): Git ref (branch, tag, or
  commit) for `m365-mailer`. Default: `"main"`.
- `automate_backups_agent_version` (string, optional): Git ref (branch, tag, or
  commit) for `backup-agent`. Default: `"main"`.
- `automate_backups_schedule` (string, optional): systemd `OnCalendar`
  expression for when the timer runs. Default: `"*-*-* 02:00:00"` (daily at
  02:00 local time).
- `podman_user` (string, required): Username that owns/runs the Podman
  containers.
- `export_path` (string, required): Destination directory where volume exports
  are written (e.g., `/srv/exports`).
- `backup_path` (string, required): Base path under which the Borg repository is
  created/used. The repository path is `{{ backup_path }}/borg/repository`.
- `borg_password` (string, required): Borg repository passphrase. Store in an
  Ansible vault.
- `mailer_client_id` (string, required): Azure AD application (client) ID for
  Microsoft 365 mailer.
- `mailer_tenant_id` (string, required): Azure AD tenant ID.
- `mailer_client_secret` (string, required): Client secret for the Azure AD app.
  Store in an Ansible vault.
- `mailer_from` (string, required): From address for notification emails.
- `mailer_to` (string, required): Recipient address for notification emails.

Notes

- The role places config under `/root/backup-agent/config.yaml` and
  `/root/m365-mailer/config.yaml`.
- The systemd timer `backup-agent.timer` runs daily at 02:00 local time. Modify
  the unit after deployment if a different schedule is desired.
- The bundled `backup_config.j2` template includes example `export_volumes` and
  `export_containers` for common services. Adjust to match your environment
  (fork/override the template as needed).
- A minimal SELinux policy module is compiled and installed to permit journal
  access used by the mailer units.

Example

```yaml
- hosts: servers
  become: true
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.automate_backups
      vars:
        podman_user: podman
        export_path: /srv/exports
        backup_path: /srv/backup
        borg_password: "{{ vault_borg_password }}" # vaulted

        # Microsoft 365 mailer (vault secrets recommended)
        mailer_client_id: "{{ vault_mailer_client_id }}"
        mailer_tenant_id: "{{ vault_mailer_tenant_id }}"
        mailer_client_secret: "{{ vault_mailer_client_secret }}"
        mailer_from: backups@example.com
        mailer_to: ops@example.com

        # Pin specific versions if desired
        automate_backups_mailer_version: v1.2.3
        automate_backups_agent_version: v0.4.0
```

Dependencies

- None in Ansible terms; however, the following must be available on targets:
  - `git`, SELinux tooling (`selinux-policy-devel`, `policycoreutils`), and
    `systemd`.
  - `uv` to run the Python mailer/agent (`uv run ...`).
  - `borg` for repository initialization and backups.
  - Podman environment with the containers and named volumes you intend to
    export.
