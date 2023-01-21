# Dotfiles

To load dotfiles from this repo:

```sh
cd $HOME
git clone git@github.com:jjustin/dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
dot checkout
dot config --local status.showUntrackedFiles no
dot config --local include.path <path to .gitconfig file>
```

then use `dot` to make changes to the repo.

To get branch files locally use `dot reset --hard <branch>`

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
