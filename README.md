# Dotfiles

To install dotfiles from this repo:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jjustin/dotfiles/main/.dotfiles.scripts/init.sh)"
```

then use `dot` to make changes to the repo.

To get branch files locally use `dot reset --hard <branch>`

## Gitconfig

To add per machine git config, .gitconfig.private can be used. It's automatically added by init script.

This allows for storing "common" `.gitconfig` in this repo and reducing
the exposure of information (that in my opinion should not be stored here).
For example emails. And also allows me to have multiple identities based
on the owner of the project I am working on.

Projects are stored in the following way:

```text
$HOME/
├─ .gitconfig
├─ company1/
│  ├─ .gitconfig
│  ├─ secretProject1/
│  ├─ secretProject2/
├─ personal/
│  ├─ .gitconfig
│  ├─ project1/
│  ├─ project2/
...
```

In the above example the private gitconfig would look something like:

```sh
[includeIf "gitdir:~/personal"]
    path=~/personal/.gitconfig

[includeIf "gitdir:~/company1"]
    path=~/company1/.gitconfig
```

## Zshrc

Similarly to `.gitconfig`, `.zshrc` sources `.zshrc.private` if it exists. This
allows for custom non-public scripts/functions and per-machine configuration.
