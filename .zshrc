DOTFILES=${DOTFILES:-$HOME/dotfiles}
export DOTFILES=$DOTFILES

# Path to your oh-my-zsh installation.
export ZSH="/Users/$LOGNAME/.oh-my-zsh"

#ZSH_THEME="avit"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Custom envs and aliases
[ -f $HOME/.env.sh ] && source $HOME/.env.sh
[ -f $HOME/.aliases.sh ] && source $HOME/.aliases.sh

if [ -z "$plugins" ]; then
  plugins=(git python autojump autoenv cp genpass tmux gitignore virtualenv brew osx)
fi

source $ZSH/oh-my-zsh.sh

if [ $(command -v "fzf") ]; then
    #source /usr/share/fzf/completion.zsh
    #source /usr/share/fzf/key-bindings.zsh
    source $DOTFILES/zsh/scripts_fzf.sh

    # Search with fzf and open selected file with Vim
    bindkey -s '^v' 'vim $(fzf);^M'
fi

# PROMPT
fpath=($DOTFILES/zsh/prompt $fpath)
autoload -Uz prompt_purification_setup; prompt_purification_setup

source $DOTFILES/env.sh
source $DOTFILES/aliases.sh
source $DOTFILES/zsh/scripts.sh
