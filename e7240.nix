{ pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/15-9550>
    ./common.nix
    # ./wm/bspwm.nix
    ./wm/xfce.nix
  ];

  networking.hostName = "luigi";

  swapDevices = [
    { device = "/var/swapfile";
      size = 8192; # MiB
    }
  ];

  hardware.pulseaudio.enable = true;

  services.xserver.libinput.tapping = false;

  # on current latest (4.17) have suspend issues
  # https://bugzilla.redhat.com/show_bug.cgi?id=1597481
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.loader.efi.canTouchEfiVariables = false;
}
