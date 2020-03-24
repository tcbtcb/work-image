# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
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
alias tmux='tmux -2'

# gcloud aliases

alias gcil='gcloud compute instances list'
alias gcsp='gcloud config set project'
alias gcpl='gcloud projects list'
alias gad='gcloud app deploy'

# Go modules
export GO111MODULE=on

# PATH and tmux stuff
export PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export TERM=xterm
export LANG=en_US.UTF-8
export EDITOR=vim
alias tmux='tmux -2'

# GOPATH and powerline
GOPATH=/go

function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go -modules "venv,user,docker,ssh,cwd,git,jobs,exit,root"  -error $?)"
  }

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
      PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
