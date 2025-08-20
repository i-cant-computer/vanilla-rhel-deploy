# Role: i_cant_computer.vanilla_rhel_deploy.automate_system_updates

Installs and configures `dnf-automatic` and enables a nightly update timer.

Variables

- `automate_system_updates_schedule` (string, optional): systemd `OnCalendar`
  expression for when the timer runs. Default: `"*-*-* 01:00:00"` (daily at
  01:00 local time).
- `automate_system_updates_randomize_delay` (string, optional): systemd
  `RandomizedDelaySec` value to jitter start time. Default: `"10m"`.

Example

```yaml
- hosts: servers
  roles:
    - role: i_cant_computer.vanilla_rhel_deploy.automate_system_updates
      vars:
        # Run every day at 03:15 with up to 20 minutes jitter
        automate_system_updates_schedule: "*-*-* 03:15:00"
        automate_system_updates_randomize_delay: "20m"
```

Dependencies

- None.
