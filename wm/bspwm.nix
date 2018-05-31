{ config, pkgs, ... }:

let
  refreshmon_bspwm = pkgs.writeShellScriptBin "refreshmon_bspwm" ''
    refreshmon

    function getmon () {
      xrandr | grep ' connected' | cut -d' ' -f1
    }

    # Update desktops
    I=1
    M=$(getmon | wc -l)
    if [[ "$M" == 1 ]]; then
      bspc monitor -d I II III IV V VI VII VIII IX X
    elif [[ "$M" == 2 ]]; then
      bspc monitor $(getmon | awk NR==2) -d I II III IV V
      bspc monitor $(getmon | awk NR==1) -d VI VII VIII IX X
    elif [[ "$M" == 3 ]]; then
      bspc monitor $(getmon | awk NR==3) -d I II III IV
      bspc monitor $(getmon | awk NR==2) -d V VI VII
      bspc monitor $(getmon | awk NR==1) -d VIII IX X
    elif [[ "$M" == 4 ]]; then
      bspc monitor $(getmon | awk NR==4) -d I II III
      bspc monitor $(getmon | awk NR==3) -d IV V VI
      bspc monitor $(getmon | awk NR==2) -d VII VIII
      bspc monitor $(getmon | awk NR==1) -d IX X
    elif [[ "$M" == 5 ]]; then
      bspc monitor $(getmon | awk NR==5) -d I II
      bspc monitor $(getmon | awk NR==4) -d III IV
      bspc monitor $(getmon | awk NR==3) -d V VI
      bspc monitor $(getmon | awk NR==2) -d VII VIII
      bspc monitor $(getmon | awk NR==1) -d IX X
    else
      for monitor in $(getmon); do
      bspc monitor $monitor \
          -n "$I" \
          -d $I/{a,b,c}
      let I++
      done
    fi

    # remove unused bspwm monitors
    for bspwm_monitor in $(bspc query -M --names); do
      contained=false
      for monitor in $(xrandr | grep ' connected' | cut -d' ' -f1); do
        if [[ "$bspwm_monitor" = "$monitor" ]]; then
          contained=true
        fi
      done
      if [ "$contained" = false ]; then
        bspc monitor "$bspwm_monitor" --remove
      fi
    done
  '';

in {
  imports = [
    ./common-extras.nix
  ];

  services.xserver = {
    desktopManager.default = "none"; # bspwm?
    windowManager.bspwm = {
      enable = true;
      configFile = ./bspwm/bspwmrc;
      sxhkd.configFile = ./bspwm/sxhkdrc;
    };
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    refreshmon_bspwm
  ];
}
