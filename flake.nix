{
  description = "jjustin's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    zsh-aws-vault = {
      url = "github:blimmer/zsh-aws-vault";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      getConfiguration =
        {
          home-manager-module,
          system,
          conf,
        }:
        {
          system = system;
          specialArgs = { inherit inputs; };

          modules = [
            home-manager-module
            conf
            ./variables.nix
            ./private
            ./modules/common

            (
              { config, lib, ... }:
              {
                # Enable Flakes and the new command-line tool
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                nixpkgs.overlays = import ./overlays/overlays.nix;

                nixpkgs.config.allowUnfreePredicate =
                  pkg: builtins.elem (lib.getName pkg) config.my.vars.unfreePackages;

                # Configure home manager
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  my = config.my;
                };

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.${config.my.vars.user.username} = import ./modules/home-manager/home.nix;
              }
            )
          ]
          ++ ({
            "x86_64-linux" = [ ./modules/nixos ];
            "aarch64-linux" = [ ./modules/nixos ];

            "aarch64-darwin" = [
              inputs.nix-homebrew.darwinModules.nix-homebrew
              ./modules/darwin
            ];
          }).${system};
        };
    in
    {
      nixosConfigurations = {
        "rpi" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "aarch64-linux";
          conf = ./hosts/rpi.nix;
        });
        "gaming" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "x86_64-linux";
          conf = ./hosts/gaming.nix;
        });
        "server" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "x86_64-linux";
          conf = ./hosts/server.nix;
        });
        "wsl" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "x86_64-linux";
          conf = ./hosts/wsl.nix;
        });
      };

      darwinConfigurations = {
        "work" = nix-darwin.lib.darwinSystem (getConfiguration {
          home-manager-module = home-manager.darwinModules.home-manager;
          system = "aarch64-darwin";
          conf = ./hosts/work.nix;
        });
      };
    };
}
