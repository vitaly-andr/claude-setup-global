---
name: proxmox
description: Proxmox VE 9 virtual machine, container, storage, and cluster management. Use when working with qm, pct, pvesm, vzdump, or Proxmox-specific tasks.
---

# Proxmox VE 9 Management

## VM Management (qm)

### Listing and Info
```bash
# List all VMs
qm list

# Show VM configuration
qm config <vmid>

# Show VM status
qm status <vmid>
```

### VM Lifecycle
```bash
# Create VM
qm create <vmid> --name <name> --memory <MB> --cores <num> --sockets <num>

# Start VM
qm start <vmid>

# Shutdown VM gracefully
qm shutdown <vmid>

# Reboot VM
qm reboot <vmid>

# Stop VM forcefully
qm stop <vmid>

# Destroy VM and all volumes
qm destroy <vmid>
```

### VM Operations
```bash
# Clone VM
qm clone <vmid> <newid> --name <new-name>

# Migrate VM to another node
qm migrate <vmid> <target-node>

# Create snapshot
qm snapshot <vmid> <snapshot-name>

# Rollback to snapshot
qm rollback <vmid> <snapshot-name>

# Delete snapshot
qm delsnapshot <vmid> <snapshot-name>

# Resize disk
qm resize <vmid> <disk> <size>
```

## Container Management (pct)

### Listing and Info
```bash
# List all containers
pct list

# Show container configuration
pct config <vmid>

# Show container status
pct status <vmid>
```

### Container Lifecycle
```bash
# Create container from template
pct create <vmid> <ostemplate> --hostname <name> --memory <MB> --cores <num> --rootfs <storage>:<size>

# Start container
pct start <vmid>

# Shutdown container gracefully
pct shutdown <vmid>

# Stop container forcefully
pct stop <vmid>

# Destroy container
pct destroy <vmid>
```

### Container Operations
```bash
# Enter container console
pct enter <vmid>

# Execute command in container
pct exec <vmid> -- <command>

# Clone container
pct clone <vmid> <newid> --hostname <new-name>

# Migrate container to another node
pct migrate <vmid> <target-node>

# Create snapshot
pct snapshot <vmid> <snapshot-name>

# Rollback to snapshot
pct rollback <vmid> <snapshot-name>

# Resize container disk
pct resize <vmid> <disk> <size>
```

## Storage Management (pvesm)

### List and Info
```bash
# List all storages
pvesm status

# List content of storage
pvesm list <storage>

# Show storage details
pvesm status --storage <storage>
```

### Storage Operations
```bash
# Add directory storage
pvesm add dir <storage-id> --path <path>

# Add NFS storage
pvesm add nfs <storage-id> --path <path> --server <server> --export <export>

# Add LVM storage
pvesm add lvm <storage-id> --vgname <vg-name>

# Modify storage settings
pvesm set <storage-id> --shared 1

# Remove storage (config only, no data deleted)
pvesm remove <storage-id>

# Allocate volume
pvesm alloc <storage-id> <vmid> <filename> <size>

# Free volume
pvesm free <volume-id>
```

## Backup and Restore (vzdump)

### Backup Operations
```bash
# Backup VM/Container
vzdump <vmid> --storage <storage> --mode snapshot

# Backup multiple VMs
vzdump <vmid1> <vmid2> --storage <storage>

# Backup all VMs
vzdump --all --storage <storage>

# Backup with compression
vzdump <vmid> --storage <storage> --compress gzip

# Backup with notification
vzdump <vmid> --storage <storage> --mailto <email>

# Stop VM during backup
vzdump <vmid> --storage <storage> --mode stop
```

### Restore Operations
```bash
# Restore VM from backup
qmrestore <backup-file> <vmid>

# Restore container from backup
pct restore <vmid> <backup-file>

# Restore to different storage
qmrestore <backup-file> <vmid> --storage <storage>
```

## Cluster Management (pvecm)

### Cluster Status
```bash
# Show cluster status
pvecm status

# List cluster nodes
pvecm nodes

# Show expected votes
pvecm expected 1
```

### Cluster Operations
```bash
# Create new cluster
pvecm create <cluster-name>

# Add node to cluster
pvecm add <master-ip>

# Remove node from cluster (run on master)
pvecm delnode <nodename>
```

## Node Management

### System Info
```bash
# Show node status
pveversion

# Show running services
systemctl status pve*

# Check cluster quorum
pvecm status

# Show node resources
pvesh get /nodes/<node>/status
```

### Service Management
```bash
# Restart Proxmox web interface
systemctl restart pveproxy

# Restart Proxmox daemon
systemctl restart pvedaemon

# Restart Proxmox firewall
systemctl restart pve-firewall
```

## API Access (pvesh)

### Basic API Commands
```bash
# Get node status
pvesh get /nodes/<node>/status

# List VMs via API
pvesh get /cluster/resources --type vm

# Get VM config via API
pvesh get /nodes/<node>/qemu/<vmid>/config

# Create VM via API
pvesh create /nodes/<node>/qemu --vmid <vmid> --name <name>
```

## Networking

### Network Configuration
```bash
# Edit network configuration
nano /etc/network/interfaces

# Apply network changes
ifreload -a

# Show bridge status
brctl show

# Add network interface to VM
qm set <vmid> --net0 virtio,bridge=vmbr0
```

## Common Tasks

### Templates
```bash
# Convert VM to template
qm template <vmid>

# Clone from template
qm clone <template-vmid> <new-vmid> --name <name> --full
```

### Disk Operations
```bash
# Import disk to VM
qm importdisk <vmid> <disk-image> <storage>

# Attach unused disk
qm set <vmid> --scsi0 <storage>:vm-<vmid>-disk-0

# Detach disk
qm unlink <vmid> --idlist <disk-id>
```

## Best Practices

1. **Always use snapshots before major changes**: `qm snapshot <vmid> before-update`
2. **Regular backups**: Set up automated backup jobs in Datacenter → Backup
3. **Monitor storage**: Check `pvesm status` regularly to avoid full disks
4. **Keep system updated**: `apt update && apt dist-upgrade` (after reading release notes)
5. **Use descriptive names**: Name VMs/CTs clearly for easy identification
6. **Document network layout**: Keep track of bridges, VLANs, and IP assignments

## Troubleshooting

### VM Won't Start
```bash
# Check VM logs
tail -f /var/log/pve/qemu-server/<vmid>.log

# Verify disk exists
ls -lah /dev/pve/vm-<vmid>-disk-*

# Check lock status
qm unlock <vmid>
```

### Storage Issues
```bash
# Verify storage is online
pvesm status

# Check disk space
df -h

# Scan storage for orphaned disks
pvesm list <storage>
```

### Cluster Problems
```bash
# Check quorum
pvecm status

# Reset cluster if quorum lost (single node)
pvecm expected 1

# Check corosync status
systemctl status corosync
```

## References

- Official Documentation: https://pve.proxmox.com/pve-docs/
- Admin Guide (9.x): https://www.proxmox.com/en/downloads/proxmox-virtual-environment/documentation/proxmox-ve-admin-guide-for-9-x
- Proxmox Wiki: https://pve.proxmox.com/wiki/
- Proxmox Forum: https://forum.proxmox.com/
