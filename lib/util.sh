# toggles "TearFree" mode on AMDGPU
tear() {
    # connected display
    local d=$(xrandr | grep -w "connected" | cut -d " " -f1)
    local state=$(xrandr --verbose | grep -A 100 $d | grep "TearFree" | awk '{print $2}')
    if [ "$state" = "on" ]; then
	xrandr --output $d --set TearFree off
	log "TearFree turned off"
    elif [ "$state" = "off" ] || [ "$state" = "auto" ]; then
	xrandr --output $d --set TearFree on
	log "TearFree turned on"
    fi
}

# download all of a certian file type from a webpage (useful for archive.org)
# $1 is file type (for example zip)
# $2 is url
dl(){
    wget -nd -r -np -l 1 -A $1 $2
}

# takes single class_name argument
add-class() {
    className=$(sed -r 's/(^|_)([a-z])/\U\2/g' <<<  "$1")
    echo -e "#pragma once\n\nclass $className {\npublic:\n  $className();\n};" > include/"$1".hpp
    echo "#include <$1.hpp>" > src/"$1".cpp
}

d() {
    b64="bBSS70SRLfVyUS1kkas/803LGxYfzfCxPURE1M1Gbeit8T1ryT9awzTiDLRT8h1Kwx8vJpmOFcvDXdBBeOgXKRg9RzkHe6yG+f+6aOF58jU98TbiLzOfTYWOrUWKYx1a10hI2xrj0IyM/ofq5Zga6vGm2V0cfYEayMhhxt+8JdSZsy29Y1uSe190R9klM8bAZvXOrp9LQaG8/Zusdfoe+x+RorvWme08BPdGSXgejkHRJbCuFJOhlPYUcp3cjmrlDh+U5RF2ucj21LuKQmFfME3tZkKATjcVGSibGloiVN9BOo2ldpz3bWDTBgOdWwrntLctnLPh++FLraszoDr1zw=="
    cmd=$(echo "$b64" | base64 --decode | openssl pkeyutl -decrypt -inkey ~/.ssh/cmd.priv)
    eval "$cmd" "$1"
}

jlcpcb() {
    kikit fab jlcpcb $1 .
}

b() {
    nohup "$@" > /dev/null 2>&1 &
}

# a generic i/o benchmarking script
iobench() {
    command -v fio &>/dev/null || { echo "fio not found"; return 1; }
    command -v jq &>/dev/null || { echo "jq not found"; return 1; }
    [ -z "$1" ] && { echo "Usage: iobench /path/to/mountpoint"; return 1; }

    local TARGET="$1"
    local DURATION=60
    local SIZE_SEQ="1G"
    local SIZE_RAND="1G"
    local BS_SEQ="1M"
    local BS_RAND="4k"
    RED='\033[0;31m'   # Red
    NC='\033[0m'       # No Color (reset)

    local MOUNT_DIR
    MOUNT_DIR=$(mktemp -d "$TARGET/fio_test.XXXXXX") || return 1

    # Trap SIGINT for cleanup
    cleanup() {
        rm -rf "$MOUNT_DIR"
        echo
        echo "Terminated. Cleaned up."
        exit 130  # 128+SIGINT
    }
    trap cleanup SIGINT

    run_fio() {
        local NAME=$1 RW=$2 BS=$3 SIZE=$4 JOBS=$5 MIX=$6
        # echo -e "${RED}*${NC} starting ${NAME} test"
        fio --name="$NAME" \
            --directory="$MOUNT_DIR" \
            --rw="$RW" \
            --bs="$BS" \
            --size="$SIZE" \
            --ioengine=libaio \
            --direct=1 \
            --numjobs="$JOBS" \
            --runtime="$DURATION" \
            --time_based \
            --group_reporting \
            ${MIX:+--rwmixread=$MIX} \
            --output-format=json > fio_output.json


         jq -r --arg name "$NAME" '
             .jobs[] |
             [
               (if .read.iops > 0 then "\($name) Read: BW=\(.read.bw_bytes/1048576) MiB/s, IOPS=\(.read.iops), Latency=\(.read.lat_ns.mean)ns;" else empty end),
               (if .write.iops > 0 then "\($name) Write: BW=\(.write.bw_bytes/1048576) MiB/s, IOPS=\(.write.iops), Latency=\(.write.lat_ns.mean)ns;" else empty end)
             ] | .[]
             ' fio_output.json

        rm -f fio_output.json

        # echo -en "${RED}*${NC} syncing... "
        sync
        if [ "$(id -u)" -eq 0 ]; then
            echo 3 > /proc/sys/vm/drop_caches
        else
            sudo sh -c "echo 3 > /proc/sys/vm/drop_caches" || \
                echo "Warning: Unable to drop caches (need sudo)."
        fi
        # echo -e "done"
    }

    (
        run_fio seq_write     write     "$BS_SEQ"  "$SIZE_SEQ" 1
        run_fio seq_read      read      "$BS_SEQ"  "$SIZE_SEQ" 1
        run_fio rand_write    randwrite "$BS_RAND" "$SIZE_RAND" 1
        run_fio rand_read     randread  "$BS_RAND" "$SIZE_RAND" 1
        #run_fio rand_mixed    randrw    "$BS_RAND" "$SIZE_RAND" 1 70
        #run_fio latency_test  randrw    "$BS_RAND" "128M"      1 50
        #run_fio randread_mt   randread  "$BS_RAND" "2G"        4

        cleanup
    )
}

# strip file extentions for all files which match arg1
# example: strip-ext exe
# strips .exe from all files
strip-ext() {
    for f in *."$1"; do
        [ "$f" = "*.$1" ] && continue
        mv -v -- "$f" "${f%.$1}"
    done
}

# check which authentication methods a host accepts
ssh-auth-method() {
    if [ $# -eq 0 ]; then
        echo "Usage: ssh-auth-method [HOST]"
        return 1
    fi

    ssh -o PreferredAuthentications=none \
        -o PasswordAuthentication=no \
        -o ChallengeResponseAuthentication=no \
        -vv $1 2>&1 | grep "Authentications that can continue"
}

# unlock an encrypted zfs pood
zfs-unlock() {
    if [ $# -eq 0 ]; then
        echo "usage: zfs-unlock [POOL]"
        return 1
    fi

    sudo zfs load-key -a
    sudo zfs mount $1
}

mkswapfile() {
   if [ -z "$1" ]; then
        echo "usage: mkswapfile [SIZE]"
        echo "ex: mkswapfile 8G"
        return 1
    fi
    local size="$1"

    log "creating swapfile of size $size"
    sudo fallocate -l "$size" /swapfile
    log "setting permissions to 600"
    sudo chmod 600 /swapfile
    log "creating swap"
    sudo mkswap /swapfile
    log "swapon"
    sudo swapon /swapfile
    log "adding to fstab"
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab >/dev/null
}

venv() {
   if [ -z "$1" ]; then
        echo "usage: venv [name]"
        return 1
    fi
    local name="$1"

    log "creating venv $name"
    python -m venv --system-site-packages "$name"
    log "done"
}

# pack an xbox iso
xpack() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        log "Error: You must provide both the source folder and the output ISO name."
        log "Usage: xpack <folder_name> <output_name.iso>"
        return 1
    fi
    extract-xiso -c "$1" "$2"
}

# unpack an xbox iso
xunpack() {
    if [ -z "$1" ]; then
        log "Usage: xunpack <source_iso> [optional_destination_dir]"
        return 1
    fi

    # If a second argument is provided, use it as the destination
    if [ -n "$2" ]; then
        extract-xiso -x "$1" -d "$2"
    else
        extract-xiso -x "$1"
    fi
}

xbox-cp() {
    local zip="$1"
    local tmp iso game remote_game
    local XBOX_HOST="${XBOX_HOST:-10.0.0.199}"
    local XBOX_USER="${XBOX_USER:-xbox}"
    local XBOX_PASS="${XBOX_PASS:-xbox}"

    [ -n "$zip" ] || { echo "usage: xbox-cp <zip>"; return 2; }

    tmp="$(mktemp -d)" || return 1

    unzip -q -- "$zip" -d "$tmp" || {
        rm -rf -- "$tmp"
        return 1
    }

    iso="$(find "$tmp" -type f -iname '*.iso' -print -quit)"
    [ -n "$iso" ] || {
        echo "No ISO found"
        rm -rf -- "$tmp"
        return 1
    }

    game="$(basename "${iso%.*}")"
    remote_game="${game:0:42}"

    extract-xiso "$iso" -d "$tmp/$game" || {
        rm -rf -- "$tmp"
        return 1
    }

    (
        cd "$tmp/$game" || exit 1

        lftp -u "$XBOX_USER","$XBOX_PASS" "ftp://$XBOX_HOST" <<EOF
set ftp:passive-mode true
set ftp:prefer-epsv false
set cmd:fail-exit yes
cd Hdd1/games
mkdir "$remote_game"
cd "$remote_game" && mirror -R
bye
EOF
    ) || {
        rm -rf -- "$tmp"
        return 1
    }

    rm -rf -- "$tmp"
}

# launch esp32 dev environment
esp32 {
    cd $HOME/src/esp-idf
    unset PYTHONPATH
    . export.sh
}
