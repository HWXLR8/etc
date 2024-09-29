# youtube
alias yta='yt-dlp -f bestaudio'
alias ytls='yt-dlp -F'
alias ytd='yt-dlp -f'

# downlaod the (generally) best quailty version of a youtube videa,
# this is not perfect
function yt {
    yt-dlp \
        -f "(bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec=vp9.2][height>=1080] \
        [fps>30]/bestvideo[vcodec=vp9][height>=1080][fps>30]/bestvideo[vcodec^=av01] \
        [height>=1080]/bestvideo[vcodec=vp9.2][height>=1080]/bestvideo[vcodec=vp9] \
        [height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720] \
        [fps>30]/bestvideo[vcodec=vp9.2][height>=720][fps>30]/bestvideo[vcodec=vp9][height>=720] \
        [fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec=vp9.2][height>=720]/ \
        bestvideo[vcodec=vp9][height>=720]/bestvideo[height>=720]/bestvideo)+ \
        (bestaudio[acodec=opus]/bestaudio)/best" $1
}

# search youtube
function yts {
    yt-dlp ytsearch10:"$1" --get-title --get-id
}

# play youtube videos using mpv
function ytmpv {
    mpv https://www.youtube.com/watch?v=$1
}

# play youtube audio stream using mpv
function ytmpva {
    mpv --no-video https://www.youtube.com/watch?v=$1
}
