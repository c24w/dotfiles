if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

alias ls='ls --color=auto'
alias l='ls -Al'

alias g=git

alias gst='g status'
alias gs='gst -s'

alias ga='g add'
alias gaa='ga -A && gs'

alias gr='g reset'

alias gc='g commit -v'
alias gcm='gc -m'
alias gcu='gr --soft HEAD^'
alias gca='gc --amend'
alias gcaq='gca -C HEAD'

alias gco='git checkout'

alias gpl='g pull'
alias gplr='gpl --rebase'
alias gpsh='g push'

alias gl='g log --oneline'
alias gln='g --no-pager log -n'

alias gd='g diff'

alias gcp='g cherry-pick'

function git-branch-name {
	echo $(git symbolic-ref HEAD --short)
}

# Fetch and log difference in commits
function gf {
	g fetch -q
	gst | grep --color=never 'Your branch'
	numNewCommits=$(g rev-list HEAD...origin/$(git-branch-name) --count)
	gln $numNewCommits --oneline HEAD...origin/$(git-branch-name)
}

function set-branch-merged {
	currentBranch=$(git symbolic-ref HEAD --short)
	g push -q origin $currentBranch:merged/$currentBranch
	g branch -r --color | grep $currentBranch # Show renamed remote branch
	echo -e '\ndelete original remote branch:'
	echo -e 'gpsh origin :'$currentBranch'\n'
	echo -e 'delete original local branch:'
	echo -e 'g branch -d '$currentBranch
}

realVim=$(which vim);
function vim {
	if [ $win ]; then
		powershell -executionpolicy bypass -file ~/.vim/gvim-shared.ps1 $@;
	else
		$realVim $@;
	fi
}

# Snapshots
############

function snapshot {
	flag=''
	select type in 'Tracked' ' + Untracked' '  + Ignored'; do
		case $type in
			Tracked ) flag=''; break;;
			' + Untracked' ) flag='-u'; break;;
			'  + Ignored' ) flag='-a'; break;;
		esac
	done
	g stash save $flag 'snapshot ('`date +'%Y-%m-%d - %T'`')' $@
	g stash apply 'stash@{0}'
}

alias snapshots='g stash list --grep snapshot'

function load-snapshot {
	g stash apply stash@{$1}
}

# Navigation
#############

alias wk='cd /c/work'
alias .com='cd /c/work/sevendigital-com/'

# Apps
#######

function openFileBrowser {
	if [ $win ]; then
		explorer . &;
	else
		nautilus . &;
	fi
}

alias ,=openFileBrowser

function sln {
	if [ $win ]; then
		cmd /q //c "for %f in (*.sln) do echo Opening %f & start %f";
	else
		echo "You're in Linux you twat."
	fi
}
