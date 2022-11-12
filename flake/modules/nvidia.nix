{ config, pkgs, ... }:

{

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  environment.systemPackages = [
    pkgs.nvidia-vaapi-driver
  ];

}
