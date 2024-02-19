{
  description = "jjustin's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-aws-vault = {
      url = "github:blimmer/zsh-aws-vault";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations =
      let
        getConfiguration = conf: {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            conf
            ./variables.nix

            ./modules/nixos/localization.nix
            ./modules/nixos/networking.nix
            ./modules/nixos/obsidian.nix
            ./modules/nixos/users.nix
            ./modules/nixos/caps2esc.nix
            ./modules/nixos/plex.nix
            ./modules/nixos/udev.nix

            home-manager.nixosModules.home-manager
            ({ config, ... }: {
              # Configure home manager
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${config.myvars.user.username} = import ./modules/home-manager/home.nix;
            })
            {
              # Enable Flakes and the new command-line tool
              nix.settings.experimental-features = [ "nix-command" "flakes" ];

              # This value determines the NixOS release from which the default
              # settings for stateful data, like file locations and database versions
              # on your system were taken. It‘s perfectly fine and recommended to leave
              # this value at the release version of the first install of this system.
              # Before changing this value read the documentation for this option
              # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
              system.stateVersion = "23.11"; # Did you read the comment?
            }
          ];
        };
      in
      {
        "pinnochio" = nixpkgs.lib.nixosSystem (getConfiguration ./hosts/pinnochio.nix);
      };
  };
}
