export PIP_REQUIRE_VIRTUALENV=true
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=~/bin:$PATH
export CPATH=`xcrun --show-sdk-path`/usr/include
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/go

####################
###    ALIAS     ###
####################

### Utils ###
# Convenience
alias ls='ls -GFh'
alias l=ls
alias ll='ls -la'
alias mkdir='mkdir -pv'
alias c='clear'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Protection
alias mv='mv -i'
alias cp='cp -i'

### Python ###
alias py=python3.8
alias venv='source .venv/bin/activate'
alias cvenv='py -m venv .venv && venv'
alias pyvinit='pip install black mypy flake8 pydocstyle flake8-docstrings pytest'

####################
###  PS1 Config  ###
####################

# COPIED from /etc/bashrc_Apple_Terminal
update_terminal_cwd() {
	# Identify the directory using a "file:" scheme URL, including
	# the host name to disambiguate local vs. remote paths.
	
	# Percent-encode the pathname.
	local url_path=''
	{
	    # Use LC_CTYPE=C to process text byte-by-byte. Ensure that
	    # LC_ALL isn't set, so it doesn't interfere.
	    local i ch hexch LC_CTYPE=C LC_ALL=
	    for ((i = 0; i < ${#PWD}; ++i)); do
		ch="${PWD:i:1}"
		if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
		    url_path+="$ch"
		else
		    printf -v hexch "%02X" "'$ch"
		    # printf treats values greater than 127 as
		    # negative and pads with "FF", so truncate.
		    url_path+="%${hexch: -2:2}"
		fi
	    done
	}
	
	printf '\e]7;%s\a' "file://$HOSTNAME$url_path"
    }

# get current branch in git repo
function parse_git_branch {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo " [${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function __prompt_command {
    local EXIT="$?" # store current exit code

    PS1=""
    if [ "$VIRTUAL_ENV" != "" ]; then
        PS1="($(basename "$VIRTUAL_ENV")) "
    fi
    PS1+="\[\e[35m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\[\e[33m\]\W\[\e[31m\]"
    PS1+="\`parse_git_branch\`\n"

    if [[ $EXIT -eq 0 ]]; then
        PS1+="\[\e[32m\]$"
    else
        PS1+="\[\e[36m\]?${EXIT}" # Add red if exit code non 0
    fi

    PS1+=" \[\e[m\]"
	update_terminal_cwd
}

PROMPT_COMMAND=__prompt_command
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad


# added by travis gem
[ -f /Users/math/.travis/travis.sh ] && source /Users/math/.travis/travis.sh
