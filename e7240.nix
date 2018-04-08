{ pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/15-9550>
    ./common.nix
  ];

  networking = {
    hostName = "luigi";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = false;
}
