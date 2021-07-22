#!/bin/bash
#
#  Install development environments
#
SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$SRC_DIR/colors.sh"
source "$SRC_DIR/env.sh"

echo -e "
${yellow}
 _______________________________
|                               |
|     Cackharot's dotfiles      |
|_______________________________|
"

echo -e "${yellow}!!! ${red}WARNING${yellow} !!!"
echo -e "${light_red}This script will delete/overwrite all your configuration files!"
echo -e "${light_red}Use it at your own risks."

if [ $# -ne 1 ] || [ "$1" != "-y" ];
    then
        echo -e "${light_red}Press ^c to quit...\n"
        echo -e "${yellow}Press Enter key to continue...\n"
        read key;
fi

#source ./install_functions.sh

function is_installed() {
    command -v "$1" >/dev/null
}

function install_brew() {
    /bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    brew tap homebrew/cask-fonts
}

function install_vim_plug() {
    NVIM_CONFIG="$HOME/.config/nvim/init.vim"
    [ -f "$NVIM_CONFIG" ] && echo -e "${yellow}# NeoVim config [$NVIM_CONFIG] present skipping install!${default}" && return
    echo -e "${blue}Installing NeoVim plugins..${default}"
    /bin/bash -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    mkdir -p "$HOME/.config/nvim" "$HOME/.config/nvim/plugged"
    ln -sf "$SRC_DIR/nvim/init.vim" "$NVIM_CONFIG"
    ln -sf "$SRC_DIR/nvim/plugged" "$HOME/.config/nvim/plugged"
    echo -e "${blue}NeoVim vim-plug installed.${default}"
}

function install_tmux_tpm() {
    [ -f ~/.tmux/plugins/tpm/tpm ] && echo -e "${yellow}tmux tpm already present skipping install!${default}" && return
    echo -e "${blue}Installing tmux tpm plugins..${default}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function install_doom_emacs() {
    [ -f ~/.emacs.d/bin/doom ] && echo -e "${yellow}doom emacs already present skipping install!${default}" && return
    echo -e "${blue}Installing doom emacs..${default}"
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom --yes install
    mkdir -p ~/.doom.d
    echo -e "${blue}Linking doom emacs config files..${default}"
    for fn in init.el config.el packages.el
    do
        echo -e "Linking emcas/$fn"
        ln -sf "$SRC_DIR/emacs/$fn" "$HOME/.doom.d/$fn"
    done
    ~/.emacs.d/bin/doom sync
}

function install_tools_via_brew() {
    [ ! -f "brew-bottles.txt" ] && echo -e "${yellow}# brew-bottles.txt file required!" && return
    xargs brew install -q < brew-bottles.txt
}

function link_dotfiles() {
    echo -e "${blue}Linking dotfiles to your home directory [$HOME]...${default}"
    for fn in .zshrc .tmux.conf .tmux.remote.conf .alacritty.yml .gitconfig
    do
        echo -e "Linking $fn"
        ln -sf "$SRC_DIR/$fn" "$HOME/$fn"
    done
    echo -e "${blue}Linking done.${default}"
}

function install_local_pbcopy() {
    echo -e "${blue}pbcopy seutp with launchctl '$SRC_DIR/local.pbcopy.plist'...${default}"
    [ ! -f "$SRC_DIR/local.pbcopy.plist" ] && echo -e "${yellow} pbcopy launhctl file not found" && return
    launchctl unload local.pbcopy.plist
    launchctl load local.pbcopy.plist
    # to remove launchctl remove local.pbcopy.plist
    # Host remote-server*
    # RemoteForward 9997 localhost:9999
}

is_installed brew || install_brew
install_tools_via_brew
install_vim_plug
install_tmux_tpm
install_doom_emacs
install_local_pbcopy

link_dotfiles
