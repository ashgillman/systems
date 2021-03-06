{ stdenv, pkgs }:

let
  myEmacs = import ./emacs.nix { inherit pkgs; };

in {
  base = with pkgs; [
    # base utilities
    coreutils   # expected linux tools
    inetutils   # traceroute, ping, hostname, etc.
    lsof        # list open files
    pciutils    # lspci, etc.
    syslinux    # gethostip, etc.
    usbutils

    # filesystems
    exfat
    ntfs3g

    # extra utilities
    curl
    gnumake     # make
    gnupg1      # GPG
    openssl
    unzip
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

  emacs = with pkgs; [
    myEmacs
    rtags   # for rdm
    irony-server
  ];

  fonts = with pkgs; with import ./fonts.nix { inherit stdenv pkgs; }; [
    corefonts
    inconsolata
    nerdfont_dejavu
    nerdfont_inconsolata
    source-code-pro
    ubuntu_font_family
    #unifont
    #ipaexfont
    liberation_ttf
    dejavu_fonts
    bakoma_ttf
    gentium
    ubuntu_font_family
    terminus_font
    caladea
    carlito
    liberation_ttf
    liberationsansnarrow
    google-fonts
  ];

  music = with pkgs; [
    ncmpcpp
  ];

  nix = with pkgs; [
    nix-prefetch-scripts # Prefetch source archives
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
