# Dotfiles

## Getting started

To install dotfiles from this repo:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jjustin/dotfiles/main/.dotfiles.scripts/init.sh)"
```

then use `dot` to make changes to the repo.

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
