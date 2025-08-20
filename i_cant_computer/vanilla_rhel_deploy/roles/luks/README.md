# Role: i_cant_computer.vanilla_rhel_deploy.luks

Manages LUKS recovery key slots and validates configured keys.

Variables

- `luks_uuid` (string): UUID of the target LUKS volume. Default
  `{{ primary_luks_uuid }}`.
- `luks_passphrase` (string): Passphrase for the target volume. Default
  `{{ primary_luks_passphrase }}`.
- `luks_slot` (int|string): Recovery key slot to (re)configure. Default
  `{{ primary_luks_recovery_key_slot }}`.
- `luks_path` (string): Device path from UUID. Default
  `/dev/disk/by-uuid/{{ luks_uuid }}`.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.luks
      vars:
        primary_luks_uuid: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
        primary_luks_passphrase: "{{ vault_primary_luks_passphrase }}"
        primary_luks_recovery_key_slot: 1
```

Dependencies

- None.
