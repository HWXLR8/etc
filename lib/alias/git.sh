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
alias gl='git log'
alias gp='git push'
alias gpom='git push origin master'

source ~/src/etc/git/git-prompt.sh

# wipe the entire git history of a repo without removing .git
function git-wipe {
    set -x
    git checkout --orphan temp
    git add -A
    git commit -am "init"
    git branch -D master
    git branch -m master
    set +x
}

# update all repos in a directory of git repos
function update-repos {
    for d in */ ; do
        cd "$d"
        git pull --rebase origin master
        cd ..
    done
}

function hwxlr8 {
    git clone git@github.com:hwxlr8/$1 || \
    git clone https://github.com/hwxlr8/$1
}
