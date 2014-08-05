#!/bin/sh

# Author: Rushan Chen
# Email: juscodit@gmail.com

if [[ $# == 0 ]]; then
    echo "[USAGE]: applauncher.sh [app] [sleeptime] [icon] [title] [app args]"
    exit 0
fi

args=("$@")

app=$1
sltime=$2
icon=$3
title=$4

cmd="$app"
for ((i = 4; i < $#; ++i)); do
    cmd=${cmd}" '${args[$i]}'"
done

function setIconTitle()
{
    sleep $sltime

    # get current window id
    activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
    activeWinId="${activeWinLine:40}"

    # set icon and title
    xseticon -id $activeWinId $icon

    if [[ $title != "none" ]]; then
        wmctrl -i -r $activeWinId -T $title
    fi
}

eval $cmd & setIconTitle

