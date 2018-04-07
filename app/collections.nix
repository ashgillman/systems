{ stdenv, pkgs }:

{
  base = with pkgs; [
    coreutils   # expected linux tools
    curl
    gnumake     # make
    gnupg1      # GPG
    inetutils   # traceroute, ping, hostname, etc.
    ntfs3g
    openssl
    pciutils    # lspci, etc.
    unzip
    usbutils
    syslinux    # gethostip
    vimHugeX    # simple editor + bells + whistles
    wget
    xlibs.xev
    xorg.xdpyinfo
  ];

  extras = with pkgs; with gitAndTools; [
    ag             # silver searcher, search for text in directory
    bc             # calculator
    direnv         # Manage environment on cd into project
    ffmpeg         # video conversion
    git            # vc
      git-octopus  # git octopus-style merging
      git-lfs      # git large file storage
    transcrypt     # git encryption
    htop           # process viewer
    imagemagick    # Image tools
    irssi          # IRC
    jq             # JSON cmdline tool
    ncdu           # ncurses disk usage
    openconnect    # Cisco VPN
    pass           # Password store
    scrot          # screen capture
    tmux           # manage sessions
    tmuxinator     # manage session manager
    tree           # list subdirs in a tree
    neovim         # editor
    w3m            # command line browser
    xclip          # clipboard
    zsh            # Shell with good autocomplete features
  ];

  guis = with pkgs; [
    dillo                      # quick startup browser
    feh                        # image viewer
      libjpeg                  # used by feh
    firefox                    # browser
    gimp                       # image editor
    thunderbird                # email
    rxvt_unicode_with-plugins  # terminal
    wpa_supplicant_gui         # WiFi
    zathura                    # pdf
  ];

  fonts = with import ./fonts.nix { inherit stdenv, pkgs; }[
    corefonts
    inconsolata
    nerdfont_dejavu
    nerdfont_inconsolata
    source-code-pro
    ubuntu_font_family
    #unifont
    #ipaexfont
  ];

  music = with pkgs; [
    ncmpcpp
  ];

  nix = with pkgs; [
    nix-prefetch-scripts # Prefetch source archives
    nix-repl             # Experiment with Nix
    nix-serve            # Serve binaries
    nox                  # Other Nix tools
  ];

  writing = with pkgs; [
    aspell            # spellcheck
      aspellDicts.en  # in english
    graphviz          # graph diagrams
    pandoc            # document conversion
  ];
}
