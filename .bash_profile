# Newton Ni

# Initial setup
PATH="$HOME/bin:$HOME/local/bin:$HOME/.local/bin:$PATH:/usr/local/bin"

export RANGER_LOAD_DEFAULT_RC="FALSE"

# C
export PATH="$PATH:/usr/local/lib/cquery/bin"
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"

# Go
export PATH="$PATH:/usr/lib/go-1.9/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nwtnni/.google/google-cloud-sdk/path.bash.inc' ]; then source '/home/nwtnni/.google/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nwtnni/.google/google-cloud-sdk/completion.bash.inc' ]; then source '/home/nwtnni/.google/google-cloud-sdk/completion.bash.inc'; fi

# JS
export NPM_PACKAGES="/home/nwtnni/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Haskell
export PATH="$PATH:$HOME/.cabal/bin:/opt/cabal/2.0/bin:/opt/ghc/8.2.2/bin"

# Python
export PATH="$HOME/.pyenv/bin:$PATH"

# P4
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export LD_LIBRARY_PATH="$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH"

# Ruby
export PATH="$PATH:$HOME/.rvm/bin"

# Color
export TERM="xterm-256color-italic"

export EDITOR="nvim"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore-vcs"
export FZF_ALT_C_COMMAND="fd --type d --hidden --no-ignore-vcs"
export FZF_TMUX=1

# https://github.com/junegunn/fzf/wiki/Examples#opening-files
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

o () {
  cd "$1" && ls --group-directories-first --color=auto
}

setc () {
  printf "\x1b[38;2;%s;%s;%sm" "$1" "$2" "$3"
}

clear () {
  printf "\x1b[0m"
}

branch () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [[ -z $(git status --porcelain) ]]; then
      # Blue for git branch
      setc 131 165 152
    else
      # Orange for dirty
      setc 254 128 25
    fi
  else
    # White for no version control
    setc 235 219 178
  fi
}


last () {
  if [[ "$?" -eq 0 ]]; then
    # Green for good
    setc 152 151 26
  else
    # Red for bad
    setc 251 73 52
  fi
}

export PS1='\[$(last)\]λ \[$(clear)$(branch)\]→ \[$(clear)\]'

export PS2='>>>> '

# If running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
    fi
	if [ -f "$HOME/.bash_aliases" ]; then
		. "$HOME/.bash_aliases"
	fi
fi
