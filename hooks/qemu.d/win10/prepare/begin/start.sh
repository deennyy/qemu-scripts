#!/bin/bash
# Helpful to read output when debugging
set -x

ivpn disconnect
killall kwin_x11

# Load the config file with our environmental variables
source "/etc/libvirt/hooks/kvm.conf"

# Stop your display manager. If you're on kde it'll be sddm.service. Gnome users should use 'killall gdm-x-session' instead
systemctl stop sddm.service

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon1/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
echo 0 > /sys/class/vtconsole/vtcon0/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a race condition by waiting a couple of seconds. This can be calibrated to be shorter or longer if required for your system
sleep 1

# Unload all Nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r drm

# Unbind the GPU from display driver
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
