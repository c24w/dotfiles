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
alias gcaq='gca --no-edit'

alias gco='git checkout'

alias gpl='g pull'
alias gplr='gpl --rebase --autostash'
alias gpsh='g push'

alias gl='g log --oneline'
alias gln='g --no-pager log -n'

alias gd='g diff'
alias gdc='gd --cached'

function gdf {
  local CONTEXT=$([ -z "$1"] && echo 1000 || $(wc -l $1))
  gd -U$CONTEXT
}

alias gcp='g cherry-pick'

function grb {
  if [[ $# == 1 && "$1" =~ ^[0-9]+$ ]]; then
    g rebase --autostash -i HEAD~$1
  else
    g rebase $@
  fi
}

function gf {
  g fetch -q

  # http://stackoverflow.com/a/3278427/706561
  local UPSTREAM=${1:-'@{u}'}
  local LOCAL=$(git rev-parse @)
  local REMOTE=$(git rev-parse "$UPSTREAM")
  local BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
      echo 'Up-to-date'
    elif [ $LOCAL = $BASE ]; then
      echo 'Behind remote'
      gl $LOCAL..$UPSTREAM
    elif [ $REMOTE = $BASE ]; then
      echo 'Ahead of remote'
      gl $UPSTREAM..$LOCAL
    else
      echo -e 'Diverged\n--------'
      echo 'Remote:'
      gl $LOCAL..$UPSTREAM
      echo 'Local:'
      gl $UPSTREAM..$LOCAL
    fi
}

function gdr { # git diff remote
  gf
  gd @{u}..
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

# Apps
#######

function openFileBrowser {
  if [ $win ]; then
    explorer . &
  else
    nautilus "$PWD" &>/dev/null &
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

function AWS {
  [ $# -eq 0 ] && echo "Usage: $0 \$PROFILE [\$COMMAND]" && return
  local id=$(aws configure get $1.aws_access_key_id)
  local key=$(aws configure get $1.aws_secret_access_key)
  [ -z $id ] && echo "No credentials for profile '$1'" && return 1
  if [ $# -eq 1 ]; then
    export AWS_ACCESS_KEY_ID=$id; export AWS_SECRET_ACCESS_KEY=$key
    echo "Exported credentials for profile '$1'"
    return
  fi
  AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key "${@:2}"
}

function tmp {
  dir="$(mktemp -d -t $(date -In).XXX)"
  $SHELL -c "cd $dir; exec $SHELL"
  read -kn 1 "cleanup?Remove $dir? [y/N] "
  [[ "$cleanup" =~ [Yy] ]] && rm -rf "$dir"
}
