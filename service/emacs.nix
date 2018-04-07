{ config, pkgs, ... }:

let
  emacs = import ../nixpkgs/emacs.nix { inherit pkgs; };
in {
  environment.systemPackages = [ emacs pkgs.aspell pkgs.aspellDicts.en ];

  systemd.user.services.emacs = {
    description = "Emacs: the extensible, self-documenting text editor";

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.bash}/bin/bash -c "
                      + "'source ${config.system.build.setEnvironment}; "
                  + "exec ${emacs}/bin/emacs --daemon'";
      ExecStop = "${emacs}/bin/emacsclient --eval (kill-emacs)";
      Restart = "always";
    };

    # I want the emacs service to be started with the rest of the user services
    wantedBy = [ "default.target" ];

    # Annoyingly, systemd doesn't pass any environment variable to its
    # services. Below, I set some variables that I missed.
    environment = {
      # Give Emacs a chance to use gnome keyring for the ssh-agent
      SSH_AUTH_SOCK   = "%t/keyring/ssh";

      # ASPELL
      LANG = "en_GB-ise";

      # for GTK applications launched from Emacs (e.g., evince)
      GTK_DATA_PREFIX = config.system.path;
      GTK_PATH = "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";

      LOCATE_PATH = "/var/cache/locatedb";
    };
  };
}
