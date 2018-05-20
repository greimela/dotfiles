#!/usr/bin/env bash

export WORK="$HOME/code/alloy"
export GOPATH="$HOME/code/go"
export GOWORK="$GOPATH/src/github.com/alloytech/"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export CDPATH=".:$HOME:$HOME/code/j-martin:$WORK:$GOWORK:$GOPATH/src/github.com/j-martin/:$HOME/code/"
export VISUAL="emacsclient"
export GPG_TTY="$(tty)"

source "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

test -e "$TMPDIR/ssh-loaded" \
  || ssh-add -A && touch "$TMPDIR/ssh-loaded"

__encfs() {
  local root_dir="$1"
  local mount_point="$2"
  local mount_file="${mount_point}/.mounted"
  if [[ ! -f "${mount_file}" ]]; then
    echo "Mounting: ${mount_point}"
    encfs "${root_dir}" "${mount_point}" \
      && touch "${mount_file}" \
      || (echo 'Failed to mount encrypted volume... Retrying' && __encfs "$@")
  fi
}

__encfs "$HOME/Sync/Storage" "$HOME/.storage"
__encfs "$HOME/Library/.chrome" "$HOME/Library/Application Support/Google/Chrome"

test -f "$HOME/.private/.profile" && source "$HOME/.private/.profile"

source "$HOME/.functions/all"
source "$HOME/.aliases"

export PATH="$GOPATH/bin:/usr/local/sbin:$HOME/.npm/bin:/usr/local/bin:$HOME/.bin:/usr/bin:/bin:/usr/sbin:/sbin"

test -e /usr/libexec/java_home \
  && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

test -e /usr/local/bin/nvim \
  && export EDITOR='/usr/local/bin/nvim'

export PAGER='less -SRi'
export HOSTNAME="$HOST"

# export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.agignore  -l -g ""'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!*{.git,node_modules,build,out}/*" 2> /dev/null'
unset SSL_CERT_FILE

export SDKMAN_DIR="$HOME/.sdkman"
test -e "$HOME/.sdkman/bin/sdkman-init.sh" \
  && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi

if [ -n "$(pgrep gpg-agent)" ]; then
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon)
fi

# Work
export HBASE_CONF_DIR="/usr/local/var/hbase/conf"
export PYENV_ROOT="$HOME/.pyenv"
