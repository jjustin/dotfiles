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
      url = "github:nix-community/home-manager/release-25.05";
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

    caddy-cloudflare = {
      url = "github:caddy-dns/cloudflare";
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

          modules =
            [
              home-manager-module
              conf
              ./variables.nix
              ./private
              ./modules/common/misc.nix
              ./modules/common/programs.nix
              ./modules/common/packages.nix

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
            ++ (
              let
                linuxModules = [
                  ./modules/nixos/caddy.nix
                  ./modules/nixos/caps2esc.nix
                  ./modules/nixos/docker.nix
                  ./modules/nixos/immich.nix
                  ./modules/nixos/localization.nix
                  ./modules/nixos/nvidia.nix
                  ./modules/nixos/networking.nix
                  ./modules/nixos/obsidian.nix
                  ./modules/nixos/packages.nix
                  ./modules/nixos/plex.nix
                  ./modules/nixos/qbittorrent.nix
                  ./modules/nixos/smb.nix
                  ./modules/nixos/ssh.nix
                  ./modules/nixos/syncthing.nix
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
                  (
                    { config, ... }:
                    {
                      my.vars.user.homeDirectory = "/Users/${config.my.vars.user.username}";
                      users.users.${config.my.vars.user.username} = {
                        name = config.my.vars.user.username;
                        home = config.my.vars.user.homeDirectory;
                      };

                      system.primaryUser = config.my.vars.user.username;

                      system.stateVersion = 5;
                    }
                  )
                ];
              }
            ).${system};
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
