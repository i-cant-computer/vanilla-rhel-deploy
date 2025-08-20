## Examples

This folder contains a minimal, safe-to-try playbook that exercises a subset of the collection in check mode.

### Run locally (check + diff)

```bash
# From repo root
ansible-playbook -i examples/inventory/hosts.yml examples/update.yml --check --diff
```

- Edit `examples/inventory/hosts.yml` to target real hosts if desired.
- Remove `--check --diff` to apply changes for real.

### Notes
- The example uses roles that are low risk to preview: `system_update` and `automate_system_updates`.
- Platform: Enterprise Linux 9; ansible-core >= 2.16 per `meta/runtime.yml`.
