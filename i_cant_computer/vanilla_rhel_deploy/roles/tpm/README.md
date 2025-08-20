# Role: i_cant_computer.vanilla_rhel_deploy.tpm

Configures TPM-backed unlocking of a LUKS volume using clevis.

Variables

- `luks_uuid` (string): UUID of the target LUKS volume. Default
  `{{ primary_luks_uuid }}`.
- `luks_passphrase` (string): Passphrase for the target volume. Default
  `{{ primary_luks_passphrase }}`.
- `luks_slot` (int|string): Slot to bind clevis to. Default
  `{{ primary_luks_tpm_slot }}`.
- `luks_path` (string): Device path, built from UUID. Default
  `/dev/disk/by-uuid/{{ luks_uuid }}`.
- `clevis_tpm_config.hash` (string): TPM hash algorithm. Default `sha256`.
- `clevis_tpm_config.key` (string): TPM key type. Default `rsa`.
- `clevis_tpm_config.pcr_bank` (string): PCR bank. Default `sha256`.
- `clevis_tpm_config.pcr_ids` (string): PCRs to bind. Default `"1,7"`.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.tpm
      vars:
        primary_luks_uuid: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
        primary_luks_passphrase: "{{ vault_primary_luks_passphrase }}"
        primary_luks_tpm_slot: 2
```

Dependencies

- None.
