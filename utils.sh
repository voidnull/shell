#!/bin/bash

#------------------------------------------------------------------------------------
#  c.f : http://www.linuxjournal.com/content/bash-brace-expansion
#  convert ranges like [1-10] to shell brace {1..10} and expand
#  to be used for hostname ranges
#  Eg:
#   --  hosts=($(rangeexpand www[1-5].example.com ))  -- hosts will be an array
#   --  hosts="$(rangeexpand www[1-5].example.com)"  -- hosts will be a single string
#------------------------------------------------------------------------------------
function rangeexpand() {
    local sedopts="-E"
    if [[ `uname` -eq "Linux" ]] ; then sedopts="-r" ; fi

    echo $(eval echo $(echo "$@" | sed $sedopts -e 's/\[ *([a-zA-Z0-9]+) *- *([a-zA-Z0-9]+)*\]/{\1..\2}/g'))
}

#------------------------------------------------------------------------------------
# Check if a variable is defined / notdefined
# Variable is defined , if it is NOT empty or
# the value of varname+xxx is equal to xxx
#------------------------------------------------------------------------------------
function defined() {
    local VAR="$1"
    [[ -n $(eval echo \$${VAR}) ]] || [[ "xxx" == $(eval echo \${${VAR}+xxx}) ]]
}

function notdefined() {
    ! defined "$1"
}

function hasValue() {
    local VAR="$1"
    [[ -n $VAR && -n $(eval echo \$${VAR}) ]]
}

#------------------------------------------------------------------------------------
# Change case
#------------------------------------------------------------------------------------

function toLower() {
    echo $* | tr '[A-Z]' '[a-z]'
}

function toUpper() {
    echo $* | tr '[a-z]' '[A-Z]'
}

#------------------------------------------------------------------------------------
#  check if the param is one of true/1/yes/on - case insensitive
#  usage:  if isTrue yes; then ...; else ... ; fi
#------------------------------------------------------------------------------------

function isTrue() {
    local value=$(toLower $1)
    [[ $value =~ ^\ *(true|on|1|yes)\ *$ ]]
}

#------------------------------------------------------------------------------------
#  check if the param is one of false/0/no/off - case insensitive
#  usage:  if isFalse yes; then ...; else ... ; fi
#------------------------------------------------------------------------------------

function isFalse() {
    local value=$(toLower $1)
    [[ $value =~ ^\ *(0|false|no|off)\ *$ ]]
}

function isInteger() {
    [[ $1 =~ ^[0-9]+$ ]]
}

function isEmpty() {
    [[ -z $1 ]]
}

