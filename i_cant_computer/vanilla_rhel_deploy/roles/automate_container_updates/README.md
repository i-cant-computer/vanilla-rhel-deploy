# Role: i_cant_computer.vanilla_rhel_deploy.automate_container_updates

Configures user-level overrides and enables the Podman auto-update timer.

Variables

- `automate_container_updates_podman_user` (string, optional): Username that
  owns containers and runs the user systemd. Default: `podman`.
- `automate_container_updates_schedule` (string, optional): systemd `OnCalendar`
  expression for when the timer runs. Default: `"*-*-* 01:30:00"` (daily at
  01:30 local time).
- `automate_container_updates_randomize_delay` (string, optional): systemd
  `RandomizedDelaySec` value to jitter start time. Default: `"10m"`.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.automate_container_updates
      vars:
        automate_container_updates_podman_user: podman
        # Run every day at 03:00 with up to 20 minutes jitter
        automate_container_updates_schedule: "*-*-* 03:00:00"
        automate_container_updates_randomize_delay: "20m"
```

Dependencies

- None.
