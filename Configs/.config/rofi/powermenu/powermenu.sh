# Author: https://github.com/adi1090x/rofi
# Modified by: ladev325

dir="${HOME}/.config/rofi/powermenu"
theme='style'

uptime=`uptime -p | sed -e 's/up //g'`
host=hostname

shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

rofi_cmd() {
    rofi -x11 -dmenu \
    -p "󰣇 ${USER}" \
    -mesg "Uptime: $uptime" \
    -theme ${dir}/${theme}.rasi
}

confirm_cmd() {
    rofi -x11 -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme ${dir}/confirm.rasi
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$shutdown\n$suspend\n$logout\n$reboot\n$lock" | rofi_cmd
}

run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
            elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
            elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
            elif [[ $1 == '--logout' ]]; then
            if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                openbox --exit
                elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                bspc quit
                elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                i3-msg exit
                elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            fi
        fi
    else
        exit 0
    fi
}

chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
    ;;
    $reboot)
        run_cmd --reboot
    ;;
    $lock)
        if [[ -x '/usr/bin/betterlockscreen' ]]; then
            betterlockscreen -l
            elif [[ -x '/usr/bin/i3lock' ]]; then
            i3lock
        fi
    ;;
    $suspend)
        run_cmd --suspend
    ;;
    $logout)
        run_cmd --logout
    ;;
esac