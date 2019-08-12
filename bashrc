if [[ $(uname) == 'MINGW'* ]]; then win=1; fi;

. ~/dotfiles/bash_aliases

[ -f ~/sensitive.sh ] && source ~/sensitive.sh

if [ $win ]; then :;
else
	export TERM=screen-256color
	eval `dircolors ~/dotfiles/dircolors/dircolors.256dark`;
fi;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
