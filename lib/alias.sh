# shell
alias c='clear'
alias ..='cd ..'
alias t='ls --color=auto --sort=extension --group-directories-first -lh'
alias chx='chmod +x'
alias rf='rm -rfv'

# apps
alias em='emacs -nw --eval="(mu4e)"'
alias lb='lsblk'
alias v='alsamixer'
alias l='slock'
alias f='feh -FZ --force-aliasing'
alias m='mpv'
alias g='grep -r -i'
alias p='python'

# git
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gss='git status .'
alias gaa='git add .'
alias gdd='git diff .'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gco='git checkout'
alias gf='git fetch'
alias gb='git branch'
alias gl='git log --oneline'
alias gls='git log --oneline --stat'
alias glss='git log --oneline --shortstat'
alias gp='git push'
alias gpom='git push origin master'
alias gcl='git clone'

source ~/src/etc/git/git-prompt.sh

# youtube
alias yta='yt-dlp -f bestaudio'
alias ytls='yt-dlp -F'
alias ytd='yt-dlp -f'

# docker
alias drm_all='docker rm -vf $(docker ps -a -q) && docker rmi -f $(docker images -a -q)'
alias ds='docker stop $(docker ps -q)'
alias dc='docker container'
alias di='docker image'
alias dv='docker volume'
alias dls='docker ps'

# alsa
alias soundtest='speaker-test -t wav -c 2'
alias lssnd='cat /sys/class/sound/card*/id'

# misc
alias cpufreq='watch -n 0.25 "cat /proc/cpuinfo | grep MHz"'
alias j="emacs -nw $(date +'%b-%d-%Y')"
alias myip='curl http://ifconfig.me'
