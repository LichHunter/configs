#!/bin/bash

function run {
  if ! pgrep $1; then
    $@ &
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.xmonad/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output eDP-1 --primary --mode 2560x1440 --pos 0x1440 --rotate normal --output DP-1 --mode 3440x1440 --pos 0x0 --rotate normal --output HDMI-1-0 --mode 2560x1440 --pos 3440x0 --rotate right --output DP-1-0 --off --output DP-1-1 --off
xrandr --output eDP-1 --primary --mode 2560x1440 --pos 0x1440 --rotate normal --output DP-1 --mode 3440x1440 --pos 0x0 --rotate normal --output HDMI-1-0 --off --output DP-1-0 --off --output DP-1-1 --mode 2560x1440 --pos 3440x0 --rotate right

(
  sleep 2
  #run $HOME/.config/polybar/launch.sh
  run $HOME/.config/polybar/launch.sh --colorblocks
) &

#change your keyboard if you need it
#setxkbmap -layout be

#cursor active at boot
xsetroot -cursor_name left_ptr &

#start ArcoLinux Welcome App
#run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop

#Some ways to set your wallpaper besides variety or nitrogen
feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
#start the conky to learn the shortcuts
(conky -c $HOME/.xmonad/scripts/system-overview) &

#starting utility applications at boot time
run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
run volumeicon &
numlockx on &
blueberry-tray &
picom --config $HOME/.xmonad/scripts/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &

#starting user applications at boot time
#nitrogen --restore &
