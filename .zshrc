# plugins
plugins=(tmux shrink-path)

# zsh tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=false
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="xterm"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="xterm-256-color"

# zsh autosuggest
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true

# case insensitive autocomplete
CASE_SENSITIVE="false"

# ssh connection
[[ -n "$SSH_CLIENT" ]] || DEFAULT_USER="$(whoami)"

# zsh
export ZSH_THEME="kphoen"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# enable prompt substitution
setopt prompt_subst

# exports
export PROMPT='%{$fg[blue]%}$(shrink_path -f)%{$fg[yellow]%} ❯ '
export EDITOR='vim'
export EVENT_NOKQUEUE=1

# aliasses
alias cr='crystal'
alias zz="$EDITOR ~/.zshrc"
alias zx="source ~/.zshrc"
alias vv="$EDITOR ~/.vimrc"
alias vip="vim +PluginInstall +qall"
alias vup="vim +PluginUpdate"
alias vcp="vim +PluginClean +qall"
alias tt="$EDITOR ~/.tmux.conf"
alias tr="tmux source-file ~/.tmux.conf"
alias v="$EDITOR ."
alias e="exa -a1"
alias et="exa --long --tree"
alias rv="source $HOME/.rvm/scripts/rvm"

if [[ $TERM == xterm ]]; then
  # set terminal to 256-color mode
  TERM=xterm-256color
fi

# keybindings
bindkey -v
bindkey '^e' autosuggest-accept

# sourcing
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/etc/profile.d/autojump.sh
source $HOME/.asdf/asdf.sh
source ~/.fzf.zsh

# remove duplicates from path
typeset -U PATH

# additional FZF exports
export FZF_TMUX=1
export FZF_TMUX_HEIGHT=20
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# vim-like CtrlP in zsh.
# - When dir, CD into it
# - When file, run "$EDITOR file"
fzf-open-file-or-dir() {
  local out=$(eval $FZF_DEFAULT_COMMAND | fzf-tmux -d $FZF_TMUX_HEIGHT --exit-0)

  if [ -f "$out" ]; then
    $EDITOR "$out" < /dev/tty
  elif [ -d "$out" ]; then
    cd "$out"
    zle reset-prompt
  fi
}

### ASDF functions
vmi() {
  local lang=${1}

  if [[ $lang ]]; then
    local versions=$(asdf list-all $lang | fzf -m)
    if [[ $versions ]]; then
      for version in $(echo $versions); do; asdf install $lang $version; done
    fi
  else
    echo 'Please supply installed asdf plugin'
    return 1
  fi
}

vmc() {
  local lang=${1}

  if [[ $lang ]]; then
    local versions=$(asdf list $lang | fzf -m)
    if [[ $versions ]]; then
      for version in $(echo $versions); do; asdf uninstall $lang $version; done
    fi
  else
    echo 'Please supply installed asdf plugin'
    return 1
  fi
}

### BREW FUNCTIONS

# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst); do; brew install $prog; done;
  fi
}

# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd); do; brew upgrade $prog; done;
  fi
}

# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst); do; brew uninstall $prog; done;
  fi
}

### GENERAL FUNCTIONS

# mnemonic: [F]ind [P]ath
fp() {
  echo $(echo $PATH | sed -e $'s/:/\\\n/g' | fzf)
}

# mnemonic: [K]ill [P]rocess
kp() {
  local pid
  pid=$(ps -ef | sed 1d | fzf-tmux -d $FZF_TMUX_HEIGHT -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# mnemonic: [K]ill [S]erver
ks() {
  local pid
  pid=$(lsof -Pwni tcp | sed 1d | fzf-tmux -d $FZF_TMUX_HEIGHT -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

zle     -N   fzf-open-file-or-dir
bindkey '^P' fzf-open-file-or-dir
