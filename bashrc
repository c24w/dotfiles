if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi;

[ -f ~/sensitive.sh ] && source ~/sensitive.sh

if [ $win ]; then :;
else
	eval `dircolors ~/dotfiles/dircolors/dircolors.256dark`;
fi;
