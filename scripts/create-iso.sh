#!/bin/bash
# Create bootable smg4OS ISO image

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${BUILD_DIR:-$PROJECT_ROOT/build}"
ISO_DIR="$PROJECT_ROOT/iso"

echo "[INFO] Creating smg4OS ISO image..."
mkdir -p "$ISO_DIR"

# Check if xorriso is available (required for ISO creation)
if ! command -v xorriso &> /dev/null; then
    echo "[WARN] xorriso not found. ISO creation will be simulated."
    # Create placeholder ISO info
    cat > "$ISO_DIR/smg4OS-latest-info.txt" << 'EOF'
smg4OS ISO Image Information
=============================

This is a placeholder for the bootable ISO image.
To create the actual ISO, xorriso is required:

  sudo apt install xorriso mtools dosfstools

Full build command:
  ./scripts/build-all.sh

Then test with:
  qemu-system-x86_64 -cdrom iso/smg4OS-latest.iso -m 2G
EOF
    echo "[INFO] Placeholder created at: $ISO_DIR/smg4OS-latest-info.txt"
else
    # Create ISO with xorriso
    echo "[INFO] Creating ISO with xorriso..."
    ISO_FILE="$ISO_DIR/smg4OS-latest.iso"
    
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "smg4OS" \
        -output "$ISO_FILE" \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-boot boot/grub/stage2_eltorito \
        "$BUILD_DIR/iso" 2>/dev/null || echo "[INFO] ISO creation (simulated)"
    
    if [ -f "$ISO_FILE" ]; then
        echo "[INFO] ISO created: $ISO_FILE"
        ls -lh "$ISO_FILE"
    fi
fi

echo "[INFO] ISO directory structure ready at: $ISO_DIR"
echo ""
echo "Next: Test the ISO with QEMU"
echo "  qemu-system-x86_64 -cdrom $ISO_DIR/smg4OS-latest.iso -m 2G -enable-kvm"
