#!/bin/bash

# default monitor is LVDS1
MONITOR=DP-2

# functions to switch from LVDS1 to HDMI-0 and vice versa
function ActivateHDMI-0 {
  echo "Switching to HDMI-0"
  xrandr --output HDMI-0 --mode auto --scale 2x2
  MONITOR=HDMI-0
}
function DeactivateHDMI-0 {
  echo "Switching to DP-2"
  xrandr --output HDMI-0 --off --output DP-2 --auto
  MONITOR=DP-2
}

# functions to check if HDMI-0 is connected and in use
function HDMI-0 {
  [ $MONITOR = "HDMI-0" ]
}
function HDMI-0 {
  ! xrandr | grep "^HDMI-0" | grep disconnected
}

# actual script
# while true
# do
#   if ! VGAActive && VGAConnected
#   then
#     ActivateVGA
#   fi
#
#   if VGAActive && ! VGAConnected
#   then
#     DeactivateVGA
#   fi
#
#   sleep 1s
# done
