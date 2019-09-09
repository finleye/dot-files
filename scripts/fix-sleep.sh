#!/bin/zsh

sudo su <<HERE
echo XHC > /proc/acpi/wakeup
HERE
