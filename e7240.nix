{ pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/15-9550>
    ./common.nix
    # ./wm/bspwm.nix
    ./wm/xfce.nix
  ];

  networking = {
    hostName = "luigi";
  };

  swapDevices = [ { device = "/var/swapfile"; } ];

  hardware.pulseaudio.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = false;
}
