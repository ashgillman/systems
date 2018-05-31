{ config, pkgs, ... }:

let
  stdenv = pkgs.stdenv;

  refreshmon = pkgs.writeShellScriptBin "refreshmon" ''
    script=$HOME/.screenlayout/$(xrandr | grep ' connected' | wc -l).sh
    [[ -x $script ]] && $script || ${pkgs.arandr}
  '';

  nerdfont_inconsolata = stdenv.mkDerivation rec {
    name = "nerdfont-inconsolata";

    src = pkgs.fetchurl {
      url = https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/Inconsolata.zip;
      sha256 = "0d0hkc3sp7rn4d6hx7l5r7fqk4g35yg4pn4wsz1ppn86glgs3psy";
    };

    unpackCmd = ''
      ${pkgs.unzip}/bin/unzip $curSrc -d fonts
    '';
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp * $out/share/fonts/opentype
    '';
  };

  nerdfont_dejavu = stdenv.mkDerivation rec {
    name = "nerdfont-dejavu";

    src = pkgs.fetchurl {
      url = https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/DejaVuSansMono.zip;
      sha256 = "0qzpawa6hihh6s56wmpsnq55rxphmcrb7z7xk4cd7j3bqhp1dydv";
    };

    unpackCmd = ''
      ${pkgs.unzip}/bin/unzip $curSrc -d fonts
    '';
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp * $out/share/fonts/opentype
    '';
  };

  python = pkgs.python36.withPackages (pypkgs: [ pypkgs.psutil ]);


in {
  services.xserver.displayManager.sessionCommands = ''
    # menu bar
    mkdir -p $HOME/.local/var/log
    echo BAR=${pkgs.dzen2}/bin/dzen2 BSPC=${pkgs.bspwm}/bin/bspc \
      ${python}/bin/python3 ${./bspwm/update_bar} \
      > $HOME/.local/var/log/menubar.log 2>&1 &
    BAR=${pkgs.dzen2}/bin/dzen2 BSPC=${pkgs.bspwm}/bin/bspc \
      ${python}/bin/python3 ${./bspwm/update_bar} \
      > $HOME/.local/var/log/menubar.log 2>&1 &
  '';

  environment.systemPackages = with pkgs; [
    refreshmon
      arandr   # xrandr tool
      xorg.xrandr   # monitor util
    dzen2      # bar
    xdo        # bar tools
    dmenu      # TODO: rofi
    alsaUtils  # for amixer for sound info
  ];

  fonts.fonts = [ nerdfont_dejavu nerdfont_inconsolata pkgs.font-awesome-ttf ];
}
