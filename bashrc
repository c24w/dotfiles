if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi;

[ -f ~/sensitive.sh ] && source ~/sensitive.sh

if [ $win ]; then :;
else
	export TERM=screen-256color
	eval `dircolors ~/dotfiles/dircolors/dircolors.256dark`;
fi;
