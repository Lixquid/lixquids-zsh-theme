## Lixquid's Theme
# A powerline-style theme

# TODO: Add Git Stashes
# TODO: Add IP
# TODO: Add OS Icon
# TODO: Add CPU / RAM load
# TODO: Add History number + commands

# TODO: Add color customization

## Customization ###############################################################

## Configures when to display in fallback mode. Possible values are:
# "on": Powerline style is always used
# "ssh-off": Fallback is used if $SSH_CLIENT is not null
# "off": Fallback style is always used
_PROMPT_DISPLAY_STRATEGY=${_PROMPT_DISPLAY_STRATEGY:-ssh-off}

## If enabled, powerline style arrows will be used as section terminators,
# and powerline symbols will be used. Possible values are:
# "on": Powerline font is enabled
# "off": Powerline font is disabled
_PROMPT_DISPLAY_FONT=${_PROMPT_DISPLAY_FONT:-on}

## Prompt Build Commands
# You can customize what segments appear where by adding/moving/removing
# _PROMPT_* commands between _PR_RET and _PROMPT_END_*.
# Note that $1 will be "2" if we're currently building Prompt2 (zshell is
# expecting more input).
_PROMPT_BUILD_LEFT() {
	_PR_RET=$?

	_PROMPT_RETURNCODE LEFT
	_PROMPT_SUPERUSER LEFT
	_PROMPT_JOBS LEFT
	_PROMPT_USER LEFT
	_PROMPT_FULLDIR LEFT
	_PROMPT_GIT_BRANCH LEFT

	_PROMPT_END_LEFT $1
}
_PROMPT_BUILD_RIGHT() {
	_PR_RET=$?

	[[ -n $1 ]] && _PROMPT_PROMPT2 RIGHT
	_PROMPT_GIT_ACTION RIGHT

	_PROMPT_END_RIGHT
}

## Variables ###################################################################

_PR_BG=''
_PR_RET='0'
_PR_LOCATION="$0:A"

if [[ $_PROMPT_DISPLAY_FONT = on ]]; then
	_PR_SYMBOL_LEFT='\ue0b0'
	_PR_SYMBOL_RIGHT='\ue0b2'
	_PR_SYMBOL_CHECKMARK='\u2718'
	_PR_SYMBOL_BOLT='\u26a1'
	_PR_SYMBOL_COG='\u2699'
	_PR_SYMBOL_BRANCH='\ue0a0'
	_PR_SYMBOL_DETACHED='\u27a6'
	_PR_SYMBOL_AHEAD='\u2b06'
	_PR_SYMBOL_BEHIND='\u2b07'
	_PR_SYMBOL_ST_UNTRACKED='\u2b29'
	_PR_SYMBOL_ST_UNSTAGED='\u2b21'
	_PR_SYMBOL_ST_STAGED='\u2b22'
else
	_PR_SYMBOL_LEFT=''
	_PR_SYMBOL_RIGHT=''
	_PR_SYMBOL_CHECKMARK='X'
	_PR_SYMBOL_BOLT='SU'
	_PR_SYMBOL_COG='BG'
	_PR_SYMBOL_BRANCH='BR:'
	_PR_SYMBOL_DETACHED='CO:'
	_PR_SYMBOL_AHEAD='^'
	_PR_SYMBOL_BEHIND='V'
	_PR_SYMBOL_ST_UNTRACKED='?'
	_PR_SYMBOL_ST_UNSTAGED='!'
	_PR_SYMBOL_ST_STAGED='+'
fi

## Util ########################################################################

_PR_COL() {
	local bg='' fg=''
	if [[ $1 == reset ]]; then
		bg='%k'
	elif [[ -n $1 ]]; then
		bg="%K{$1}"
	fi
	if [[ $2 == reset ]]; then
		fg='%f'
	elif [[ -n $2 ]]; then
		fg="%F{$2}"
	fi
	if [[ bg != '' && fg != '' ]]; then
		echo -n "%{$bg$fg%}"
	fi
}
_PROMPT_SEGMENT_LEFT() {
	if [[ -n $_PR_BG && $1 != $_PR_BG ]]; then
		echo -n " $(_PR_COL $1 $_PR_BG)$_PR_SYMBOL_LEFT$(_PR_COL '' $2) "
	else
		echo -n "$(_PR_COL $1 $2) "
	fi
	_PR_BG=$1
	echo -n $3
}
_PROMPT_END_LEFT() {
	if [[ -n $_PR_BG && -n $1 ]]; then
		echo -n " $(_PR_COL white $_PR_BG)$_PR_SYMBOL_LEFT"
		echo -n "$(_PR_COL reset white)$_PR_SYMBOL_LEFT"
	elif [[ -n $_PR_BG ]]; then
		echo -n " $(_PR_COL reset $_PR_BG)$_PR_SYMBOL_LEFT"
	fi
	echo -n "$(_PR_COL reset reset)"
	_PR_BG=''
}
_PROMPT_SEGMENT_RIGHT() {
	if [[ -n $_PR_BG && $1 != $_PR_BG ]]; then
		echo -n " $(_PR_COL $_PR_BG $1)$_PR_SYMBOL_RIGHT$(_PR_COL $1 $2) "
	elif [[ -z $_PR_BG ]]; then
		echo -n "$(_PR_COL '' $1)$_PR_SYMBOL_RIGHT$(_PR_COL $1 $2) "
	else
		echo -n "$(_PR_COL $1 $2) "
	fi
	_PR_BG=$1
	echo -n $3
}
_PROMPT_END_RIGHT() {
	echo -n " $(_PR_COL reset reset)"
	_PR_BG=''
}

## Modules #####################################################################

## FULLDIR
# Prints current directory in full
_PROMPT_FULLDIR() {
	_PROMPT_SEGMENT_$1 blue black '%~'
}

## RETURN CODE
# Prints an X if the last return code was non-zero
# Prints the numeric return code if return code was not one
_PROMPT_RETURNCODE() {
	if [[ $_PR_RET -ne 0 ]]; then
		_PROMPT_SEGMENT_$1 black red $_PR_SYMBOL_CHECKMARK

		if [[ $_PR_RET -ne 1 ]]; then
			_PROMPT_SEGMENT_$1 black red $_PR_RET
		fi
	fi
}

## SUPERUSER
# Prints a bolt symbol if the current user is root
_PROMPT_SUPERUSER() {
	if [[ $UID -eq 0 ]]; then
		_PROMPT_SEGMENT_$1 black yellow $_PR_SYMBOL_BOLT
	fi
}

## JOBS
# Prints a cog if there are background jobs
# Prints the number of background jobs if more than one is running
_PROMPT_JOBS() {
	local jobcount=$( jobs -l | wc -l )
	if [[ $jobcount -gt 0 ]]; then
		_PROMPT_SEGMENT_$1 black cyan $_PR_SYMBOL_COG

		if [[ $jobcount -gt 1 ]]; then
			_PROMPT_SEGMENT_$1 black cyan $jobcount
		fi
	fi
}

## USER
# Prints the username and hostname
# This won't be printed if DEFAULT_USER is equal to the current user
# The text will be yellow if the current user is root
_PROMPT_USER() {
	if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		local col=white
		[[ $UID -eq 0 ]] && col=yellow
		_PROMPT_SEGMENT_$1 black $col "$USER@%m"
	fi
}

## GIT_BRANCH
# Displays information if currently inside a git repository
# Shows branch name if on a branch
# Shows commit if HEAD is detached
# Displays green if repository is clean
# Displays yellow if repository is dirty (uncommitted work)
# Displays red if currently in a git action (bisect, merge, rebase)
# If the current branch has a remote, displays commits ahead / behind
# If there are unstaged tracked files, a hollow symbol is displayed
# If there are staged files, a filled symbol is displayed
_PROMPT_GIT_BRANCH() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local branch=$(git symbolic-ref HEAD 2>/dev/null)
		local repo_path=$(git rev-parse --git-dir 2>/dev/null)

		# Set colors
		local bg=green fg=black
		if [[ -e "$repo_path/BISECT_LOG" || \
			-e "$repo_path/MERGE_HEAD" || \
			-e "$repo_path/rebase" || \
			-e "$repo_path/rebase-apply" || \
			-e "$repo_path/rebase-merge" ]]; then

			bg=red
			fg=white
		elif [[ -n $(parse_git_dirty) ]]; then
			bg=yellow
		fi

		# Get branch name / commit hash
		local output
		if [[ -n $branch ]]; then
			output="$_PR_SYMBOL_BRANCH ${branch:t}"
		else
			output="$_PR_SYMBOL_DETACHED $(git rev-parse --short HEAD 2>/dev/null)"
		fi
		_PROMPT_SEGMENT_$1 $bg $fg "$output"

		# Get commits ahead / behind
		if [[ -n $branch ]]; then
			# Check this branch has a remote
			local range="$( git status -b --porcelain | head -n 1 | cut -c 4- | cut -d " " -f 1 )"
			if [[ -n $( echo "$range" | grep '\.\.\.' ) ]]; then
				local stat="$( git rev-list --left-right --count "$range" )"
				local ahead=$( echo $stat | cut -f 1 )
				local behind=$( echo $stat | cut -f 2 )
				if [[ $ahead -ne 0 ]]; then
					_PROMPT_SEGMENT_$1 $bg $fg "$_PR_SYMBOL_AHEAD$ahead"
				fi
				if [[ $behind -ne 0 ]]; then
					_PROMPT_SEGMENT_$1 $bg $fg "$_PR_SYMBOL_BEHIND$behind"
				fi
			fi
		fi

		# Get status of:
		# Staged, unstaged
		output=''
		if [[ $( git status --porcelain 2>/dev/null | grep "^[MADRC][ MD]" | wc -l ) -ne 0 ]]; then
			output="$_PR_SYMBOL_ST_STAGED"
		fi
		if [[ $( git status --porcelain 2>/dev/null | grep "^ [MD]" | wc -l ) -ne 0 ]]; then
			output="$output$_PR_SYMBOL_ST_UNSTAGED"
		fi
		[[ -n "$output" ]] && _PROMPT_SEGMENT_$1 $bg $fg "$output"

	fi
}

## GIT_ACTION
# If git is in the middle of an action (rebase, merge, bisect), displays
# the action.
_PROMPT_GIT_ACTION() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local repo_path=$(git rev-parse --git-dir 2>/dev/null)

		# Set colors
		if [[ -e "$repo_path/BISECT_LOG" ]]; then
			_PROMPT_SEGMENT_$1 red white BISECT
		fi
		if [[ -e "$repo_path/MERGE_HEAD" ]]; then
			_PROMPT_SEGMENT_$1 red white MERGE
		fi
		if [[ -e "$repo_path/rebase" || \
			-e "$repo_path/rebase-apply" || \
			-e "$repo_path/rebase-merge" ]]; then

			_PROMPT_SEGMENT_$1 red white REBASE
		fi

	fi
}

## PROMPT2
# Displays when zshell expects more input (open quote, etc.)
_PROMPT_PROMPT2() {
	_PROMPT_SEGMENT_$1 black white "%_"
}

## TIME
# Displays the current time
_PROMPT_TIME() {
	_PROMPT_SEGMENT_$1 black white "$(date +%T)"
}

## Commands ####################################################################

## PROMPT_FALLBACK
# If the Prompt fails to display (say, if using a terminal without a powerline
# font installed), this command will force the terminal into a bash-like
# display mode.
PROMPT_FALLBACK() {
	PS1="%n@%m:%~%(!.#.$) "
	PS2="%_> "
	RPS1=""
	RPS2=""
}

## PROMPT_FALLBACK_OFF
# This will set the Prompt to display as default.
PROMPT_FALLBACK_OFF() {
	PS1='$(_PROMPT_BUILD_LEFT) '
	PS2='$(_PROMPT_BUILD_LEFT 2)'
	RPS1='$(_PROMPT_BUILD_RIGHT)'
	RPS2='$(_PROMPT_BUILD_RIGHT 2)'
}

## PROMPT RELOAD
# Reloads the Theme
PROMPT_RELOAD() {
	source "$_PR_LOCATION"
}

## Startup #####################################################################

case "$_PROMPT_DISPLAY_STRATEGY" in
	(on)
		PROMPT_FALLBACK_OFF
		;;
	(ssh-off)
		if [[ -n $SSH_CLIENT ]]; then
			PROMPT_FALLBACK
		else
			PROMPT_FALLBACK_OFF
		fi
		;;
	(off)
		PROMPT_FALLBACK
		;;
esac
