# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[1;33m\]\u@\h \w ->\n\[\e[1;31m\] ➤➤➤➤ ▶\[\e[m\] '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### OWN ALIAS ###

#Pastes
alias pb='curl -F c=@- https://ptpb.pw/?u=1'
alias ix="curl -F 'f:1=<-' ix.io"

#Neofetch
alias neofetch='neofetch --cpu_cores logical --cpu_temp'

#Temperature
alias clima='curl wttr.in/bucaramanga?lang=es'

# Youtube to MP3 and MP4
alias ytmp3="youtube-dl --output '~/Music/Downloaded/%(title)s.%(ext)s' --extract-audio --audio-format mp3"
alias ytmp4="youtube-dl --output '~/Videos/Downloaded/%(title)s.%(ext)s' -f 'mp4'"

# Check permisions
alias pcheck='stat -c "%A %a %n"'

#Journalctl logs
alias jlogs='journalctl -b -p 4..1'

# Version for Git packages
alias gitver='echo $(git rev-list --count HEAD).$(git rev-parse --short HEAD)'

# Version for Git packages with tags
alias gitag="git describe --long | sed 's/\([^-]*-g\)/r\1/;s/-/./g'"

# Alias to get sha512sums
alias ssums='sha512sum'

# Print SRCINFO in AUR packages
alias srcinfo='makepkg --printsrcinfo > .SRCINFO'

# See the amount of memory and CPU used by applications
alias cmcheck='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem|head'

# Alias for git pull --rebase to prevent merging branchs
alias gpr='git pull --rebase'

# Alias for git clone
alias gclone='git clone'

# Alias for git push
alias gpush='git push'

# Alias to kill Signal Private Messenger when crashed
alias ksignal='killall -9 signal-desktop'

# Alias to see the actual CPU frequency
alias cpufreq='watch grep \"cpu MHz\" /proc/cpuinfo'

# Avoid pip installing packages as root/sudo, execute the following line in your terminal or just delete the # at the begin
#install -Dm644 /dev/stdin ~/.config/pip/pip.conf <<< $'[install]\nuser = yes\n'

### END OWN ALIAS ###

### SOME LOCAL VARIABLES ###

# Editor
export EDITOR="nvim"

#Ruby DIR
PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin:$HOME/.local/bin"

# Visual
export VISUAL="nvim"

### END OF SOME LOCAL VARIABBLES ###

#Autostart X at login
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec sx
fi
