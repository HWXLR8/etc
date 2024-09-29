alias cpufreq='watch -n 0.25 "cat /proc/cpuinfo | grep MHz"'
alias j="emacs -nw $(date +'%b-%d-%Y')"
alias myip='curl http://ifconfig.me'

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
