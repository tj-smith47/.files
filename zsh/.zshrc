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

## Powerlevel10k - needs to run after ^ ###
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
  tmux
  sudo
  golang
  gcloud
  python
  vscode
  kubectl
  gpg-agent
  ssh-agent
  zsh-autosuggestions
  zsh-kubectl-prompt
  zsh-navigation-tools
  zsh-syntax-highlighting
)

[[ -f ~/.zsh_envs ]] && source ~/.zsh_envs
[[ -f "${ZSH_FILE}" ]] && source $ZSH_FILE

## Editory Preferences ##
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

## ColorLS ##
which gem &>/dev/null && {
  [[ -d $(dirname $(gem which colorls)) ]] && source $(dirname $(gem which colorls))/tab_complete.sh
}

## Colima ##
source <(colima completion zsh 2>/dev/null) || true

## GPC Cluster Authentication ##
[[ -f "${GCLOUD_SDK_PATH}/path.zsh.inc" ]] && source "${GCLOUD_SDK_PATH}/path.zsh.inc"
[[ -f "${GCLOUD_SDK_PATH}/completion.zsh.inc" ]] && source "${GCLOUD_SDK_PATH}/completion.zsh.inc"

### GPG - Decrypt secret ENVs ###
[[ -f "${GPG_CREDS_FILE}" ]] && source <(gpg -dq --default-recipient-self ${GPG_CREDS_FILE})

## Kubectl Enable Shell Autocompletion ##
source <(kubectl completion zsh 2>/dev/null) || true

## Fuzzy-Find ##
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

[[ -f ~/fzf-git.sh/fzf-git.sh ]] && source ~/fzf-git.sh/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

## Go Task ##
eval "$(task --completion zsh)" &>/dev/null || true

## Mise ##
#eval "$(${HOME}/.local/bin/mise activate zsh)" || true

## The Fuck ##
eval $(thefuck --alias 2>/dev/null) || true

## Wezterm ##
source <(wezterm shell-completion --shell zsh) || true

## Zsh - Aliases ##
source ~/.zsh_aliases

## Zsh - Dracula ##
[[ -f "${ZSH_DIR}" ]] && source "${ZSH_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.sh"

## Zsh Auto-Suggestions ##
source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

## Zsh Syntax-Highlighting ##
source "$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


### Clean Path (ensure custom bash first) ###
PATH="$(brew --prefix bash)/bin:${PATH}"
DIRTY_PATH="${PATH}" # Save, pre-clean
PATH=$(
  # Dedupe paths
  tr ':' '\n' <<<"$PATH" | awk '!x[$0]++' |
    # Filter nonexistent paths
    while read -r dir; do test -d $dir && echo $dir; done |
      # Reformat PATH
      tr '\n' ':' | sed 's/:$//' | xargs
)
[[ -n "${PATH}" ]] && export PATH || export DIRTY_PATH
