#!/bin/bash

. ./utils.sh

function getPidsFromPidFile() {
    for file in $* ;
    do
        pid=$(cat $file 2>/dev/null)
        if [[ -n $pid ]] && isInteger $pid ; then
            echo -e "$pid "
        fi
    done
}

function isRunning() {
    isInteger "$1" && [[ -d /proc/$1 ]]
}

function getCmdLine() {
    cat /proc/$1/cmdline | tr '\000' ' '
}

function getCmdLineParams() {
    local arr=($(cat /proc/$1/cmdline | tr '\000' ' ' ))
    unset arr[0]
    echo ${arr[@]}
}

function getPid() {
    pgrep $1
}

function waitForShutdown() {
    local pid=$1
    local WAIT_COUNT=$2

    if [[ -z $WAIT_COUNT ]]; then WAIT_COUNT=10 ; fi
    local count=0
    while isRunning $pid  && [[ $count -lt $WAIT_COUNT ]]
    do
        echo -n .
        sleep 1
        count=$((count+1))
    done

    ! isRunning $pid
}
