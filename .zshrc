# Options {{{
  setopt extended_glob
  setopt prompt_subst
  setopt auto_cd

  stty -ixon
# }}}

# Zplug {{{
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
  else
    source ~/.zplug/init.zsh
  fi

  zplug "zplug/zplug"

  zplug "lib/history",                       from:"oh-my-zsh"
  zplug "plugins/shrink-path",               from:"oh-my-zsh"
  zplug "plugins/autojump",                  from:"oh-my-zsh"
  zplug "zdharma/fast-syntax-highlighting"

  zplug "BurntSushi/ripgrep",                from:"gh-r", as:"command", use:"*darwin*", rename-to:"rg"
  zplug "junegunn/fzf-bin",                  from:"gh-r", as:"command", use:"*darwin*", rename-to:"fzf"
  zplug "asdf-vm/asdf",                      defer:2
  zplug "zsh-users/zsh-autosuggestions",     defer:2

  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      else
          echo
      fi
  fi

  zplug load
# }}}

# Exports {{{
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
  export FAST_HIGHLIGHT_STYLES[default]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
  export FAST_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
  export FAST_HIGHLIGHT_STYLES[alias]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[function]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[command]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'
  export FAST_HIGHLIGHT_STYLES[path]='fg=magenta,bold'
  export FAST_HIGHLIGHT_STYLES[path_pathseparator]=
  export FAST_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
  export FAST_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
  export FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan,bold'
  export FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan,bold'
  export FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,bold'
  export FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,bold'
  export FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow,bold'
  export FAST_HIGHLIGHT_STYLES[back-or-dollar-double-quoted-argument]='fg=cyan,bold'
  export FAST_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan,bold'
  export FAST_HIGHLIGHT_STYLES[assign]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[redirection]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[comment]='fg=black,bold'
  export FAST_HIGHLIGHT_STYLES[variable]='fg=white,bold'
  export FAST_HIGHLIGHT_STYLES[mathvar]='fg=blue,bold'
  export FAST_HIGHLIGHT_STYLES[mathnum]='fg=magenta,bold'
  export FAST_HIGHLIGHT_STYLES[matherr]='fg=red,bold'
  export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export LPS_DEFAULT_USERNAME="sidneyliebrand@gmail.com"
  export PROMPT='%{$fg_bold[blue]%}$(shrink_path -f)%{$fg_bold[yellow]%} on%{$fg_bold[green]%} $(git_prompt_info)%{$fg_bold[yellow]%} ❯ '
  export RPROMPT='%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})$(git_prompt_status)%{$reset_color%}'
  export EDITOR='vim'
  export EVENT_NOKQUEUE=1
  export PATH="$HOME/bin:$PATH"
  export VIM_DEV=0

  # every time we load .zshrc, ditch duplicate path entries
  typeset -U PATH
# }}}

# Sourcing {{{
  # source $HOME/.asdf/asdf.sh
  # source ~/.fzf.zsh
# }}}

# Colors {{{
  if [[ $TERM == xterm ]]
  then
    TERM=xterm-256color
  fi
# }}}

# Aliasses {{{
  # prefer nvim over vim when present
  if type nvim > /dev/null 2>&1; then
    alias vim='nvim'
  fi

  alias cr='crystal'
  alias ga="git add ."
  alias gc="git commit -m ${1}"
  alias gd="git diff"
  alias gdt="git difftool"
  alias gmt="git mergetool"
  alias gp="git push ${1} ${2}"
  alias gco="git checkout ${1} ${2}"
  alias gpl="git pull ${1} ${2}"
  alias grb="git rebase ${1} ${2}"
  alias gs="git status"
  alias la="ls -al"
  alias lf="ls -al | grep ${1}"
  alias ls="ls -Gl"
  #alias tt="$EDITOR ~/.tmux.conf"
  alias u="utils"
  alias v="vim ."
  alias vcp="vim +PlugClean +qall"
  alias vip="vim +PlugInstall +qall"
  alias vup="vim +PlugUpdate"
  alias vv="$EDITOR ~/.vimrc"
  alias zx="source ~/.zshrc"
  alias zz="$EDITOR ~/.zshrc"
# }}}

# Keybindings {{{
  bindkey '^l' autosuggest-accept

  # move cursor to end of line after history search completion
  autoload -U history-search-end

  # search history using already written command string
  zle -N history-beginning-search-backward-end history-search-end
  bindkey "^[[A" history-beginning-search-backward-end

  zle -N history-beginning-search-forward-end history-search-end
  bindkey "^[[B" history-beginning-search-forward-end
# }}}

# Commands {{{
  ### toggle vim in "dev" mode (see .vimrc: $VIM_DEV)
  # allows me to easily load plugins from local directory rather than ~/.vim/bundle
  vdm() {
    if [[ "$VIM_DEV" == "1" ]] then
      export VIM_DEV=0
    else
      export VIM_DEV=1
    fi

    echo "vdm: $VIM_DEV"
  }

  ### Caniuse
  # caniuse for quick access to global support list
  # also runs the `caniuse` command if installed
  cani() {
    local feat=$(ciu | sort -rn | eval "fzf ${FZF_DEFAULT_OPTS} --ansi --header='[caniuse:features]'" | sed -e 's/^.*%\ *//g' | sed -e 's/   .*//g')

    if which caniuse &> /dev/null; then
      if [[ $feat ]] then; caniuse $feat; fi
    fi
  }

  ### ASDF
  # install multiple languages at once, async
  # mnemonic [V]ersion [M]anager [I]nstall
  vmi() {
    local lang=${1}
    asdf plugin-list-all &>/dev/null 2>&1

    if [[ -z $lang ]]; then
      lang=$(asdf plugin-list-all | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:install]'")
    fi

    if [[ $lang ]]; then
      for lng in $(echo $lang); do
        if [[ -z $(asdf plugin-list | rg $lng) ]]; then
          asdf plugin-add $lng
        else
          asdf plugin-update $lng
        fi

        for version in $(asdf list-all $lng | sort -nrk1,1 | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:${lng}:install]'")
        do asdf install $lng $version
        done
      done
    fi
  }

  # uninstall multiple languages at once, async
  # mnemonic [V]ersion [M]anager [C]lean
  vmc() {
    local lang=${1}

    if [[ -z $lang ]]; then
      lang=$(asdf plugin-list | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:clean]'")
    fi

    if [[ $lang ]]; then
      for lng in $(echo $lang); do
        for version in $(asdf list $lng | sort -nrk1,1 | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:${lng}:clean]'")
        do asdf uninstall $lng $version
        done
      done
    fi
  }

  ### BREW FUNCTIONS

  # mnemonic [B]rew [I]nstall [P]lugin
  bip() {
    local inst=$(brew search | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:install]'")

    if [[ $inst ]]; then
      for prog in $(echo $inst)
      do brew install $prog
      done
    fi
  }

  # update multiple packages at once, async
  # mnemonic [B]rew [U]pdate [P]lugin
  bup() {
    local upd=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:update]'")

    if [[ $upd ]]; then
      for prog in $(echo $upd)
      do brew upgrade $prog
      done
    fi

    return 0
  }

  # uninstall multiple packages at once, async
  # mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
  bcp() {
    local uninst=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:clean]'")

    if [[ $uninst ]]; then
      for prog in $(echo $uninst)
      do brew uninstall $prog
      done
    fi

    return 0
  }

  ### LASTPASS
  lps() {
    local uname=$LPS_DEFAULT_USERNAME
    local loggedin=1

    if [[ $(lpass status | grep '^Not logged in') ]]; then
      loggedin=""

      if [[ -z $uname ]]; then
        echo -n "Lastpass username: "
        read uname
      fi

      if [[ -n $uname ]]; then
        lpass login --trust $uname > /dev/null 2>/dev/null
      fi
    fi

    if [ $? -eq 0 ]; then
      local selected=$(lpass ls -l | lpfmt | eval "fzf ${FZF_DEFAULT_OPTS} --ansi --header='[lastpass:copy]'" | cut -d ' ' -f 1)

      if [[ $selected ]]; then
        lpass show -cp $(echo $selected)
      fi
    fi
  }

  ### GENERAL FUNCTIONS

  # mnemonic: [F]ind [P]ath
  fp() {
    local loc=$(echo $PATH | sed -e $'s/:/\\\n/g' | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:path]'")

    if [[ -d $loc ]]; then
      echo "$(rg --files $loc | rev | cut -d"/" -f1 | rev)" | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:exe] => ${loc}' >/dev/null"
      fp
    fi
  }

  # mnemonic: [K]ill [P]rocess
  kp() {
    local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
      echo $pid | xargs kill -${1:-9}
      kp
    fi
  }

  # mnemonic: [K]ill [S]erver
  ks() {
    local pid=$(lsof -Pwni tcp | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:tcp]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
      echo $pid | xargs kill -${1:-9}
      ks
    fi
  }

  utils() {
    local helptxt="bcp    [brew:clean]
bip    [brew:install]
bup    [brew:update]
cani   [caniuse:features]
fp     [find:path]
kp     [kill:path]
ks     [kill:tcp]
lps    [lastpass:copy]
vmc    [asdf:clean]
vmi    [asdf:install]
cr     [alias]              crystal
ga     [alias]              git add .
gc     [alias]              git commit -m \${1}
gd     [alias]              git diff
gdt    [alias]              git difftool
gmt    [alias]              git mergetool
gp     [alias]              git push \${1} \${2}
gco    [alias]              git checkout \${1} \${2}
gpl    [alias]              git pull \${1} \${2}
grb    [alias]              git rebase \${1} \${2}
gs     [alias]              git status
la     [alias]              ls -al
lf     [alias]              ls -al | grep \${1}
ls     [alias]              ls -G
tt     [alias]              \$EDITOR ~/.tmux.conf
u      [alias]              utils
v      [alias]              \$EDITOR .
vcp    [alias]              vim +PluginClean +qall
vdm    [function]           Toggle \$VIM_DEV between 1 and 0
vip    [alias]              vim +PluginInstall +qall
vup    [alias]              vim +PluginUpdate
vv     [alias]              \$EDITOR ~/.vimrc
zx     [alias]              source ~/.zshrc
zz     [alias]              \$EDITOR ~/.zshrc"

    local cmd=$(echo $helptxt | eval "fzf ${FZF_DEFAULT_OPTS} --header='[utils:show]'" | awk '{print $1}')

    if [[ -n $cmd ]]; then
      eval ${cmd}
    fi
  }
# }}}

# Tmux {{{
#  if hash tmux &> /dev/null; then
#    case $- in *i*)
#      [ -z "$TMUX" ] && tmux new -A -s $(whoami)
#    esac
#  else
#  fi
# }}}
