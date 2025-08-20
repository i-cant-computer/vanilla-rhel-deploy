# Role: i_cant_computer.vanilla_rhel_deploy.podman

Installs Podman and prepares a rootless service account for containers.

Variables

- `podman_user` (string, required): Username for the rootless container account.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.podman
      vars:
        podman_user: podman
```

Dependencies

- None.
