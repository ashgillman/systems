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

  services = {
    xserver.libinput.tapping = false;

    httpd = {
      enable = true;
      adminAddr = "gillmanash@gmail.com";
      documentRoot = "/home/gil/notebooks";
      extraConfig = ''
        # localhost/~gil
        # UserDir notebooks

        # Only localhost
        <Location "/">
        Order Deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
        </Location>
      '';
    };
  };

  # on current latest (4.17) have suspend issues
  # https://bugzilla.redhat.com/show_bug.cgi?id=1597481
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.loader.efi.canTouchEfiVariables = false;
}
