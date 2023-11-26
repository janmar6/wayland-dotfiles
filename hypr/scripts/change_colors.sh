#!/bin/bash

if $(grep -q light $HOME/.cache/themeis.txt) ; then
    light_theme=true
else
    light_theme=false
fi

random=''
file=''

print_usage() {
  printf "Usage: $0 [-l] [-r] [-f] [image name]"
}

# Changed how program sees if should apply light theme
# Adding -l is forcing light theme
while getopts 'lrf:' flag; do
  case "${flag}" in
    l) light_theme='true' ;;
    r) random='true' ;;
    f) file="${OPTARG}";;
    *) print_usage
       exit 1 ;;
  esac
done
echo $file

wallpaperdir="$HOME/Pictures/wallpapers/"

current_wal=$(cat $HOME/.cache/wal/wal | grep -o '[^/]*$')
wallpaper=$file

if [ $random ]; then
    # chooses a wallpaper that is not currently active
    wallpaper=$(ls --color=never $wallpaperdir | grep -v ^$current_wal | sort -R | head -n 1 )
elif [ -z $file ]; then
    wallpaper=$(ls --color=never $wallpaperdir | wofi -d)
fi

# exit if no wallpaper chosen
[ -z $wallpaper ] && exit

# Copy the wallpaper to cache for swaylock
cp $wallpaperdir$wallpaper $HOME/.cache/current_wallpaper.jpg

#start swwww
swww query || swww init

swww img $wallpaperdir$wallpaper --transition-fps 30 --transition-type grow --transition-duration 2 --transition-pos top-right

#set the GTK theme
SWITCHTO=""
$light_theme || SWITCHTO="-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita$SWITCHTO"
gsettings set org.gnome.desktop.interface icon-theme "Adwaita$SWITCHTO"

lightmodepar=""
$light_theme && lightmodepar="-l"
wal -i $wallpaperdir$wallpaper -n $lightmodepar
pkill waybar
waybar &
