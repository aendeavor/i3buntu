# ! BASHRC - CONFIGURATION FILE FOR YOUR BASH
# ! ~/.bashrc - executed by bash for non-login shells

# * Miscellaneous

# ? if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s autocd

stty -ixon

# ?  more friendly less for non-text input files (see lesspipe(1))
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ? colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ? add "alert" alias for long running commands (usage: sleep 10; alert)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# * Working directory display management

# ? set variable identifying chroot you work in
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ** uncomment for a colored prompt
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# ** setup of prompt variables with colors
if [ "$color_prompt" = yes ]; then
    # primary color (221) - gold
    # secondary color (78) - green
    # ternary color (75) - blue

    PS1='${debian_chroot:+($debian_chroot)}'

    PS1+='\[\e[38;5;221m\]'
    PS1+='[\u@\h]'

    PS1+='\[\e[38;5;75m\]'
    PS1+=' : '

    PS1+='\[\e[38;5;78m\]'
    PS1+='[ \w ]'

    PS1+='\[\e[38;5;75m\]'
    PS1+=' \$ '

    PS1+='\[\e[39m\]'

    PROMPT_DIRTRIM=4
else
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+='[\u@\h] : [ \w ] \$ '
fi
unset color_prompt force_color_prompt

# * aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# * enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# * possible vim setup
