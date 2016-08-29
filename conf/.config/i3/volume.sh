#!/bin/sh

on_off=$(amixer get Master | grep '\[off\]')
if [[ "$on_off" != "" ]]; then
    echo $on_off | awk '{print $6}'
else
    amixer get Master | grep -E -o '[0-9]{1,3}?%' | head -1
fi

