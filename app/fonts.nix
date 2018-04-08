{ stdenv, pkgs }:

{
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
}
