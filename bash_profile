export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/lib"
export ARCHFLAGS="-arch i386"
export HISTSIZE="2000"
export HISTIGNORE="&:ls:[bf]g:exit"
export PASSENGER_TMPDIR=/Sites/config/tmp
export EDITOR=vim
export SVN_EDITOR=vim
export RUBYOPT="rubygems"
export RUBYLIB="/usr/local/lib:$RUBYLIB"
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

# rvm 1.8.7

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"

PS1="\$(date +%H:%M) \w\$ "

alias mb='mate ~/.bash_profile'
alias sub='subl ~/.bash_profile'
alias sb='source ~/.bash_profile'

# General
alias l='ls -lah'
alias ls='ls -lahF'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias bcc='bundle exec cucumber -f progress'
alias bss='bundle exec spec'
alias brs='bundle exec rspec'

function manpdf() {
 man -t $@ | open -f -a /Applications/Preview.app/
}

# TextMate, mate all of current dir and crucial rails folders only
alias mr='mate app config db doc lib public test spec features stories Gemfile'
alias m='mate'

#Sublime text
alias s='subl'

function o {
  open ${1:-.}
}

function ghc {
  gh_url=${1:-`pbpaste`}
  co_dir=${HOME}/Code/sources/$(echo $gh_url | sed -e 's/^git:\/\/github.com\///; s/\//-/; s/\.git$//')

  if [ -d $co_dir ]; then
    cd $co_dir && git pull origin master
  else
    git clone "${gh_url}" "${co_dir}" && cd "${co_dir}" && mate .
  fi
}

# rails scripts
alias ss='./script/server'
alias rs='rails server'
alias rc='rails console'

function sc {
  if [ -x script/console ]; then
    script/console $*
  else
    sinatra_rb=`egrep -l "^require.+sinatra.$" *.rb 2>/dev/null`
    if [ -e $sinatra_rb ]; then
      irb -r $sinatra_rb $*
    else
      irb $*
    fi
  fi
}

# tail logs
alias tl='tail -f ./log/development.log'
alias tt='tail -f ./log/test.log'
alias tp='tail -f ./log/production.log'

# clean the logs
alias ctl='cp /dev/null ./log/test.log'
alias cdl='cp /dev/null ./log/development.log'

alias dbfl='bundle exec rake spec:db:fixtures:load'

alias a='autotest -rails'
alias dbm='bundle exec rake db:migrate'
alias dbm0='bundle exec rake db:migrate VERSION=0'
alias dbi='bundle exec rake db:initialise'
alias dbiz='bundle exec rake db:initialize'
alias dbp='bundle exec rake db:populate'
alias dbtp='bundle exec rake db:test:prepare'
alias dbda='bundle exec rake db:drop:all'
alias dbca='bundle exec rake db:create:all'
alias dbcycle='dbda && dbca && dbm; dbi; dbp; dbtp'
alias dbzycle='dbda && dbca && dbm; dbiz; dbp; dbtp'

# Phusion Passenger

alias r='touch tmp/restart.txt'
alias ra='sudo /usr/sbin/apachectl restart'
alias mh='mate /etc/hosts'
alias ms='mate ~/.ssh/config'
alias ma='mate ~/projects/config/passenger_vhosts.conf'
alias fdns='sudo dscacheutil -flushcache'

alias sh='subl /etc/hosts'

# Legacy
alias mo='mate ~/.odbc.ini'
alias mf='mate ~/.freetds.conf'

# Ruby
# alias irb='irb --readline -r irb/completion -rubygems'

# function cdgem {
#  cd /opt/local/lib/ruby/gems/1.8/gems/; cd `ls|grep $1|sort|tail -1`
# }

# Mysql

alias mysqlstart='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist'
alias mysqlstop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist'

# PostgreSql

alias pgstart='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist'
alias pgstop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist'

# Git
alias ga='git add'
alias gs='git status'
alias gci='git commit'
alias gb='git branch -a -v'
alias gd='git diff | subl'
alias gpl='git pull'
alias gps='git push'
alias gco='git checkout'

# gc      => git checkout master
# gc bugs => git checkout bugs
function gc {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}
export PS1=$(echo "$PS1" | sed 's/\\w/\\w\\[\\033[35m\\]$(parse_git_branch)\\[\\033[0m\\]/g')

# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
# http://gist.github.com/47547
# function parse_git_dirty {
#  git diff --quiet HEAD &>/dev/null
#  [[ $? == 1 ]] && echo "*"
# }
# function parse_git_branch {
#  local branch=$(__git_ps1 "%s")
#  [[ $branch ]] && echo "[$branch$(parse_git_dirty)]"
# }
# export PS1=$(echo "$PS1" | sed 's/\\w/\\w\\[\\033[35m\\]$(parse_git_branch)\\[\\033[0m\\]/g')

# Run brew etc
source /opt/boxen/env.sh

# git bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Rake

alias rt='rake -D'

# Open new terminal tab at same path
# <a href="http://gist.github.com/124422">http://gist.github.com/124422</a>
function nt {
  terminal_clone_command="
tell application \"Terminal\"
  tell application \"System Events\" to tell process \"Terminal\" to keystroke \"t\" using command down
  do script with command \"cd `pwd`; clear\" in  selected tab of the front window
end tell
"
  echo "$terminal_clone_command" | osascript &>/dev/null
}

function proxy(){
  hostname="$1"
  port="$2"

  if [[ -z "$hostname" ]]; then
    hostname="squid01.amc.org.au"
  fi

  if [[ -z "$port" ]]; then
    port="888"
  fi

  export http_proxy="http://$hostname:$port"
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy

  export HTTP_PROXY=$http_proxy
  export HTTPS_PROXY=$https_proxy
  export FTP_PROXY=$ftp_proxy

  # needed by brew
  export ALL_PROXY=$http_proxy

  echo -e "Proxy ON. Use 'unproxy' to clear the proxy settings."
}

function unproxy(){

  unset http_proxy
  unset https_proxy
  unset ftp_proxy

  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset FTP_PROXY

  unset ALL_PROXY

  echo -e "Proxy OFF."
}

# Increase the maxfiles number, required for Questions image bank features which uses a lot of temporary files
ulimit -n 512

# rvm-install added line:
if [[ -s /Users/eddie/.rvm/scripts/rvm ]] ; then source /Users/eddie/.rvm/scripts/rvm ; fi

##
# Your previous /Users/eddie/.bash_profile file was backed up as /Users/eddie/.bash_profile.macports-saved_2010-12-16_at_15:46:06
##

# MacPorts Installer addition on 2010-12-16_at_15:46:06: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

source ~/.git-completion.bash
