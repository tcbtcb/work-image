# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsh='ls -lhGFr'
alias lsa='ls -lhaGFr'
alias reload='source ~/.bashrc'

# git aliases
alias gm='git merge --no-ff --no-commit'
alias gmc='git ls-files --unmerged | cut -f2 | uniq' 
alias ga='git commit -a --amend --no-edit'
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit --verbose'
alias gca='git commit --all --verbose'
alias gd='git diff'
alias gco='git checkout'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpom='git push origin master'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grd='git rm $(git ls-files -d)'   
alias grq='git rebase --interactive --autosquash'
alias gs='git status -b -s --ignore-submodules=dirty'
alias gl='git log --pretty=format:"%C(yellow)%h%C(reset)|%C(bold blue)%an%C(reset)|%s" | column -s "|" -t | less -FXRS'
alias glp='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias tmux='tmux -2'
alias kc='kubectl'
alias tf='terraform'

# gcloud aliases
alias gcil='gcloud compute instances list'
alias gcsp='gcloud config set project'
alias gcpl='gcloud projects list'
alias gad='gcloud app deploy'

# dir aliass
alias cdf='cd /go/src/gitlab.com/flywheel-io'
alias cdi='cd /go/src/gitlab.com/flywheel-io/infrastructure'
alias cdc='cd /go/src/gitlab.com/flywheel-io/customers'
alias cdt='cd /go/src/github.com/tcbtcb'

# Go modules
export GO111MODULE=on

# PATH and tmux stuff
export PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local:/usr/share:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export TERM=xterm
export LANG=en_US.UTF-8
export EDITOR=vim
alias tmux='tmux -2'
source /home/thadbrown/google-cloud-sdk/path.bash.inc
source /home/thadbrown/google-cloud-sdk/completion.bash.inc

# gcp creds for terraform
if [ -h /home/thadbrown/.config/adc.json ]; then
  export GOOGLE_APPLICATION_CREDENTIALS="/home/thadbrown/.config/adc.json"
else
  ln -s /home/thadbrown/.config/gcloud/legacy_credentials/thadbrown\@flywheel.io/adc.json /home/thadbrown/.config/adc.json
  export GOOGLE_APPLICATION_CREDENTIALS="/home/thadbrown/.config/adc.json"
fi

# GOPATH and powerline
GOPATH=/go
export SHEBANG="%"

function _update_ps1() {
     PS1="$($GOPATH/bin/powerline-go --shell-var SHEBANG -modules "shell-var,venv,user,docker,cwd,git,exit,root" -cwd-mode dironly -error $?)"
  }

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
      PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# change highlight colors (temp workaround)
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
