if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

alias g=git

alias gs='g status -s'

alias ga='git add'
alias gaa='ga -A && gs'

alias gr='git reset'

alias gc='g commit'
alias gcm='gc -m'
alias gcu='gr --soft HEAD^'
alias gca='gc --amend'
alias gcaq='gc --amend -C HEAD'

alias gco='git checkout'

alias gf='g fetch -q && (g status | grep "Your branch")'

alias gpl='g pull'
alias gplr='gpl --rebase'
alias gpsh='g push'

alias gl='git log --oneline'
alias gln='gl -n'

alias gd='g diff'

alias gcp='g cherry-pick'

# +-----------+
# | Snapshots |
# +-----------+

function snapshot() {
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

alias load-snapshot='g stash apply "stash@{$1}"'

# +------------+
# | Navigation |
# +------------+

alias wk='pushd /c/work'
alias .com='pushd /c/work/sevendigital-com/'
alias js='pushd /c/work/sevendigital-com/src/SevenDigital.Com.Web/Static/js'

# +------+
# | Apps |
# +------+

function openFileBrowser() {
	if [ $win ]; then
		explorer .;
	else
		nautilus .;
	fi
}

function openSln() {
	if [ $win ]; then
		cmd /q //c "for %f in (*.sln) do echo Opening %f & start %f";
	else
		echo "You're in Linux you twat."
	fi
}

function openSublimeText() {
	'/c/Program Files/Sublime Text 2/sublime_text.exe' $1 &
}

alias sln=openSln
alias ,=openFileBrowser
alias st=openSublimeText