
# Prompt Options
export PS1='[\[\e[1;31m\]\u\[\e[0m\] \[\e[1;32m\]\W\[\e[0m\]]\$ '

# Aliases
alias dd='cd'
alias ll='ls -Al'
alias gs='git status'
alias ls='ls --color=auto'
alias mv='mv -i'

# Jump commands
bind -x '"\e.":cd ..; echo "Moved to: $PWD"'

fzd() {
    dir="$(find $HOME -type d 2>/dev/null | fzf)" || return
    [ -n  "$dir" ] || return
    cd "$dir" || return
}
bind -x '"\ej": fzd'

fzn() {
    local dir
    dir="$(find $HOME -type d 2>/dev/null | fzf)" || return
    [ -n  "$dir" ] || return
    cd "$dir" || return
    nvim .
}
bind -x '"\en": fzn'


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
