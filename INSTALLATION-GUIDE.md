# smg4OS Installation Guide

## Prerequisites

### Host System Requirements
- Linux operating system (Ubuntu 20.04+ recommended)
- 4GB RAM minimum (8GB+ recommended for faster builds)
- 20GB free disk space
- Internet connection for downloading dependencies

### Required Packages

```bash
sudo apt update
sudo apt install -y \
    build-essential \
    git curl wget \
    bc bison flex \
    gcc g++ make \
    grub-pc-bin grub-efi-amd64-bin \
    xorriso mtools dosfstools \
    libncurses-dev libelf-dev libssl-dev
```

Optional (for testing):
```bash
sudo apt install qemu-system qemu-utils
```

## Step-by-Step Installation

### 1. Clone the Repository

```bash
git clone https://github.com/vasilijevasavasilije000-cell/smg4OS.git
cd smg4OS
```

### 2. Setup Development Environment

```bash
./scripts/setup-dev.sh
```

This will:
- Make build scripts executable
- Display quick start information
- Verify you're in the right directory

### 3. Build smg4OS

#### Complete Build (Recommended)
```bash
./scripts/build-all.sh
```

This will:
1. Compile the Linux kernel
2. Build system utilities
3. Create root filesystem
4. Generate ISO image

**Expected time:** 30-60 minutes (varies by hardware)

#### Partial Build Options

```bash
# Build only core system (without ISO)
./scripts/build.sh

# Create ISO from existing build
./scripts/create-iso.sh

# Clean all artifacts
./scripts/clean.sh
```

### 4. Verify Build

```bash
# Check build artifacts
ls -lh iso/
ls -lh build/

# Expected output includes:
# - iso/smg4OS-latest.iso (bootable image)
# - build/build.log (build log)
```

## Testing the ISO

### Virtual Machine (QEMU)

```bash
# Install QEMU if needed
sudo apt install qemu-system-x86_64

# Boot ISO in QEMU
qemu-system-x86_64 \
    -cdrom iso/smg4OS-latest.iso \
    -m 2G \
    -smp 2 \
    -enable-kvm \
    -net user \
    -net nic,model=virtio
```

### USB Flash Drive

#### Preparation
```bash
# List block devices
lsblk

# Note the device name (e.g., /dev/sdb for USB)
```

#### Writing Image
```bash
# IMPORTANT: Replace /dev/sdX with YOUR USB device
# WARNING: This will erase all data on the device!

# Unmount if mounted
sudo umount /dev/sdX* 2>/dev/null || true

# Write ISO
sudo dd if=iso/smg4OS-latest.iso of=/dev/sdX bs=4M status=progress
sync

# Eject safely
sudo eject /dev/sdX
```

#### Booting from USB
1. Insert USB into target computer
2. Power on and enter boot menu (typically F12, F2, or ESC)
3. Select USB drive
4. Boot into smg4OS

## Customization Before Building

### Edit Package List
```bash
# Core packages
vim packages/base.list

# Desktop packages
vim packages/desktop.list

# Gaming packages
vim packages/gaming.list
```

### Customize Kernel
```bash
# Edit kernel configuration
vim config/kernel.config

# Interactive configuration (requires make, gcc)
cd src/kernel
make menuconfig
```

### Configure Bootloader
```bash
# GRUB settings
vim config/grub.cfg

# Boot parameters, timeout, theme
```

### Adjust System Settings
```bash
# Hostname
vim config/hostname

# Filesystem layout
vim config/fstab
```

Then rebuild with:
```bash
./scripts/build-all.sh
```

## Building on Different Systems

### Ubuntu/Debian
```bash
# Install dependencies
sudo apt update
sudo apt install build-essential linux-headers-generic ...

# Build
./scripts/build-all.sh
```

### Fedora/RHEL
```bash
# Install dependencies
sudo dnf groupinstall "Development Tools"
sudo dnf install kernel-devel ...

# Build
./scripts/build-all.sh
```

### Alpine Linux
```bash
# Install dependencies
apk add build-base linux-headers git curl wget ...

# Build
./scripts/build-all.sh
```

## Troubleshooting

### Build Fails with "Command not found"

Install missing dependencies:
```bash
sudo apt install build-essential gcc g++ make
```

### Out of Disk Space

Clean previous builds:
```bash
./scripts/clean.sh
df -h  # Check available space
```

Need at least 20GB free.

### Kernel Build Errors

Check build log:
```bash
tail -50 build/build.log
```

Common solutions:
1. Ensure gcc and make are installed
2. Check kernel.config syntax
3. Try updating build tools: `sudo apt upgrade`

### Permission Denied on Scripts

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### ISO Won't Boot

1. Verify ISO integrity:
   ```bash
   ls -lh iso/smg4OS-latest.iso
   ```

2. Check boot mode (BIOS vs UEFI)

3. Try different boot method

### QEMU Issues

Ensure KVM is available:
```bash
# Check KVM support
grep -c "vmx\|svm" /proc/cpuinfo
# Non-zero means KVM available

# If KVM not available, remove -enable-kvm flag
qemu-system-x86_64 -cdrom iso/smg4OS-latest.iso -m 2G
```

## Post-Build Steps

### Verify ISO Content
```bash
# Mount ISO to check contents
mkdir /tmp/iso_mount
sudo mount -o loop iso/smg4OS-latest.iso /tmp/iso_mount
ls -lh /tmp/iso_mount/
sudo umount /tmp/iso_mount
```

### Create Backup
```bash
# Backup ISO
cp iso/smg4OS-latest.iso ~/smg4OS-backup-$(date +%Y%m%d).iso

# Backup configuration
tar czf smg4OS-config-backup.tar.gz config/ packages/
```

### Share with Others
```bash
# Create compressed ISO
xz -9 iso/smg4OS-latest.iso

# Or use gzip
gzip iso/smg4OS-latest.iso
```

## Next Steps

1. **Read the documentation:**
   - [QUICKSTART.md](QUICKSTART.md) - Quick start guide
   - [docs/BUILDING.md](docs/BUILDING.md) - Detailed build guide
   - [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) - Development guide

2. **Customize the system:**
   - [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)

3. **Contribute:**
   - [CONTRIBUTING.md](CONTRIBUTING.md)

4. **Get help:**
   - [docs/FAQ.md](docs/FAQ.md)

## Support

- Check [docs/FAQ.md](docs/FAQ.md) for common issues
- Search existing issues on GitHub
- Open a new issue with detailed information
- Join community discussions

---

**Happy building! 🚀**

*Made with ❤️ and powered by memes.*
