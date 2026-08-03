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
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    homebrew = {
      url = "github:koalalorenzo/home-manager-brew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";

    zsh-aws-vault = {
      url = "github:blimmer/zsh-aws-vault";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      darwin-custom-icons,
      ...
    }@inputs:
    let
      homeModules = {
        host,
      }: [
        ./variables.nix
        ./private

        ./modules/home-manager/home.nix
        host
        ({config, lib,...}: {
          nixpkgs.config.allowUnfreePredicate =
            pkg: builtins.elem (lib.getName pkg) config.my.vars.unfreePackages;
        })
      ];
      getConfiguration =
        {
          home-manager-module,
          system,
          host,
        }:
        {
          system = system;
          specialArgs = { inherit inputs; };

          modules = [
            home-manager-module
            host
            ./variables.nix
            ./private

            (
              { config, lib, ... }:
              {
                # Enable Flakes and the new command-line tool
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                nixpkgs.config.allowUnfreePredicate =
                  pkg: builtins.elem (lib.getName pkg) config.my.vars.unfreePackages;

                # Configure home manager
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  my = config.my;
                };

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.${config.my.vars.user.username}.imports = homeModules {
                  host.my.vars = config.my.vars;
                };
              }
            )
          ]
          ++ ({
            "x86_64-linux" = [ ./modules/nixos ];
            "aarch64-linux" = [ ./modules/nixos ];

            "aarch64-darwin" = [
              darwin-custom-icons.darwinModules.default
              ./modules/darwin
            ];
          }).${system};
        };
    in
    {
      homeConfigurations = {
        "gaming" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = {
            inherit inputs;
          };
          
          modules = homeModules {
            host = ./hosts/gaming.nix;
          };
        };
      };
      
      nixosConfigurations = {
        "rpi" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "aarch64-linux";
          host = ./hosts/rpi.nix;
        });
        "server" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "x86_64-linux";
          host = ./hosts/server.nix;
        });
        "wsl" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-module = home-manager.nixosModules.home-manager;
          system = "x86_64-linux";
          host = ./hosts/wsl.nix;
        });
      };

      darwinConfigurations = {
        "personal-mac" = nix-darwin.lib.darwinSystem (getConfiguration {
          home-manager-module = home-manager.darwinModules.home-manager;
          system = "aarch64-darwin";
          host = ./hosts/personal-mac.nix;
        });
        "work" = nix-darwin.lib.darwinSystem (getConfiguration {
          home-manager-module = home-manager.darwinModules.home-manager;
          system = "aarch64-darwin";
          host = ./hosts/work.nix;
        });
      };
    };
}
