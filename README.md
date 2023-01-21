# Dotfiles

To load dotfiles from this repo:

```sh
git clone --bare <git-repo-url> $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local include.path <path to .gitconfig file>
```

## Gitconfig

`.zshrc` shadow wraps `git`. Before every git action in a repository, all
directories from current one to `$HOME` are checked for any `.gitconfig` files.
The first one found is linked locally linked to the git repository.

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
