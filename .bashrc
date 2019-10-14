export PATH="~/bin:$PATH"

####################
###    ALIAS     ###
####################

### Utils ###
# Convenience
alias ls='ls -GFh'
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
alias venv='source venv/bin/activate'

# Protection
alias mv='mv -i'
alias cp='cp -i'


### Python ###
alias py39='/usr/local/bin/python3.9'
alias py38='/usr/local/bin/python3.8'
alias py37='/usr/local/bin/python3.7'
alias py=py38
alias pyvinit='pip install black mypy flake8 pydocstyle flake8-docstrings'

####################
###  PS1 Config  ###
####################

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
    PS1=""
    if [ "$VIRTUAL_ENV" != "" ]; then
        PS1="($(basename "$VIRTUAL_ENV")) "
    fi
    PS1+="\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\W\[\e[31m\]"
    PS1+="\`parse_git_branch\`"

    if [ $? != 0 ]; then
        PS1+="\[\e[31m\]" # Add red if exit code non 0
    else
        PS1+="\[\e[m\]"
    fi

    PS1+="\n${return_code}$ \[\e[m\]"
    update_terminal_cwd
}

PROMPT_COMMAND=__prompt_command
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

