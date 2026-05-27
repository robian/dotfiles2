local identity_color="$fg_bold[green]"

if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
  identity_color="$fg_bold[red]"
fi

local identity_segment="%{${identity_color}%}%n@%m%{$reset_color%} "

PROMPT="${identity_segment}%{$fg[cyan]%}%~%{$reset_color%} "
PROMPT+='$(git_prompt_info)'
PROMPT+=$'\n%(?:%{$fg_bold[green]%}%1{➜%}%{$reset_color%} :%{$fg_bold[red]%}%1{➜%}%{$reset_color%} )'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})%{$reset_color%}"
