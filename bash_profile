alias g='git'
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'
alias gd='git diff'
alias gl='git log'
alias gclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
alias gpush='git push'
alias gpull='git pull'

alias rs='rails server'

alias ssha='eval `ssh-agent`; ssh-add'

alias ll="ls -lrt"

eval "$(rbenv init -)"


execute_in_all_subfolders() {
  find . -type d -maxdepth 1 -exec sh -c "cd \"{}\"/ && pwd && $@" \;
}
alias cdand=execute_in_all_subfolders



