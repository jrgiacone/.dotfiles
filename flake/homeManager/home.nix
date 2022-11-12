{ config, home, pkgs, ... }:

{

  imports = [
    (import ./xmonad.nix)
  ];

  home = {
    username = "jrgiacone";
    homeDirectory ="/home/jrgiacone";

    stateVersion = "22.05";

    packages = with pkgs; [
      htop
      heroic
      gamemode
      (pkgs.libsForQt5.callPackage ./polychromatic.nix { inherit (pkgs) meson wrapGAppsHook; })
      libappindicator
      libappindicator-gtk3
    ];
  };
  programs.home-manager.enable = true;

}
