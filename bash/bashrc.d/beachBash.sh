
# Prompt Options
source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
prompt(){
    local git_status 
    git_status="$(__git_ps1 '(%s)')"
    
    local user
    user="\[\e[1;91m\]\u\[\e[0m\]"

    local cwd
    cwd="\[\e[1;94m\]\W\[\e[0m\]"

    if [[ -n "$git_status" ]]; then
        PS1="\n${git_status}\n ${user} ${cwd} 󱃅 "
    else
        PS1=" ${user} ${cwd} 󱃅 "
    fi
}
PROMPT_COMMAND=prompt

# Aliases
alias dd='cd'
alias ll='ls -Al'
alias gs='git status'
alias ls='ls --color=auto'
alias mv='mv -i'
alias py='python'

# Jump commands
bind -x '"\e.":cd ..; echo "Moved to: $PWD"'

fzd() {
    dir="$(find $HOME -type d 2>/dev/null | fzf)" || return
    [ -n  "$dir" ] || return
    cd "$dir" || return
}
bind -x '"\ej": fzd'

fzwd() {
    dir="$(find $PWD -type d 2>/dev/null | fzf)" || return
    [ -n  "$dir" ] || return
    cd "$dir" || return
}
bind -x '"\ep": fzwd'

fzn() {
    local dir
    dir="$(find $HOME -type d 2>/dev/null | fzf)" || return
    [ -n  "$dir" ] || return
    cd "$dir" || return
    nvim .
}
bind -x '"\en": fzn'

# FZF Bash History
bash_history() {
    cmd="$(cat $HOME/.bash_history 2>/dev/null | fzf)" || return
    [ -n  "$cmd" ] || return
    $cmd || return
}
bind -x '"\er": bash_history'

# # .bashrc
# # .bashrc file uncomment and stick in home directory
# # Source global definitions
# if [ -f /etc/bashrc ]; then
#     . /etc/bashrc
# fi
#
# # User specific environment
# if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
#     PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# fi
# export PATH
#
# # Uncomment the following line if you don't like systemctl's auto-paging feature:
# # export SYSTEMD_PAGER=
#
# # User specific aliases and functions
# if [ -d ~/.bashrc.d ]; then
#     for rc in ~/.bashrc.d/*; do
#         if [ -f "$rc" ]; then
#             . "$rc"
#         fi
#     done
# fi
# unset rc
#
# . "$HOME/.cargo/env"
