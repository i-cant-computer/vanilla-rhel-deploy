# Role: i_cant_computer.vanilla_rhel_deploy.auto_mount

Configures automatic mounting of a secondary LUKS-backed filesystem.

Variables

- `luks_uuid` (string): UUID of the LUKS volume to mount. Default
  `{{ backup_luks_uuid }}`.
- `luks_slot` (int|string): Recovery key slot to use. Default
  `{{ backup_luks_recovery_key_slot }}`.
- `mount_point` (string): Target mount point. Default
  `{{ backup_mount_point }}`.
- `filesystem` (string): Filesystem type (e.g., `xfs`, `ext4`). Default `xfs`.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.auto_mount
      vars:
        backup_luks_uuid: "bbbbbbbb-cccc-dddd-eeee-ffffffffffff"
        backup_luks_recovery_key_slot: 1
        backup_mount_point: /mnt/backups
        filesystem: xfs
```

Dependencies

- None.
