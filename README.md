# Dotfiles

## Getting started

To install dotfiles from this repo:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jjustin/dotfiles/main/.dotfiles.scripts/init.sh)"
```

then use `dot` to make changes to the repo.

## Gitconfig

1. To add per machine git config or git config with personal information
.gitconfig.private can be used. It's automatically added by init script.

2. `.zshrc` shadow wraps `git`. Before every git action in a repository, all
directories from current one to `$HOME` are checked for any `.gitconfig` files.
The first one found is locally linked to the git repository. This is done
in `.link_git.sh`.

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
[includeIf "gitdir:~/personal/"]
    path=~/personal/.gitconfig

[includeIf "gitdir:~/company1/"]
    path=~/company1/.gitconfig
```

## Zshrc

Similarly to `.gitconfig`, `.zshrc` sources `.zshrc.private` if it exists. This
allows for custom non-public scripts/functions and per-machine configuration.

## Working with changes

The changes are located in two different directories. The first one are the actual files that are in used (`in-use`). Those are located in `$HOME`. The second ones are located where `.git` is stored - in `$HOME/.dotfiles` (`"staged"`).

### Staging in-use changes

To see the changed files use:

```
dot status
```

and then to add all changed files:

```
dot add -u 
```

### Staging "staged" changes

```
cd $HOME/.dotfiles
git status
git add <...>
```

Either of the above approaches will now have changes staged in dotfiles's git index.

To commit and push them:

```
dot commit
dot push
```

### Applying changes

to apply "staged" changes after they are commited:

```
dot reset --hard main
```

to apply changes from origin:

```
dot reset --hard origin/main
```
