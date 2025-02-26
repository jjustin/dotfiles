# My nix configuration

## Private configuration

Private configuration is located in `private/private.nix` but is not part of the git tree.

### Structure

```nix
{
  gitIncludes = {
    path1 = {gitConfig = goesHere;};
    path2 = {gitConfig2 = goesHere;};
  };
}
```

## First time setup

### MacOS

1. Install nix

    ```sh
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```

    See: [Determinate Systems nix install](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#install-nix)

1. Build the system

    ```sh
    nix run nix-darwin/master#darwin-rebuild -- switch --flake path:///path/to/flake#arthur
    ```

## Rebuilding

rebuild with:

```sh
sudo nixos-rebuild switch --flake path:///path/to/flake#pinnochio
```

or

```sh
cd dotfiles
scp -r . jjustin@<pinnochio host ip>:/home/jjustin/dotfiles
ssh jjustin@<pinnochio host ip>
nixos-rebuild switch --flake path:///home/jjustin/dotfiles#pinnochio
```

or

```sh
darwin-rebuild switch --flake path:///path/to/flake#maccree
```

## Uninstall nix

See: [Determinate Systems nix uninstall](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#uninstalling)

## Hosts

| Host      | Description          |
| --------- | -------------------- |
| Arthur    | Mac mini             |
| Kratos    | Desktop WSL (unused) |
| Maccree   | Work Macbook         |
| Pinnochio | Raspberry PI         |
| Steve     | Server (unused)      |
| V         | Personal Laptop      |
