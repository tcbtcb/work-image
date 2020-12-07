# Created by newuser for 5.8
eval "$(starship init zsh)"
source /root/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /root/.zsh/completion.zsh
source /root/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

# aliases
alias ls='ls -G'                              # colorize `ls` output
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
alias shtop='sudo htop'                       # run `htop` with root rights
alias grep='grep --color=auto'                # colorize `grep` output
alias less='less -R'

# git aliases

alias gm='git merge --no-ff --no-commit'
alias gmc='git ls-files --unmerged | cut -f2 | uniq' # git merge conflicts
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
alias grd='git rm $(git ls-files -d)'   # git remove deleted
alias grq='git rebase --interactive --autosquash'
alias gs='git status -b -s --ignore-submodules=dirty'
alias gl='git log --pretty=format:"%C(yellow)%h%C(reset)|%C(bold blue)%an%C(reset)|%s" | column -s "|" -t | less -FXRS'

# cli aliases

alias fwpip='python3 -m flywheel_cli.main'
alias fwexp='export FLYWHEEL_CLI_BETA=true'

# vim alias
alias dbash='docker run -it --rm -v ~/Work/gitlab.com:/go/src/gitlab-com -v ~/Work/github.com:/go/src/github-com -p 443:443 tcbfw/work-image:latest'
alias dfw="docker run -it --rm -v /Users/thadbrown/.bash_history:/root/.bash_history -v /Users/thadbrown:/mnt/thadbrown -v /Users/thadbrown/.config/lab.hcl:/root/.config/lab.hcl -v /Users/thadbrown/.ssh:/root/.ssh -v /Users/thadbrown/.aws:/home/thadbrown/.aws -v ~/Work/gitlab.com/flywheel-io:/go/src/gitlab.com/flywheel-io -v ~/Work/github.com/:/go/src/github -v /Users/thadbrown/.config/gcloud:/root/.config/gcloud gcr.io/tcb-web/work-image "
alias dtcb="docker run -it --rm -v /Users/thadbrown/.bash_history:/home/thadbrown/.bash_history -v /Users/thadbrown:/mnt/thadbrown -v /Users/thadbrown/.ssh:/home/thadbrown/.ssh -v ~/Work/github.com/tcbtcb:/go/src/github.com/tcbtcb -v /Users/thadbrown/.config/gcloud:/home/thadbrown/.config/gcloud gcr.io/tcb-web/work-image "

# gcloud aliases

alias gcil='gcloud compute instances list'
alias gcsp='gcloud config set project'
alias gcpl='gcloud projects list'
alias gssh='gcloud compute ssh'

# ssh alias for ops
alias ops='ssh -A thadbrown@ops.flywheel.io'
alias ips='ssh -A thadbrown@ipsec.flywheel.io'

# go env for app engine
export GOPATH="${HOME}/go"
export PATH="$PATH:/usr/local/go/bin:${GOPATH}/bin"

# HSTR configuration 
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# In ~/.zshrc
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILE=~/.zsh_history

setopt HIST_FIND_NO_DUPS
# following should be turned off, if sharing history via setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thadbrown/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/thadbrown/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thadbrown/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/thadbrown/google-cloud-sdk/completion.zsh.inc'; fi
