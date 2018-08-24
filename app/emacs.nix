{ pkgs, ... }:

let
  python2 = pkgs.python2.withPackages (_: {
    extraLibs = [ pkgs.wakatime ];
  });

  gtk3Emacs = pkgs.emacs.override {
    withGTK3 = true;
    withGTK2 = false;
  };
  gtk3EmacsWithPackages = (pkgs.emacsPackagesNgGen gtk3Emacs).emacsWithPackages (
    epkgs: (with epkgs; [
      # nix-env -qaPA nixos.emacsPackagesNg
      auctex
      #avy
      ag
      #base16-theme
      diminish
      exec-path-from-shell
      flycheck
      guide-key
      helm
      helm-ag
      helm-projectile
      highlight-symbol
      htmlize
      markdown-mode
      monokai-theme
      powerline
      powerline-evil
      projectile
      project-root
      rainbow-mode
      wgrep-ag
      #yasnippet

      # programming
      csv-mode
      docker
      dockerfile-mode
      ggtags
      graphviz-dot-mode
      lua-mode
      magit
      nix-mode
      yaml-mode
      wakatime-mode

      # c++
      ac-clang
      clang-format
      #cmake-ide
      cmake-mode
      flycheck-irony
      irony
      rtags
      #helm-rtags

      # company
      company
      company-anaconda
      company-irony
      company-irony-c-headers
      company-math
      company-nixos-options

      # evil
      evil
      evil-leader
      evil-indent-textobject
      evil-jumper
      evil-magit
      evil-surround

      # org mode
      org-ac

      # python
      cython-mode
      elpy
      ob-ipython

    ]) ++ (with epkgs.elpaPackages; [
    ]) ++ (with epkgs.melpaStablePackages; [
    ]) ++ (with epkgs.melpaPackages; [
      org-ref
      wc-mode
    ]) ++ (with epkgs.orgPackages; [
      org-plus-contrib
    ]));
  gtk3EmacsWithPackagesAndExternalDepsAndEnviron =
    with pkgs.stdenv.lib;
    overrideDerivation gtk3EmacsWithPackages (oldAttrs: rec {
      # variables, desktop link
      installPhase = ''
        runHook preInstall

        mkdir -p "$out/bin"
        # Wrap emacs and friends so they find our site-start.el before the original.
        for prog in $emacs/bin/*; do # */
          local progname=$(basename "$prog")
          rm -f "$out/bin/$progname"
          makeWrapper "$prog" "$out/bin/$progname" \
            --prefix PATH : "${makeBinPath propagatedBuildInputs}" \
            --suffix EMACSLOADPATH ":" "$deps/share/emacs/site-lisp:" \
            --prefix PYTHONPATH : $PYTHONPATH \
            --set WAKATIME_PYTHON_BIN "${python2.python.interpreter}" \
            --set WAKATIME_CLI_PATH "${pkgs.wakatime}/bin/wakatime"
        done
        mkdir -p $out/share
        # Link icons and desktop files into place
        for dir in applications icons info man; do
          ln -s $emacs/share/$dir $out/share/$dir
        done

        runHook postInstall
      '';

      # external dependencies
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ (
        (with pkgs; [
          gitAndTools.git gitAndTools.transcrypt # for magit
          # aspell # spell checking
        ]) ++ (with pkgs.python3.pkgs; [
          autopep8
          elpy
          flake8
          importmagic
          jedi
          yapf
        ])
      );
    });

in gtk3EmacsWithPackagesAndExternalDepsAndEnviron
