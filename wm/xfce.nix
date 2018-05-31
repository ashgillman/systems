{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;

  addyDclxviXfwm4ThemeCollections = stdenv.mkDerivation rec {
    name = "addy-dclxvi-xfwm4-theme-collections";
    version = "2018.03.20";

    src = pkgs.fetchFromGitHub {
      owner = "addy-dclxvi";
      repo = "xfwm4-theme-collections";
      rev = "1a68dd9";  # March 2018
      sha256 = "1dqm980h6mjlqbinbjnmap8kpv8cmz7z53ksf31g950j45h2m2vl";
    };

    installPhase = ''
      mkdir -p $out/share/themes/
      find . -type d -exec cp -va {} $out/share/themes/ \;
    '';

    meta = {
      description = "Xfwm/Xfce Theme Collections";
      homepage = https://github.com/addy-dclxvi/xfwm4-theme-collections;
      license = stdenv.lib.licenses.gpl3;
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.maintainers.ashgillman ];
    };
  };

  addyDclxviGtkThemeCollections = stdenv.mkDerivation rec {
    name = "addy-dclxvi-xfwm4-theme-collections";
    version = "2018.04.07";

    src = pkgs.fetchFromGitHub {
      owner = "addy-dclxvi";
      repo = "gtk-theme-collections";
      rev = "bc069e0";  # April 2018
      sha256 = "0i6alnix50kn53gfdb81jj7s160xl8smn3v6x4a94lnzxnf3mr5h";
    };

    installPhase = ''
      mkdir -p $out/share/themes/
      find . -type d -exec cp -va {} $out/share/themes/ \;
    '';

    meta = {
      description = "GTK compation theme collection";
      homepage = https://github.com/addy-dclxvi/xfwm4-theme-collections;
      license = stdenv.lib.licenses.gpl3;
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.maintainers.ashgillman ];
    };
  };

in {
  services.xserver.desktopManager = {
    default = "xfce";
    xfce.enable = true;
  };

  environment.systemPackages = with pkgs; [
    addyDclxviXfwm4ThemeCollections
    addyDclxviGtkThemeCollections
    arc-theme
    arc-icon-theme
    numix-icon-theme
    numix-icon-theme-square
    numix-icon-theme-circle
  ];

  networking.networkmanager.enable = true;
}
