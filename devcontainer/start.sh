#!/usr/bin/env bash

## Install packages
PACKAGES=""
if ! command -v gem &>/dev/null; then
    PACKAGES="ruby-dev"
fi

if ! command -v vim &>/dev/null; then
    PACKAGES="${PACKAGES} vim"
fi

if ! command -v curl &>/dev/null; then
    PACKAGES="${PACKAGES} curl"
fi

if ! command -v fuse &>/dev/null; then
    PACKAGES="${PACKAGES} fuse"
fi

if ! command -v make &>/dev/null; then
    PACKAGES="${PACKAGES} make"
fi

sudo apt-get update -qq
sudo apt-get install -y "${PACKAGES}"
sudo gem install colorls

## Prepare dotfiles dirs
[[ ! -d "${HOME}/.config" ]] && mkdir -p "${HOME}/.config"
[[ ! -d "${HOME}/.local/bin" ]] && mkdir -p "${HOME}/.local/bin"

[[ -f "${HOME}/.dotfiles/.zshrc" && ! -f "${HOME}/.dotfiles/.bashrc" ]] &&
    (sudo usermod --shell /usr/bin/zsh salesloft &&
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)

## Link configs
ln -sf "${HOME}/.dotfiles/nvim" "${HOME}/.config/nvim"
ln -sf "${HOME}/.dotfiles/colorls" "${HOME}/.config/colorls"
ln -sf "${HOME}/.dotfiles/kitty" "${HOME}/.config/kitty"
ln -sf "${HOME}/.dotfiles/dracula-pro.zsh-theme" "${HOME}/.oh-my-zsh/themes/dracula-pro.zsh-theme"
ln -sf "${HOME}/.dotfiles/.p10k.zsh" "${HOME}/.p10k.zsh"

## Determine and stage shell & RC file
if [ -f "${HOME}/.dotfiles/.bashrc" ]; then
    [[ -f "${HOME}/.dotfiles/aliases" ]] && ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.bash_aliases"
    [[ -f "${HOME}/.dotfiles/envs" ]] && ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.bash_envs"
    ln -sf "${HOME}/.dotfiles/.bashrc" "${HOME}/.bashrc"
fi

if [ -f "${HOME}/.dotfiles/.zshrc" ]; then
    [[ -f "${HOME}/.dotfiles/aliases" ]] && ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.zsh_aliases"
    [[ -f "${HOME}/.dotfiles/envs" ]] && ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.zsh_envs"
    ln -sf "${HOME}/.dotfiles/.zshrc" "${HOME}/.zshrc"
fi
