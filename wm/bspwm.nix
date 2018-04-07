{ config, pkgs, ... }:

let
  stdenv = pkgs.stdenv;

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


  psutil5 = pkgs.python36Packages.psutil.overrideDerivation (oldAttrs: rec {
    name = "psutil-${version}";
    version = "5.1.3";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/psutil/${name}.tar.gz";
      sha256 = "0aqg2893irpn5zmy7c0p0qizgf51shidhfyb8fhv0ll1vj5xb6wm";
    };
  });

  python = pkgs.python36.withPackages (pypkgs: [ psutil5 ]);

in {
  services.xserver = {
    desktopManager.default = "none";
    windowManager.bspwm = {
      enable = true;
    };
    displayManager.sessionCommands = ''
      # menu bar
      echo BAR=${pkgs.dzen2}/bin/dzen2 BSPC=${pkgs.bspwm}/bin/bspc \
        ${python}/bin/python3 $HOME/dotfiles/dzen/bin/update_bar \
        > $HOME/.menubar.log 2>&1 &
      BAR=${pkgs.dzen2}/bin/dzen2 BSPC=${pkgs.bspwm}/bin/bspc \
        ${python}/bin/python3 $HOME/dotfiles/dzen/bin/update_bar \
        >> $HOME/.menubar.log 2>&1 &
    '';
  };

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd

    dzen2 # bar
    xdo   # bar tools
    dmenu # TODO: rofi
  ];

  fonts.fonts = [ nerdfont_dejavu nerdfont_inconsolata pkgs.font-awesome-ttf ];
}
