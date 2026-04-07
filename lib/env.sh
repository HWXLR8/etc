export EDITOR='emacs -nw'
export TERM='xterm'
export PS1='\[\e[0;35m\][\W]\[\e[0m\]$(__git_ps1) '

# for qt5 moc used by MAME
export PATH=$PATH:/usr/lib64/qt5/bin

# libxenon
export DEVKITXENON="/usr/local/xenon"
export PATH="${PATH:+${PATH}:}"$DEVKITXENON"/bin:"$DEVKITXENON"/usr/bin"

# claude
export ANTHROPIC_BASE_URL="http://localhost:8001"
export ANTHROPIC_API_KEY='sk-ant-local-123'

# theme
export QT_STYLE_OVERRIDE=Adwaita-Dark
