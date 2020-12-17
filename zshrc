# env for starship prompt
export STARSHIP="root "

eval "$(starship init zsh)"

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# manually set vim as editor
export EDITOR='vim'

# HSTR configuration 
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
# In ~/.zshrc
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILE=~/.zsh_history

setopt HIST_FIND_NO_DUPS

# Load aliases and shortcuts if existent.
#[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
# [ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# aliases
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
alias gba='git branch -a'
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
alias gcm='git checkout master && git pull'

# misc aliases
alias tmux='tmux -2 -u'
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

# ssh aliases
alias rpenn='gcloud compute ssh upenn-production-gitlab-runner --project upenn-flywheel --zone=us-east1-b'
alias rfin='gcloud compute ssh finance --zone southamerica-east2-a --project tcb-financeb5477b6c'

# docker aliases
alias mini-hugo='docker run --rm -p 1313:1313 -v $PWD:/mnt/site gcr.io/tcb-web/mini-hugo'

# set path and source completion for gcloud
export PATH=$PATH:/opt/gcloud/google-cloud-sdk/bin
source /opt/gcloud/google-cloud-sdk/completion.zsh.inc

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
