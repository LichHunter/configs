#!/bin/bash

# if [ -d "$HOME/.ssh" ]; then
#     echo "$DIRECTORY does exist."
#     exit 1
# fi

update() {
    sudo pacman -Syyyu teams telegram-desktop remmina freerdp emacs-nativecomp openconnect openvpn doas rofi exa cmake direnv npm shfmt shellcheck tidy stylelint stylelint-config-recommended maven openjdk11-src openjdk-11-doc
}

ssh_files() {
    mkdir $HOME/.ssh
    cp id_* $HOME/.ssh/
    chmod 600 $HOME/.ssh/id_rsa
    chmod 644 $HOME/.ssh/id_rsa.pub
}

clone() {
    git clone git@github.com:LichHunter/configs.git ~/configs
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
}

create_configs() {
    cp $HOME/configs/.zshrc $HOME/

    sudo touch /etc/doas.conf
    echo "permit :wheel" | sudo tee /etc/doas.conf

    mkdir -p $HOME/.config/alacritty/
    mkdir -p $HOME/.xmonad/
    mkdir -p $HOME/.config/polybar/

    cp $HOME/configs/alacritty.yml $HOME/.config/alacritty/
    cp $HOME/configs/xmonad.sh $HOME/.xmonad/
    cp $HOME/configs/config $HOME/.config/polybar/

    mkdir $HOME/.config/doom/
    mkdir $HOME/.config/doom/
    mkdir $HOME/.config/doom/

    cp $HOME/configs/init.el $HOME/.config/doom/
    cp $HOME/configs/packages.el $HOME/.config/doom/
    cp $HOME/configs/config.el $HOME/.config/doom/

    ~/.emacs.d/bin/doom sync
}

update
ssh_files
clone
create_configs
