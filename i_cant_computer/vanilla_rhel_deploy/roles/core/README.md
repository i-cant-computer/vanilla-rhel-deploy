# Role: i_cant_computer.vanilla_rhel_deploy.core

Installs core packages, hardens SSH, and manages base accounts.

Variables

- `ansible_pubkey` (string, required): Expected content of
  `/home/ansible/.ssh/authorized_keys`.

Example

```yaml
ansible_pubkey: "ssh-ed25519 AAAA... ansible@controller"
```

Dependencies

- None.
