RED='\033[0;31m'
NC='\033[0m'

function log {
    echo -e "${RED}${1}${NC}"
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