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
      url = "github:nix-community/home-manager/release-24.11";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "nix-darwin";
      };
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
      private = import ./private/private.nix;
      getConfiguration =
        {
          home-manager-modules,
          system,
          conf,
        }:
        {
          system = system;
          specialArgs = { inherit inputs; };

          modules =
            [
              conf
              ./variables.nix
              ./modules/common/misc.nix
              ./modules/common/programs.nix
              ./modules/common/packages.nix

              home-manager-modules.home-manager
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
                    pkg: builtins.elem (lib.getName pkg) config.myvars.unfreePackages;

                  # Configure home manager
                  home-manager.extraSpecialArgs = {
                    inherit inputs private;
                    myvars = config.myvars;
                  };

                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  home-manager.users.${config.myvars.user.username} = import ./modules/home-manager/home.nix;
                }
              )
            ]
            ++ (
              let
                linuxModules = [
                  ./modules/nixos/caps2esc.nix
                  ./modules/nixos/localization.nix
                  ./modules/nixos/nvidia.nix
                  ./modules/nixos/networking.nix
                  ./modules/nixos/obsidian.nix
                  ./modules/nixos/plex.nix
                  ./modules/nixos/qbittorrent.nix
                  ./modules/nixos/ssh.nix
                  ./modules/nixos/udev.nix
                  ./modules/nixos/users.nix
                  {
                    # This value determines the NixOS release from which the default
                    # settings for stateful data, like file locations and database versions
                    # on your system were taken. It‘s perfectly fine and recommended to leave
                    # this value at the release version of the first install of this system.
                    # Before changing this value read the documentation for this option
                    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
                    system.stateVersion = "23.11"; # Did you read the comment?
                  }
                ];
              in
              {
                "x86_64-linux" = linuxModules;
                "aarch64-linux" = linuxModules;

                "aarch64-darwin" = [
                  inputs.nix-homebrew.darwinModules.nix-homebrew
                  ./modules/darwin/caps2esc.nix
                  ./modules/darwin/homebrew.nix
                  ./modules/darwin/packages.nix
                  ./modules/darwin/system.nix
                  ({
                    myvars.user.homeDirectory = "/Users/jjustin";
                    system.stateVersion = 5;
                  })
                ];
              }
            ).${system};
        };
    in
    {
      nixosConfigurations = {
        "pinnochio" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-modules = home-manager.nixosModules;
          system = "aarch64-linux";
          conf = ./hosts/pinnochio.nix;
        });
        "v" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-modules = home-manager.nixosModules;
          system = "x86_64-linux";
          conf = ./hosts/v.nix;
        });
        "steve" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-modules = home-manager.nixosModules;
          system = "x86_64-linux";
          conf = ./hosts/steve.nix;
        });
        "kratos" = nixpkgs.lib.nixosSystem (getConfiguration {
          home-manager-modules = home-manager.nixosModules;
          system = "x86_64-linux";
          conf = ./hosts/kratos.nix;
        });
      };

      darwinConfigurations = {
        "maccree" = nix-darwin.lib.darwinSystem (getConfiguration {
          home-manager-modules = home-manager.darwinModules;
          system = "aarch64-darwin";
          conf = ./hosts/maccree.nix;
        });

        "arthur" = nix-darwin.lib.darwinSystem (getConfiguration {
          home-manager-modules = home-manager.darwinModules;
          system = "aarch64-darwin";
          conf = ./hosts/arthur.nix;
        });
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

    };
}
