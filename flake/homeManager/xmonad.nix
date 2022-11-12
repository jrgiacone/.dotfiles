{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };
  };
}
