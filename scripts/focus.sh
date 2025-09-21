#!/usr/bin/env bash

hyprctl activewindow | head -n1 | awk -F'-> |:' '{print $2}'|cut -c -${1:-99}
