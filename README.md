# Vanilla RHEL deploy

`vanilla-rhel-deploy` aims to simplify and automate the deployment of RHEL based
servers running virtual and containerized workloads in a home-lab environment.

It provides functionality for:

- ensuring encrypted system partitions are loaded at boot using a TPM
- auto-mounting secondary partitions post boot
- setting recovery keys if not found and verifying them
- installing base packages supporting containerized and virtual workloads
- configuring service accounts and enforcing basic system hardening

It has been tested on AlmaLinux.

## Synopsis

Configure disk encryption keys and auto-mounts:

```bash
ansible-playbook -i inventory/hosts.yml encryption.yml
```

Install core packages and perform configuration:

```bash
ansible-playbook -i inventory/hosts.yml main.yml
```

## Before you begin

### Install servers and create inventory

For each system:

1. Install Operating System using your preferred method.
2. Install `sshd` and ensure the service is running and enabled.
3. Gather the primary disk's LUKS passphrase and UUID:

   ```bash
   # passphrase is set during install
   blkid -t TYPE=crypto_LUKS | cut -d" " -f1,2
   ```

Create an inventory:

```yaml
# inventory/hosts.yml
servers:
  hosts:
    HOSTNAME:
      ansible_host: HOST_IP
```

And define group/host variables:

```yaml
# host_vars/host_name/main.yml
primary_luks_uuid: aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
primary_luks_passphrase: "{{vault_primary_luks_passphrase}}"
primary_luks_tpm_slot: 2
primary_luks_recovery_key_slot: 1
backup_luks_uuid: aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
backup_luks_passphrase: "{{vault_backup_luks_passphrase}}"
backup_luks_recovery_key_slot: 1
backup_mount_point: /mnt/backups
```

### Create the ansible user

If the OS image hasn't already; create the `ansible` user, generate an `ssh`
key-pair for the ansible user and copy the public key onto the server. Then run
the following commands as `root`:

```bash
cat <<EOF > /etc/ssh/sshd_config.d/99-ansible-publickey-only
# Restrict 'ansible' to public key authentication only
Match User ansible
    PasswordAuthentication no
    KeyboardInteractiveAuthentication no
    ChallengeResponseAuthentication no
    AuthenticationMethods publickey
EOF
systemctl reload sshd
export ANSIBLE_HOME=/home/ansible
useradd -r -m -G wheel -s /bin/bash -d $ANSIBLE_HOME ansible
mkdir $ANSIBLE_HOME/.ssh
cp YOUR_PUBLIC_KEY > $ANSIBLE_HOME/.ssh/authorized_keys
chmod 600 $ANSIBLE_HOME/.ssh/authorized_keys
chmod 700 $ANSIBLE_HOME/.ssh
chown -R ansible:ansible $ANSIBLE_HOME/.ssh
# Manage your private key carefully.
echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
```

## Playbook behavior

`encryption.yml` does a post-install configuration of disk encryption for the
server. It configures the system to boot using a TPM, and mounts a second
(external) volume for data or backups. Recovery keys are created for both
volumes, saved on the ansible controller and validated on every run.

`main.yml` installs Core packages to support virtual and containerized
workloads, enforces server configuration, and runs system updates.

### Summary of roles

The playbooks are designed to work with standard ansible inventories and
variables. Each role's `defaults/main.yml` define mandatory role variables along
with sensible defaults.

- **tpm**: configures a the server to use a tpm to decrypt LUKS volumes
  automatically on boot. It binds PCRS 1 and 7 by default.
- **luks**: configures recovery keys for LUKS volumes and takes backups of the
  volume's LUKS header. It verifies keys found in `./files` and fails if
  inconsistency is detected. Note that this role does not clear slots not used
  by this role, but may do so in the future.
- **auto_mount**: configure LUKS volumes to automatically mount on boot.
- **core**: install core packages, system service accounts, and perform system
  hardening.
- **update**: update all packages, rebooting if required.

### User accounts

The **core** role ensures the creation of the following accounts:

- **root**: the root account
- **ansible**: manages the server via `ansible`
- **podman**: a service account to run containerized workloads.

Passwords are disabled for both accounts and logins restricted through SSH.
