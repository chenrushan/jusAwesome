xcompmgr -cCFf &
# tint2 &
# conky &
# feh --bg-scale /home/juscodit/.wallpaper.jpg

# export the following variables so that applications can work with xsunpinyin
export XMODIFIERS="@im=xsunpinyin"
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="xim"

xsunpinyin -d &

dropboxd &

# =================================================================
# I encountered a strange problem before I set LANG as UTF8 here.
# The problem is if I launch urxvt from openbox menu, the Chinese
# char cannot be displayed correctly, but if I launch urxvt from
# a shell, everythings works fine. It turns out that the problem
# lies in locale setting. Openbox menu launcher doesn't set locale
# correctly, so it's necessay to set it here before openbox starts.
#
# Seems it's necessary to further set LANG as "zh_CN.UTF-8", since
# it gives a prettier display of Chinese font.

export LANG="zh_CN.UTF-8"
# =================================================================

# =================================================================
# I want to switch out vbox windows using hotkey, instead of pressing
# right ctrl and then alt-tab or using mouse. My solution is
# 'linux while loop + windows AutoHotkey'. 'while loop' is used to
# run command repeatedly, and 'AutoHotkey' is used to register
# hotkeys in windows.
#
# 1. Register win+<num> in AutoHotkey which writes a desktop switching
#    command into a file. Make sure to configure AutoHotkey to lanuch
#    on windows startup.
# 2. Use 'while true' to run the above-mentioned file constantly. Note
#    that you should delete the file after execute it, otherwise,
#    it will be run all the time.

while true; do sleep 0.3 && sh /home/juscodit/.vmguest.cmd && rm \
  /home/juscodit/.vmguest.cmd; done &
# =================================================================

# =================================================================
# swap win key and alt key on mac
# setxkbmap is a preferred command over xmodmap
#
# see /usr/share/X11/xkb/rules/base.lst for all available options
# and all possible arguments to those options.
#
# The file is divied into several sections. Each section starts with
# a line like '! xxxxx', for example '! model', it means you can
# provide -model option to setxkbmap. All lines following '! xxxxx'
# are possible arguments to this option, for example, 'pc102' is a
# line under '! model', so you can invoke setxkbmap as:
#   setxkbmap -model pc102
#
# Note that there's a line 'altwin:swap_alt_win' under section
# '! option', and this is what you use to swap alt and win key

setxkbmap -option altwin:swap_alt_win
# =================================================================

# =================================================================
# In IBM book which has a trackpoint, you may want to disable touchpad.
# run "xinput list" to get the touchpad name, for example,
# "SynPS/2 Synaptics TouchPad", uncomment the following line:
#
# xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 0
# =================================================================

xset +fp /usr/share/fonts/local
xset fp rehash

# don't use openbox, or the autostart will not be runned
exec openbox-session

