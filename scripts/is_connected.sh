#!/bin/zsh
##
## Author: u0xpsec     2018
###!/bin/zsh
##
## Author: u0xpsec     2018
##

if [[ `nmcli -t device show wlp0s20f | grep "GENERAL.STATE"` == *"(connected)"* ]] || [[ `nmcli -t device show enp0s25 | grep "GENERAL.STATE"` == *"(connected)"* ]];then
  if [[ `nmcli -t device show wlp0s20f | grep "GENERAL.STATE"` == *"(connected)"* ]];then
    echo "< wifi connected:" `nmcli -t device show wlp0s20f | grep "GENERAL.CONNECTION" | cut -d":" -f2-` ">"
  elif [[ `nmcli -t device show enp0s25 | grep "GENERAL.STATE"` == *"(connected)"* ]];then
    echo "───────- < Cable connected:" `nmcli -t device show enp0s25 | grep "GENERAL.CONNECTION" | cut -d":" -f2-` ">"
  fi
else
  echo "< not connected >"
fi
