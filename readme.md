# Installation
Follow standard installation instructions until modifying `configuration.nix`.

```sh
# GParted
# EFI boot - 512MB, Fat32, tick 'boot'
# Root nixos - rest, ext4
nix-env -iA nixos.git
cd /mnt/etc/nixos/
git clone https://github.com/ashgillman/systems.git
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
nix-channel --update nixos-hardware
nixos-install
reboot
# Log in as root
passwd gil  # new password
# Log in as gil
# Instructions for dotfiles
```

