{ config, home, pkgs, ... }:

let

customNeovim = import ./nvim.nix;

in
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
      ripgrep
      neovim-unwrapped
      heroic
      gamemode
      (pkgs.libsForQt5.callPackage ./polychromatic.nix { inherit (pkgs) meson wrapGAppsHook; })
      lxappearance
      lazygit
      papirus-icon-theme
    ];
  };
  programs.home-manager.enable = true;
  programs.neovim = customNeovim pkgs;



}
