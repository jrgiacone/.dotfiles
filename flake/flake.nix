{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = github:nix-community/home-manager;
      # url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree =true;
      };
      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        jrgiacone = lib.nixosSystem {
          inherit system;
	  modules = [ 
	    ./modules/hardware-configuration.nix
	    ./modules/default.nix 
	    ./modules/nvidia.nix
	    ./modules/zfs.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.jrgiacone = {
		imports = [ ./homeManager/home.nix ];
	      };
	    }
	  ];
	};
      };
    };
}
