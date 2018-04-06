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
alias gplr='gpl --rebase --autostash'
alias gpsh='g push'

alias gl='g log --oneline'
alias gln='g --no-pager log -n'

alias gd='g diff'
alias gdf='gd --no-prefix -U1000'
alias gdc='gd --cached'
alias gdcf='gdf --cached'

alias gcp='g cherry-pick'

function git-branch-name {
  echo $(git symbolic-ref HEAD --short)
}

alias gcp='g cherry-pick'

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
