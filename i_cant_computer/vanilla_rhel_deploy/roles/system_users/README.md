# Role: i_cant_computer.vanilla_rhel_deploy.system_users

Creates or updates system users, manages group membership (including `libvirt`),
and configures SSH keys.

Variables

- `system_users` (list[dict], required): List of admin/user specs to
  create/update.
  - `user` (string, required): Username to manage.
  - `hash` (string, required): Password hash (use `!` to disable password
    login).
  - `groups` (string|list, optional): Group(s) to add the user to (e.g.,
    `wheel`, `libvirt`).
  - `pubkey` (string, required): SSH public key content for `authorized_keys`.

Example

```yaml
system_users:
  - user: alice
    hash: "!"
    groups: [wheel, libvirt]
    pubkey: "ssh-ed25519 AAAA... alice@host"
  - user: bob
    hash: "!"
    groups: "libvirt"
    pubkey: "ssh-ed25519 AAAA... bob@host"
```

Dependencies

- None.
