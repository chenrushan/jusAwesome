#
# ~/.bash_profile
#

# if [[ `pgrep dhcpcd` == "" ]]; then
#     sudo wpa_supplicant -B -i wlp3s0 -c /etc/wpa_supplicant/alibaba.conf
#     sudo dhcpcd wlp3s0 &
# fi

if [[ `pgrep startx` == "" ]]; then
    sudo hwclock -s --localtime
    startx
fi

unset PROMPT_COMMAND

[[ -f ~/.bashrc ]] && . ~/.bashrc

