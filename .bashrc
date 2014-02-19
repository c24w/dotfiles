if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi;

if [ -f ~/sensitive.sh ]; then
	source ~/sensitive.sh
fi;

if [ $win ]; then :;
else
	#Tell tmux we have 256 colours
	export TERM=xterm-256color

	eval `dircolors ~/dotfiles/dircolors/dircolors.256dark`;

	function git-branch-name-for-prompt {
		if [ -d .git ] || [ $(g rev-parse --is-inside-work-tree 2> /dev/null) ]; then
			echo '('$(git-branch-name)')';
		fi;
	}

	PS1='[\u@\h \W]$(git-branch-name-for-prompt) $ '
fi;
