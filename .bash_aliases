alias g=git

alias gs="g status"

alias ga="git add"
alias gaa="ga -A && gs"

alias gr="git reset"

alias gc="g commit"
alias gcm="gc -m"

alias gco="git checkout"

alias gpl="g pull"
alias gpsh="g push"

alias gl="git log"
alias gln="git log -n"

function snapshot() {
	flag=""
	select type in "Tracked" " + Untracked" "  + Ignored"; do
		case $type in
			Tracked ) flag=""; break;;
			" + Untracked" ) flag="-u"; break;;
			"  + Ignored" ) flag="-a"; break;;
		esac
	done
	g stash save $flag "snapshot ("`date +"%Y-%m-%d - %T"`")" $@
	g stash apply "stash@{0}"
}

alias snapshots="g stash list --grep snapshot"