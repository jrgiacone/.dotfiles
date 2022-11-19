# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
    ];

  #services.zfs.trim.enable = true;
  #services.zfs.autoScrub.enable = true;

  #fileSystems."/".options = ["compression=zstd"];

  programs.gnupg.agent.enableSSHSupport = true;
  programs.seahorse.enable = true;
  
  programs.steam = {
    enable = true;
  #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };





  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # networking.useDHCP = false;
  # networking.interfaces.enp1s0.useDHCP = true;
  # networking.hostId = "06a66fb8";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  hardware.openrazer.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        startx.enable = true;
      };
    };
  };


  # Enable the Plasma 5 Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    }; 

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jrgiacone = {
    isNormalUser = true;
    extraGroups = [ "wheel" "openrazer" "plugdev" ]; # Enable ‘sudo’ for the user.
  };

  fonts = {
   fonts = with pkgs; [
     font-awesome
     (nerdfonts.override { fonts = ["CascadiaCode"]; })
   ];
  };

  nixpkgs.config.allowUnfree = true;

  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #firefox # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    firefox-bin
    chromium
    discord
    pavucontrol
    # (pkgs.libsForQt5.callPackage ../polychromatic.nix { inherit (pkgs) meson wrapGAppsHook; })

    alacritty

    wget
    vifm
    ncdu
    neofetch

    git
    gh
    steam

    rofi
    trayer
    xdotool
    dmenu
    picom
    nitrogen
    dunst
    xmobar
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}

