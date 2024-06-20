#!/usr/bin/env bash

sudo apt-get update -qq
sudo apt-get install -qqy vim ruby-dev curl fuse make

sudo gem install colorls

#if [ -f "${HOME}/.dotfiles/nvim.appimage" ]; then
#    chmod u+x "${HOME}/.dotfiles/nvim.appimage"
#    mv "${HOME}/.dotfiles/nvim.appimage" /usr/local/bin/nvim
#fi

[[ ! -d "${HOME}/.local/bin" ]] && mkdir -p "${HOME}/.local/bin"
mv "${HOME}/.dotfiles/nvim" "${HOME}/.local/bin/nvim"

[[ -f "${HOME}/.dotfiles/.zshrc" && ! -f "${HOME}/.dotfiles/.bashrc" ]] &&
    (sudo usermod --shell /usr/bin/zsh salesloft &&
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)

if [ -f "${HOME}/.dotfiles/.bashrc" ]; then
    ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.bash_aliases"
    ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.bash_envs"
    ln -sf "${HOME}/.dotfiles/.bashrc" "${HOME}/.bashrc"
fi

[[ ! -d "${HOME}/.config" ]] && mkdir -p "${HOME}/.config/nvim"
ln -sf "${HOME}/.dotfiles/init.lua" "${HOME}/.config/nvim/init.lua"
ln -sf "${HOME}/.dotfiles/colorls" "${HOME}/.config/colorls"
ln -sf "${HOME}/.dotfiles/kitty" "${HOME}/.config/kitty"
ln -sf "${HOME}/.dotfiles/dracula-pro.zsh-theme" "${HOME}/.oh-my-zsh/themes/dracula-pro.zsh-theme"
ln -sf "${HOME}/.dotfiles/.p10k.zsh" "${HOME}/.p10k.zsh"

if [ -f "${HOME}/.dotfiles/.zshrc" ]; then
    ln -sf "${HOME}/.dotfiles/aliases" "${HOME}/.zsh_aliases"
    ln -sf "${HOME}/.dotfiles/envs" "${HOME}/.zsh_envs"
    ln -sf "${HOME}/.dotfiles/.zshrc" "${HOME}/.zshrc"
fi
