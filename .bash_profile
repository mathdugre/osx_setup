if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


export PATH="$HOME/.poetry/bin:$PATH"
