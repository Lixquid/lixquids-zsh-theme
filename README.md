# Lixquid's Zsh Theme

![Lixquid's Zsh Theme](http://i.imgur.com/xIRxLHH.png)

A PowerLine style theme for Zshell.

## *Another* Powerline Theme? :(

Yes! ~~no wait come back~~

This is a powerful, customizable shell theme that I ended up remaking from
scratch after editing and smashing together about 5 other Powerline style
themes into a franken-theme.

## Features

- Customizability
	- Feel free to reorder or remove segment sections at will.
- Power
	- Features many different pluggable modules
	- Contains a fallback mode that can be set to automatically activate:
	  No more wonky looking shells on devices without a Powerline font!

## Requirements

All you need is a Powerline-enabled font. You can test this by copying this
into a terminal: `echo '\ue0b0 \u2718 \u26a1 \ue0a0 \ue0b2'`.

If you see a lovely assortment of symbols, great! You're good to go.

## Available modules

### Directory

Shows the current Directory.

![Directory](http://i.imgur.com/pvpwRqY.png)

### Return Code

- Displays a checkmark if the last return code was not zero.
- If the last return code was also not one, display the code.

![Return Code](http://i.imgur.com/lcTz6vt.png)

### Superuser Status

- Displays a bolt is the current user is root.

![Superuser](http://i.imgur.com/Dmm4Yy8.png)

### Background Jobs

- Displays a cog if there are background jobs.
- If there is more than one background job, display the number of jobs.

![Background Jobs](http://i.imgur.com/SEXfNNl.png)

### User and Hostname

- Displays the current user and Hostname.
- Nothing will be displayed if `$DEFAULT_USER` is set to the current user.
- This will always display if `$SSH_CLIENT` is not null.
- Displays in yellow if the current user is root.

![User nad Hostname](http://i.imgur.com/ijC6giO.png)

### Git Status

- Displays the current branch name if inside a git repo.
- Displays the commit hash if HEAD is detached.
- Displays the status of untracked / unstaged / staged files.
- Displays commits behind / ahead of remote if on a tracked branch.
- Contextual Background Color:
	- Green for a clean repo
	- Yellow for unclean (untracked / unstaged / staged files present)
	- Red for in the middle of a git action (bisect / merge / rebase)

![Git Status](http://i.imgur.com/A0w9S14.png)

### Prompt 2

- Displays when zshell is expecting more input.

![Prompt 2](http://i.imgur.com/mQaZat5.png)

## Commands

- `PROMPT_RELOAD`
	- Reloads the current Theme
- `PROMPT_FALLBACK`
	- Force the theme into a purely text-based mode.
- `PROMPT_FALLBACK_OFF`
	- Disables text-based mode.
