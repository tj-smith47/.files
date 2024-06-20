# Fig pre block. Keep at the top of this file.
# ### Load Zsh Envs, Aliases, & Secrets ###
### Customizations ###
## Settings ##
setopt autocd
setopt histignorealldups
autoload -Uz compinit && compinit -C
autoload -U edit-command-line
zstyle ':completion:*' menu select
# bindkey -e

# Enable Powerlevel9k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------------------------------------------------------------- #

### PLUGINS ###
## Oh-My-Zsh ##
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  z
  gh
  git
  brew
  ruby
  sudo
  asdf
  golang
  gcloud
  python
  vscode
  kubectl
  gpg-agent
  ssh-agent
)

[[ -f ~/.zsh_envs ]] && source ~/.zsh_envs
source $ZSH_FILE

## Editory Preferences ##
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

## ColorLS ##
source $(dirname $(gem which colorls))/tab_complete.sh

# Powerlevel10k || Customize via `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
