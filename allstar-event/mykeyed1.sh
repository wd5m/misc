#!/bin/bash
# Program: mykeyed1.sh
# Author: David McAnally WD5M
# Copyright 2022
# Free for amateur radio service use
# https://github.com/wd5m/misc/tree/master/allstar-event
# Purpose: Disconnect Allstar nodes that interfere with SPACE audio feed.
# Node 1100 is the private node providing NASA SPACE audio and is ignored.
#
# Use this script at your own risk. You can read what it does below.
#
# Change history:
# 20220901 Initial version
# 20221101 Modified to add a recursive loop checking for nodes that key
#          while RPT_TXKEYED is enabled. This catches nodes that transmit while
#          the SPACE node is talking.
#
# A few variables to set
PGM=`basename $0`
declare -i ENABLED=1    # Set to 1 to enable this event script.
declare -i DEBUG=1      # enables logging if set to 1
LOGFILE="/tmp/${PGM}.log"
LOCKFILE="/tmp/${PGM}.lock"
# Only run one copy at a time
[ -f "${LOCKFILE}" ] && exit
# The cleanup function is called on exit.
function cleanup {
   [ ${DEBUG} -eq 1 ] && log "Removing lock file"
   rm -f ${LOCKFILE}
}
trap cleanup EXIT
# Create lock file
touch "${LOCKFILE}"
declare -A INOUT
declare -A CONNECTED
localNode="${1}"
function log() {
        DATE=`date '+%a %b %d %T %Z %Y'`
        echo "${DATE} ${@}" >> ${LOGFILE}
        echo "${DATE} ${@}"
}
function processShowvars() {
# the processShowvars function retreives rpt showvars results from asterisk
# and processes the records.
        local IFS=$'\n'
        set -f;
        declare -i ISKEYED=1
        while [ ${ISKEYED} -eq 1 ]
        do
                #let r=0
                for line in $(/usr/sbin/asterisk -rx "rpt showvars ${localNode}"); do
                        [ ${DEBUG} -eq 1 ] && log "${line}"
                        if [[ "${line:3:10}" == "RPT_ALINKS" ]]; then
                                setconnected ${line}
                        elif [[ "${line:3:13}" == "RPT_TXKEYED=0" ]]; then
                                let ISKEYED=0
                                return
                        fi
                        #let r=${r}+1
                done
                /bin/sleep 1s
        done
}
function setconnected() {
# the setconnected function parses the connected node list into
# a array and processes to reconnect other OUT transceive/monitor nodes to local monitor mode.
        [ ${DEBUG} -eq 1 ] && log "setconnected ${1}"
        [ "${1}" == "<NONE>" ] && return;
        local IFS=','
        set -f;
        read -a nodes <<< "${1}"
        unset IFS
        [ ${DEBUG} -eq 1 ] && log "${#nodes[*]} values."
        [ "${#nodes[*]}" == "1" ] && return;
        let c=0
        for val in ${nodes[@]}; do
                let c=${c}+1
                [ ${DEBUG} -eq 1 ] && log "${val}"
                [ ${c} -eq 1 ] && continue;     # skip node count
                node=${val:0:-2}
                status=${val:(-1)}
                #log "-${node} ${status}-"
                if [[ "${node}" == "1100" ]]; then
                        [ ${DEBUG} -eq 1 ] && log "skipping ${val}"
                        continue;
                elif [[ ${status} == K ]]; then
                        log "${val} is keyed"
                        result=$(/usr/sbin/asterisk -rx "rpt cmd ${localNode} ilink 11 ${node}")
                        [[ -n "${result}" ]] && log "asterisk rpt cmd returned: ${result}"
                fi
        done
}
if [[ ${ENABLED} -eq 1 ]]; then
        log "starting ${localNode}"
        #/bin/sleep 1s  # ignore kerchunk
        processShowvars
fi

trap - EXIT
cleanup

exit 0
