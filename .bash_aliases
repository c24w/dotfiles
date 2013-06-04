if [[ $(uname) == 'MINGW32'* ]]; then win=1; fi;

alias g=git

alias gs='g status'

alias ga='git add'
alias gaa='ga -A && gs'

alias gr='git reset'

alias gc='g commit'
alias gcm='gc -m'

alias gco='git checkout'

alias gpl='g pull'
alias gpsh='g push'

alias gl='git log --oneline'
alias gln='gl -n'

alias gd='g diff'

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

#alias sln=...?
alias .=openFileBrowser
alias st='"/c/Program Files/Sublime Text 2/sublime_text.exe"'