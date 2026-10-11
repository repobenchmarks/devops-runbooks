# Production fzf Configuration with fd, bat & Git shortcuts
# Published by RepoBenchmarks (repobenchmarks.com)

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git --exclude node_modules --exclude .venv'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'

export FZF_DEFAULT_OPTS="\
  --height 50% \
  --layout=reverse \
  --border rounded \
  --margin 1,2 \
  --padding 0 \
  --info=inline \
  --marker='>' \
  --pointer='>' \
  --prompt='> ' \
  --bind 'ctrl-/:toggle-preview'"

export FZF_CTRL_T_OPTS="\
  --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --preview-window right:60%:wrap"

export FZF_ALT_C_OPTS="\
  --preview 'eza --tree --level=2 --color=always {} || tree -C -L 2 {}' \
  --preview-window right:50%"

# Interactive Ripgrep Search (rgi)
rgi() {
  INITIAL_QUERY="${*:-}"
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window 'right,60%,border-bottom,+{2}+3/3,~3' \
      --bind "enter:become(${EDITOR:-nvim} {1} +{2})"
}

# Fuzzy Git Branch Switcher (fbr)
fbr() {
  local branch
  branch=$(git branch --all --color=always | \
    grep -v '/HEAD\s' | \
    fzf --ansi --preview 'git log -n 20 --color=always --oneline --graph $(echo {} | tr -d "* " | sed "s#remotes/[^/]*/##")' \
        --preview-window right:60% | \
    tr -d '* ' | sed 's#remotes/[^/]*/##')
  
  if [ -n "$branch" ]; then
    git checkout "$branch"
  fi
}
