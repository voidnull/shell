#!/bin/bash

. ./utils.sh

#------------------------------------------------------------------------------------
# Get the pids from the pid files specified
#------------------------------------------------------------------------------------
function getPidsFromPidFile() {
    for file in $* ;
    do
        pid=$(cat $file 2>/dev/null)
        if [[ -n $pid ]] && isInteger $pid ; then
            echo -e "$pid "
        fi
    done
}

#------------------------------------------------------------------------------------
# Check if the given pid is running or not
#------------------------------------------------------------------------------------
function isRunning() {
    isInteger "$1" && [[ -d /proc/$1 ]]
}

#------------------------------------------------------------------------------------
# Get the full command line of the pid 
#------------------------------------------------------------------------------------
function getCmdLine() {
    cat /proc/$1/cmdline | tr '\000' ' '
}

#------------------------------------------------------------------------------------
# Get just the command line params of the pid
#------------------------------------------------------------------------------------
function getCmdLineParams() {
    local arr=($(cat /proc/$1/cmdline | tr '\000' ' ' ))
    unset arr[0]
    echo ${arr[@]}
}

#------------------------------------------------------------------------------------
# Get the pid of the process
#------------------------------------------------------------------------------------
function getPid() {
    pgrep $1
}

#------------------------------------------------------------------------------------
# usage: waitForShutdown pid [waitsecs]
# wait for a given wait seconds till the process dies
#------------------------------------------------------------------------------------

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
