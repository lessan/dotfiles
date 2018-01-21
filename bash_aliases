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
alias vi='vim'

alias rs='rails server'
alias be='bundle exec'

alias ssha='eval `ssh-agent`; ssh-add'

alias ll="ls -lrt"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


execute_in_all_subfolders() {
  find . -type d -maxdepth 1 -exec sh -c "cd \"{}\"/ && pwd && $@" \;
}
alias cdand=execute_in_all_subfolders


#export GOPATH=/usr/local/opt/go/libexec/bin
#export PATH=$GOPATH/bin:$PATH

#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# fasd initializer
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
alias c='fasd_cd -d'


#export $(ruby ~/hooroo/ted/export-aws-creds default)
export AWS_ENV_NAME=development-lessan

export PATH=~/.local/bin:$PATH
