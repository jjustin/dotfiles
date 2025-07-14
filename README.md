# My nix configuration

## Private configuration

Private configuration is located in `private/private.nix` but is not part of the git tree.
See `private/options.nix` for it's structure.

## First time setup

### MacOS

1. Install nix

    ```sh
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```

    Select "No" when asked to install Determinate Nix.
    Let `darwin-nix` handle the installed nix instance.

    See: [Determinate Systems nix install](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#install-nix)

1. Build the system

    ```sh
    nix run nix-darwin/master#darwin-rebuild -- switch --flake path:///path/to/flake#arthur
    ```

### WSL

1. Install Nix WSL distribution
    - <https://github.com/nix-community/NixOS-WSL>
    - <https://nixos.wiki/wiki/WSL>

1. Install microsoft terminal
    - <https://github.com/microsoft/terminal?tab=readme-ov-file#installing-and-running-windows-terminal>

1. Install Meslo font as your terminal font
   - <https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k>

1. Follow the rebuilding section to install Nix configuration

1. Terminate NixOS WSL distro with `wsl -t NixOS` and restart to enable newly crated user to be used with NixOS

## Rebuilding

rebuild with:

```sh
sudo nixos-rebuild switch --flake path:///path/to/flake#wsl
```

or

```sh
nixos-rebuild switch --flake path:///home/jjustin/dotfiles#server --target-host root@steve.local.jjustin.dev
```

or

```sh
cd dotfiles
scp -r . jjustin@<rpi host ip>:/home/jjustin/dotfiles
ssh jjustin@<rpi host ip>
nixos-rebuild switch --flake path:///home/jjustin/dotfiles#rpi
```

or

```sh
darwin-rebuild switch --flake path:///path/to/flake#work
```

## Uninstall nix

### Uninstall MacOS

See: [Determinate Systems nix uninstall](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#uninstalling)

## Cloudflare

### How to get credentials

Enter a shell with cloudflared installed

```sh
nix-shell -p cloudflared
```

Login and create a tunnel

```sh
cloudflared tunnel login
cloudflared tunnel create home
```

### DNS

Go to cloudflare portal under `<Your domain> -> DNS -> Records` and add a CNAME entry pointing to `<your tunnel id>.cfargotunnel.com`

## SMB

A password for SMB sharing has to be added manually with:

```sh
sudo smbpasswd -a <username>
```
