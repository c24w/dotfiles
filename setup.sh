#!/bin/bash
set -eo pipefail
############################
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

here=~/dotfiles                    # dotfiles directory
backup_dir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc xchat2 tmux.conf"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $backup_dir for backup of any existing dotfiles in ~ ..."
mkdir -p $backup_dir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $here directory ..."
cd $here
echo "done"

echo "Backing up existing dotfiles to $backup_dir"
for file in $files; do
    [ -e "$file" ] && [ -e "~/.$file" ] && echo "Moving ~/.$file to $backup_dir." && mv -r "~/.$file" "$backup_dir"
    echo "Symlinking "$here/$file" to ~/.$file"
    ln -srf "$file" "$HOME/.$file" # ln doesn't understand ~ when quoted
done

mkdir -p /tmp/dotfiles
pushd /tmp/dotfiles
git clone --depth 1 https://github.com/Anthony25/gnome-terminal-colors-solarized.git
pushd gnome-terminal-colors-solarized
./install.sh -p $(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]\',") -s dark --install-dircolors
popd; popd
rm -rf /tmp/dotfiles

git clone --depth 1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
