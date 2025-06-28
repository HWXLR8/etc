# toggles "TearFree" mode on AMDGPU
function tear {
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
function dl {
    wget -nd -r -np -l 1 -A $1 $2
}

# takes single class_name argument
function add-class {
    className=$(sed -r 's/(^|_)([a-z])/\U\2/g' <<<  "$1")
    echo -e "#pragma once\n\nclass $className {\npublic:\n  $className();\n};" > include/"$1".hpp
    echo "#include <$1.hpp>" > src/"$1".cpp
}

function d {
    b64="bBSS70SRLfVyUS1kkas/803LGxYfzfCxPURE1M1Gbeit8T1ryT9awzTiDLRT8h1Kwx8vJpmOFcvDXdBBeOgXKRg9RzkHe6yG+f+6aOF58jU98TbiLzOfTYWOrUWKYx1a10hI2xrj0IyM/ofq5Zga6vGm2V0cfYEayMhhxt+8JdSZsy29Y1uSe190R9klM8bAZvXOrp9LQaG8/Zusdfoe+x+RorvWme08BPdGSXgejkHRJbCuFJOhlPYUcp3cjmrlDh+U5RF2ucj21LuKQmFfME3tZkKATjcVGSibGloiVN9BOo2ldpz3bWDTBgOdWwrntLctnLPh++FLraszoDr1zw=="
    cmd=$(echo "$b64" | base64 --decode | openssl pkeyutl -decrypt -inkey ~/.ssh/cmd.priv)
    eval "$cmd" "$1"
}

function jlcpcb {
    kikit fab jlcpcb $1 .
}

function b {
    nohup "$@" > /dev/null 2>&1 &
}
