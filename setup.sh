#!/bin/bash
set -eo pipefail
############################
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc xchat2 tmux.conf"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

mkdir -p /tmp/dotfiles
pushd /tmp/dotfiles
git clone --depth 1 https://github.com/Anthony25/gnome-terminal-colors-solarized.git
pushd gnome-terminal-colors-solarized
./install.sh -p $(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]\',") -s dark --install-dircolors
popd; popd
rm -rf /tmp/dotfiles

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

mkdir -p ~/bin
ln -s ~/dotfiles/node ~/bin/node
ln -s ~/dotfiles/node ~/bin/nodejs
ln -s ~/dotfiles/node ~/bin/npm
