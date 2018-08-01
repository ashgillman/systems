{ pkgs, lib, ... }:

let
  mypkgsDir = "/etc/nixpkgs";

  collections = import ./app/collections.nix {
    inherit pkgs;
    inherit (pkgs) stdenv;
  };

in {
  imports = [
    # ./dropbox.nix
    ./service/emacs.nix
  ];

  nix = {
    nixPath = [
      #"nixpkgs=${mypkgsDir}"
      # "mypkgs=${mypkgsDir}" # only now for compatability
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "nixos-hardware=https://github.com/NixOS/nixos-hardware/archive/master.tar.gz"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    gc.automatic = false;
    # trustedBinaryCaches = [
    #   daftpunk-rbh.sl.csiro.au:8090
    #   http://daftpunk-rbh.sl.csiro.au:8090
    # ];
    # binaryCachePublicKeys = [
    #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #   "daftpunk-rbh.sl.csiro.au-1:cBxs3D1hNbB0DOh/6KUkUVRGKXvUTKqR/E/QLbisWqo="
    # ];
    buildMachines = [
      { hostName = "temple-nixbuilder";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 2;
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment = {
    # systemPackages = common_config.systemPackages.paths;
    systemPackages = with collections;
      base ++ extras ++ nix ++ guis;

    variables = {
      EDITOR = "vim";
      BROWSER = "${pkgs.dillo}";
      ASPELL_CONF = "dict-dir /run/current-system/sw/lib/aspell/";
    };

    extraInit = ''
      # https://github.com/bennofs/etc-nixos/blob/master/conf/desktop.nix
      # QT: remove local user overrides (for determinism, causes hard to find bugs)
      rm -f ~/.config/Trolltech.conf
      # GTK3: remove local user overrides (for determinisim, causes hard to find bugs)
      rm -f ~/.config/gtk-3.0/settings.ini
      # GTK3: add breeze theme to search path for themes
      export XDG_DATA_DIRS="${pkgs.gnome-breeze}/share:$XDG_DATA_DIRS"
      # GTK3: add /etc/xdg/gtk-3.0 to search path for settings.ini
      # We use /etc/xdg/gtk-3.0/settings.ini to set the icon and theme name for GTK 3
      export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
      # GTK2 theme + icon theme
      export GTK2_RC_FILES=${pkgs.writeText "iconrc" ''gtk-icon-theme-name="breeze"''}:${pkgs.breeze-gtk}/share/themes/Breeze/gtk-2.0/gtkrc:$GTK2_RC_FILES
      # QT5: convince it to use our preferred style
      export QT_STYLE_OVERRIDE=breeze

      # these are the defaults, but some applications are buggy so we set them
      # here anyway
      export XDG_CONFIG_HOME=$HOME/.config
      export XDG_DATA_HOME=$HOME/.local/share
      export XDG_CACHE_HOME=$HOME/.cache
    '';

    etc = {
      "admin/optimize-nix" = {
        text =
        ''
          #!/run/current-system/sw/bin/bash
          set -eu

          # Delete generations older than a week
          nix-collect-garbage --delete-older-than 7d

          # Optimize
          nix-store --gc --print-dead
          nix-store --optimise
        '';
        mode = "0774";
      };
    };
  };

  system.stateVersion = lib.mkDefault "18.03";

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;

      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
        source $HOME/.zshrc
      '';

      promptInit = ""; # avoid a conflict with oh-my-zsh
    };
    ssh.startAgent = true;
  };

  services = {
    xserver = {
      enable = true;
      # autorun = false;

      layout = "us";
      xkbOptions = "caps:escape,ctrl:menu_rctrl";

      displayManager.lightdm.enable = true;

      displayManager.sessionCommands = pkgs.lib.mkBefore ''
        [ -f ~/.Xresources ] && xrdb ~/.Xresources

        urxvt & # In case of emergency, use shell

        #feh --bg-scale /home/gil/Downloads/bg.jpg
        [ -f /home/gil/Downloads/floppy.png ] \
          && feh --bg-scale /home/gil/Downloads/floppy.png
      '';

      libinput = {
        enable = true;
        accelSpeed = "1.0";
        naturalScrolling = true;
      };
    };

    locate.enable = true;

    openssh.enable = true;

    # mopidy = {
    #   enable = true;
    #   configuration = ''
    #     [mpd]
    #     hostname = ::

    #     [gmusic]
    #     ${builtins.readFile (./secrets/gmusic_secret)}
    #     radio_stations_as_playlists = true
    #     all_access = true
    #   '';
    #   extensionPackages = [ pkgs.mopidy-gmusic ];
    # };

    redshift = {
      enable = true;
      latitude = "153.0251";
      longitude = "-27.4698";
      temperature.day = 6500;
      temperature.night = 2700;
    };

    # https://blog.jeaye.com/2017/07/30/nixos-revisited/#minimizing-used-disk-space
    # Auto GC every morning
    # cron.systemCronJobs = [ "0 3 * * * root /etc/admin/optimize-nix" ];

    nixosManual.showManual = true;
  };

  virtualisation.docker.enable = true;

  fonts = {
    enableDefaultFonts = true;
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = collections.fonts;
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "inconsolata" ];
    };
  };

  users = {
    extraUsers.gil = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
      uid = 1000;
      shell = "/run/current-system/sw/bin/zsh";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  powerManagement.enable = true;

  networking.wireless.networks = {
    # Kara
    "Wi_Not_Eh" = {
      psk = builtins.readFile (./secrets/wi_not_eh_secret);
    };
    "Yourhub TAG WiFi" = {
      psk = "03563328";
    };
    # Thomas
    "Telstra62041D" = {
      psk = "BA19A99DF4";
    };
    # Brookhouse
    "Telstra1B3F" = {
      psk = "4631328620";
    };
    # Gillman BNE
    "OPTUSVD39EE7D8" = {
      psk = "poppydog76";
    };
    # Sycamore
    "NetComm 8372" = {
      psk = "Joniwivozi";
    };
    "eduroam" = {
        #ca_cert="/home/gil2a4/etc/wpa_supplicant/csiro.au.pem"
      extraConfig = ''
        scan_ssid=1
        key_mgmt=WPA-EAP
        eap=PEAP
        phase1="peapver=0"
        phase2="auth=MSCHAPV2"
        identity="s4407814@uq.edu.au"
        password="${builtins.readFile (./secrets/uq_secret)}"
      '';
    };
  };

  i18n.defaultLocale = "en_AU.UTF-8";

  time.timeZone = "Australia/Brisbane";
}
