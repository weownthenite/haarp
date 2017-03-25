#!/bin/sh
PATH_HAARP="/home/tong/dev/project/haarp"
PATH_ELECTRON="$PATH_HAARP/bin/node_modules/.bin/electron"
$PATH_ELECTRON $PATH_HAARP/bin $@
