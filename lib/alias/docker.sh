# docker
alias drm_all='docker rm -vf $(docker ps -a -q) && docker rmi -f $(docker images -a -q)'
alias dc='docker container'
alias di='docker image'
alias dv='docker volume'
