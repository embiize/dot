#!/bin/sh
fg="#efefef"
bg="#277a6d"
bg_volume="#1177aa"
PosX_info=`expr 1366 - 966 - 100`
PosX_clock=`expr 1366 / 2 - 100`
PosX_volume=`expr 1366 - 100`

conky -c ~/.xmonad/assets/conky/info.conkyrc | dzen2 -p -ta r -e 'button3=' -fn 'Droid Sans Fallback-8' -fg "$fg" -bg "$bg" -h 24 -w 966 -x $PosX_info &
conky -c ~/.xmonad/assets/conky/clock.conkyrc | dzen2 -p -ta c -e 'button3=' -fn 'Droid Sans Fallback-8' -fg "$fg" -bg "$bg" -h 24 -w 200 -x $PosX_clock &
conky -c ~/.xmonad/assets/conky/volume.conkyrc | dzen2 -p -ta r -e 'button3=' -fn 'Droid Sans Fallback-8' -fg "$fg" -bg "$bg_volume" -h 24 -w 100 -x $PosX_volume &
