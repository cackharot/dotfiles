export GO_PATH=$HOME/Projects/golang
export GOPATH=$HOME/Projects/golang
export GOBIN=$HOME/Projects/golang/bin
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$(go env GOPATH)/bin:$HOME/.emacs.d/bin:$GO_PATH/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$LOGNAME/.oh-my-zsh"

ZSH_THEME="avit"
# ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel9k/powerlevel9k"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(git python rust autojump cp genpass tmux gitignore virtualenv brew osx)

source $ZSH/oh-my-zsh.sh

# User configuration

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

_direnv_hook() {
  trap -- '' SIGINT;
  eval "$("/usr/local/bin/direnv" export zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z ${chpwd_functions[(r)_direnv_hook]} ]]; then
  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
fi

# Toggle HTTP/HTTPS proxy from cmd line
# pxy_on "Wi-Fi"
# pxy_on "Thunderbolt Ethernet"
function pxy_on {
	networksetup -setwebproxystate $1 on
	networksetup -setsecurewebproxystate $1 on
}

# Toggle HTTP/HTTPS proxy from cmd line
# pxy_off "Wi-Fi"
# pxy_off "Thunderbolt Ethernet"
function pxy_off {
	networksetup -setwebproxystate $1 off
	networksetup -setsecurewebproxystate $1 off
}

# aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias vi="nvim"

alias gws="git status --long --show-stash"
alias gia="git add"
alias gs="git status --short"
alias gwd="git diff"
alias gwdc="git diff --cached"
alias gcm="git commit -m"
alias gc="git commit"
alias gfr="git pull --rebase"
alias gp="git push"
alias gbl="git branch -l"
