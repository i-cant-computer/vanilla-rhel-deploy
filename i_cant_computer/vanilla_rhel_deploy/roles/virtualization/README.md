# Role: i_cant_computer.vanilla_rhel_deploy.virtualization

Installs virtualization packages and configures the HashiCorp repository. Add
system users to the `libvirt` group using the `system-users` role to permit
interaction with virtualization services.

Variables

- None

Example

```yaml
- hosts: servers
  roles:
    - i_cant_computer.vanilla_rhel_deploy.virtualization
```

Dependencies

- None.
