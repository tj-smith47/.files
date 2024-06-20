local ret_status="%(?:%{$fg_bold[yellow]%}➜ :%{$fg_bold[red]%}➜ )"

set_git_head () {
  GIT_TOP="$(git rev-parse --show-toplevel | rev | cut -d'/' -f 1 | rev)" &> /dev/null
  [[ -z "${GIT_TOP}" || "${GIT_TOP}" == "${(%):-%c}" ]] \
    && GIT_OR_NOT="%{$fg_bold[yellow]%}${(%):-%c}" || GIT_OR_NOT="%{$fg_bold[yellow]%}${GIT_TOP} %{$fg_bold[magenta]%}/> %{$fg_bold[blue]%}${(%):-%c}"
}

## Appearance ##
current_context() {
 CONTEXT="$(echo ${ZSH_KUBECTL_PROMPT} | cut -d'|' -f1 | xargs)"
 NAMESPACE="$(echo ${ZSH_KUBECTL_PROMPT} | cut -d'|' -f2 | xargs)"
 [[ "${CONTEXT}" == "${NAMESPACE}" ]] && K_PROMPT="%{$fg_bold[blue]%}${CONTEXT}"
 [[ "${CONTEXT}" != "${NAMESPACE}" ]] && K_PROMPT="%{$fg_bold[blue]%}${CONTEXT} %{$fg_bold[magenta]%}| %{$fg_bold[cyan]%}${NAMESPACE}"
}

typeset -a precmd_functions
precmd_functions+=(set_git_head)
precmd_functions+=(current_context)

PROMPT='%{$fg_bold[green]%}[%{$fg_bold[blue]%}%n%{$fg_bold[green]%}]%{$fg_bold[cyan]%}❮%{$fg_bold[magenta]%}| ${GIT_OR_NOT} $(git_prompt_info)%{$fg_bold[magenta]%}|%{$fg_bold[cyan]%}❯ %{$reset_color%}'
RPROMPT='%{$fg_bold[cyan]%}❮%{$fg_bold[magenta]%}| %{$fg_bold[yellow]%}%* %{$fg_bold[magenta]%}|%{$fg_bold[cyan]%}❯%{$fg_bold[green]%}[${K_PROMPT}%{$fg_bold[green]%}]%{$reset_color%}'
OLDPROMPT='%{$fg_bold[green]%}[%{$fg_bold[blue]%}$K_PROMPT%{$fg_bold[green]%}]%n%H:%M:%S%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg_bold[green]%}✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg_bold[yellow]%}✘ "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
