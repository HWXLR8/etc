SD=$(dirname "$(readlink -f "$0")")

RED='\033[1;31m'
NC='\033[0m'

function log {
    echo -e "${RED}* ${1}${NC}"
}

function force_root {
    if [ "$EUID" -ne 0 ]
    then echo "please run as root"
	 exit
    fi
}

function append_xinit {
    sed -i "/^exec i3/c\\$1\nexec i3" ~/.xinitrc
}

function check_param {
    if [ -z ${1+x} ];
    then
	log "no argument supplied"
	exit
    fi
}
