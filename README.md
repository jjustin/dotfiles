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

## Building

rebuild with:

```sh
sudo nixos-rebuild switch --flake path:///path/to/flake#pinnochio
```

or

```sh
darwin-rebuild switch --flake path:///path/to/flake#maccree
```
