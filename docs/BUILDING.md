# Building smg4OS

This guide covers building smg4OS from source.

## Prerequisites

### System Requirements
- Linux host system (Ubuntu 20.04+ recommended)
- 4GB+ RAM
- 20GB+ free disk space
- POSIX-compliant shell

### Required Tools

```bash
sudo apt-get install build-essential \
    git curl wget \
    bc bison flex \
    gcc g++ make \
    grub-pc-bin grub-efi-amd64-bin \
    xorriso mtools dosfstools \
    libncurses-dev libelf-dev libssl-dev
```

## Build Steps

### 1. Prepare Build Environment

```bash
cd /workspaces/smg4OS
mkdir -p build
export SMG4OS_BUILD_ROOT=$(pwd)/build
```

### 2. Download Source Components

The build script will handle downloading:
- Linux kernel sources
- GNU userspace tools
- System utilities

```bash
./scripts/fetch-sources.sh
```

### 3. Configure Kernel

```bash
./scripts/configure-kernel.sh
```

This creates a `.config` file with smg4OS defaults optimized for:
- Performance
- Compatibility
- Minimal bloat

### 4. Build Core System

```bash
./scripts/build.sh
```

This builds:
- Linux kernel
- Essential utilities
- System libraries
- Bootloader

### 5. Create ISO Image

```bash
./scripts/create-iso.sh
```

Creates a bootable ISO at `iso/smg4OS-latest.iso`

## Complete Build

Run all steps:

```bash
./scripts/build-all.sh
```

## Building with Custom Options

### Custom Kernel Configuration

Edit before building:
```bash
vim config/kernel.config
./scripts/build.sh
```

### Minimal Build (No Desktop)

```bash
SMG4OS_MINIMAL=1 ./scripts/build.sh
```

### Development Build (With Debug Symbols)

```bash
SMG4OS_DEBUG=1 ./scripts/build.sh
```

## Troubleshooting

### Out of Disk Space
Clean previous builds:
```bash
./scripts/clean.sh
```

### Build Fails
Check the build log:
```bash
cat build/build.log
```

### Permission Errors
Some build steps need sudo:
```bash
sudo ./scripts/build.sh
```

## Output

After successful build:
- ISO: `iso/smg4OS-latest.iso`
- Kernel: `build/vmlinuz`
- Rootfs: `build/rootfs.tar.gz`

## Testing the ISO

### Virtual Machine (QEMU)

```bash
qemu-system-x86_64 \
    -cdrom iso/smg4OS-latest.iso \
    -m 2G \
    -smp 2 \
    -enable-kvm
```

### USB Flash Drive

```bash
sudo dd if=iso/smg4OS-latest.iso of=/dev/sdX bs=4M
sync
```

Replace `/dev/sdX` with your USB device (be careful!).

## Advanced Options

See [DEVELOPMENT.md](DEVELOPMENT.md) for advanced customization and development workflows.
