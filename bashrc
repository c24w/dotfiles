if [[ $(uname) == 'MINGW'* ]]; then win=1; fi;

. ~/dotfiles/bash_aliases

[ -f ~/sensitive.sh ] && source ~/sensitive.sh

if [ $win ]; then :;
else
	export TERM=screen-256color
	eval `dircolors ~/dotfiles/dircolors/dircolors.256dark`;
fi;
