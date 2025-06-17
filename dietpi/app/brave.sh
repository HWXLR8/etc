#!/bin/bash

mkdir -p ~/.local/bin
cat > ~/.local/bin/brave <<EOF
#!/bin/bash
exec brave-browser --enable-features=UseOzonePlatform --ozone-platform=wayland "\$@"
EOF
chmod +x ~/.local/bin/brave
