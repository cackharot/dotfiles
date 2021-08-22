DOTFILES=${DOTFILES:-$HOME/dotfiles}
export DOTFILES=$DOTFILES

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Custom envs and aliases
[ -f $HOME/.env.sh ] && source $HOME/.env.sh
[ -f $HOME/.aliases.sh ] && source $HOME/.aliases.sh

if [ ! -z "$ZSH_THEME_OVERRIDE" ]; then
  ZSH_THEME=${ZSH_THEME_OVERRIDE}
fi

if [ -z "$plugins" ]; then
  plugins=(git python autojump autoenv cp genpass tmux gitignore virtualenv brew osx)
else
  plugins=($plugins)
fi

source $ZSH/oh-my-zsh.sh

if [ $(command -v "fzf") ]; then
    #source /usr/share/fzf/completion.zsh
    #source /usr/share/fzf/key-bindings.zsh
    source $DOTFILES/zsh/scripts_fzf.sh

    # Search with fzf and open selected file with Vim
    bindkey -s '^v' 'vim $(fzf);^M'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
    export FZF_ALT_C_COMMAND='fd --type d . --hidden'
    export FZF_ALT_C_OPTS="--preview 'tree -C | head -50'"
fi

if [ -z "$ZSH_THEME_OVERRIDE" ]; then
    # PROMPT
    fpath=($DOTFILES/zsh/prompt $fpath)
    autoload -Uz prompt_purification_setup; prompt_purification_setup
fi

source $DOTFILES/env.sh
source $DOTFILES/aliases.sh
source $DOTFILES/zsh/scripts.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
