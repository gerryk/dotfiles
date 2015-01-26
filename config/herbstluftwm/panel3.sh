#!/bin/sh

BG="#121212"
FG="#d9d9d9"
CURE="-*-Ohsnap-*-*-*-*-11-*-*-*-*-*-*-*"
SNAP="-*-Ohsnap-*-*-*-*-11-*-*-*-*-*-*-*"

BAR_OPS="-fg #d9d9d9 -bg #555555 -h 7 -w 25 -s o -ss 1 -sw 2"

# Icons
CLOCK="$HOME/.gfx/icons/clock.xbm"
BAT_EMP="$HOME/.gfx/icons/bat_empty_01.xbm"
BAT_LOW="$HOME/.gfx/icons/bat_low_01.xbm"
BAT_FUL="$HOME/.gfx/icons/bat_full_01.xbm"
VOL="$HOME/.gfx/icons/spkr_01.xbm"

CPU="$HOME/.gfx/icons/cpu.xbm"
MEM="$HOME/.gfx/icons/mem.xbm"
FS="$HOME/.gfx/icons/fs_02.xbm"

MAIL="$HOME/.gfx/icons/mail.xbm"
INFO="$HOME/.gfx/icons/info_03.xbm"
MUSIC="$HOME/.gfx/icons/note.xbm"
TEMP="$HOME/.gfx/icons/temp.xbm"
USB="$HOME/.gfx/icons/usb_02.xbm"
PACMAN="$HOME/.gfx/icons/pacman.xbm"

NET_DOWN="$HOME/.gfx/icons/net_down_02.xbm"
NET_UP="$HOME/.gfx/icons/net_up_02.xbm"
WIFI="$HOME/.gfx/icons/wifi_02.xbm"

space(){
	echo "^fn($SNAP)^fg(#555555) | ^fg()^fn()"
}
sysinfo(){
	echo "^ca(3, $HOME/.dzen/script/sysinfo.sh)^fg(#80203d)^i($INFO)^fg() Info^ca()"
}
disk(){
	# SWAP
	# SPROC=$(free -t | grep Swap | awk '{print ($3 / $2) * 100"%"}')
	# SBAR=`echo $SPROC | gdbar $BAR_OPS -max 100`
	# echo "$SBAR $SPROC"

	CPROC=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
	CBAR=`echo $CPROC | gdbar $BAR_OPS -max 100`
	echo "^fg(#80203d)^i($CPU)^fg() $CBAR $CPROC"

	MMAX=$(cat /proc/meminfo | grep MemTotal | cut -d " " -f9)
	MFREE=$(cat /proc/meminfo | grep MemFree | cut -d " " -f10)
	MUSED=$(($MMAX-$MFREE))
	MPROC=$(($MMAX/$MUSED))"%"
	MBAR=`echo $MUSED | gdbar $BAR_OPS -max $MMAX`
	echo "^fg(#80203d)^i($MEM)^fg() $MBAR $MPROC"

	SDA2=$(df -h / | awk '/\/$/ {print $5}' | tr -d '%')
	FS_MAX=$(df -h / | awk '/\/$/ {print $2}' | tr -d '%' | sed 's/G//')
	FS_USE=$(df -h / | awk '/\/$/ {print $3}' | tr -d '%' | sed 's/G//')
	echo -n "^fg(#80293d)^i($FS)^fg() $(echo $SDA2 |gdbar $BAR_OPS -nonl) ${FS_USE}/${FS_MAX} GB ${SDA2}%"
}
bat(){
	BATPROC=$(cat /sys/class/power_supply/BAT0/uevent | grep POWER_SUPPLY_CAPACITY | cut -d '=' -f2)
	BATSTATE=$(cat /sys/class/power_supply/BAT0/uevent | grep POWER_SUPPLY_STATUS | cut -d '=' -f2)
	BATBAR=`echo $BATPROC | gdbar $BAR_OPS -max 100`
	
	if [[ $BATPROC > 70 ]]; then
		echo "^fg(#80203d)^i($BAT_FUL)^fg() $BATBAR $BATPROC"
	elif [[ $BATPROC < 30 ]]; then
		echo "^fg(#80203d)^i($BAT_EMP)^fg() $BATBAR $BATPROC"
	else
		echo "^fg(#80203d)^i($BAT_LOW)^fg() $BATBAR $BATPROC"
	fi
	echo "%"
}
music(){
	echo "^fg(#80203d)^i($MUSIC)^fg() Damian Marley - Welcone To Jamrock"
}
net(){
	NET=$(iwconfig wlp3s0)
	ESSID=$(echo "$NET" | grep -oP '(?<=ESSID:).[^\s]*')
	if [[ $ESSID == "off/any" ]]; then
		echo "^fg(#80203d)^i($WIFI)^fg() Offline"
	else
		DOWN=$(cat /proc/net/dev | grep wlp3s0 | cut -d ':' -f2 | awk '{print $1}')
		UP=$(cat /proc/net/dev | grep wlp3s0 | cut -d ':' -f2 | awk '{print $9}')
		
		DOWNMB=$(($DOWN/131072))
		UPMB=$(($UP/1048576))

		echo "$DOWN Bit/s ^fg(#80293d)^i($NET_DOWN)^i($NET_UP)^fg() $UP Bit/s"
	fi
}
weather(){
	NET=$(iwconfig wlp3s0)
	ESSID=$(echo "$NET" | grep -oP '(?<=ESSID:).[^\s]*')
	if [[ ! $ESSID == "off/any" ]]; then

	script=$(python /home/boroshlawa/.dzen/script/weather.py)
	echo "^fg(#80203d)^i($TEMP)^fg() $script $(space)"

	fi
}
mail(){
	echo "^fg(#80203d)^i($MAIL)^fg() 4 new"
}
vol(){
	ismute=`amixer get Master|grep %|awk '{ print $6 }'|sed 's/\[//g'|sed 's/\]//g'`
	if [ "$ismute" == "off" ]; then
		VBS="0"
	else
		VBS=`amixer get Master|grep %|awk '{ print $4 }'|sed 's/%//g'|sed 's/\[//g'|sed 's/\]//g'`
	fi	
	
	VBAR=`echo "$VBS" | gdbar $BAR_OPS |awk '{ print $1 }'`
	echo "^fg(#80293d)^i($VOL)^fg() $VBAR"
}
dateTime(){
	
	DATE=`date +"%b %d %A,"`
	TIME=`date +"%I:%M:%S"`
	# echo "^ca(3, $HOME/.dzen/script/date.sh)^fg(#80203d)^i($CLOCK)^fg() $TIME^ca()"
	echo "^fg(#80203d)^i($CLOCK)^fg() $DATE $TIME"
}

while true ; do
	echo $(sysinfo)$(space)$(disk)$(space)$(net)$(space)$(bat)$(space)$(mail)$(space)$(vol)$(space)$(dateTime)	
done | dzen2 -p -h 30 -fg $FG -bg $BG -fn $CURE -e 'button2=;'
