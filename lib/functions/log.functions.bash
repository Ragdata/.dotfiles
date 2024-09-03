#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# log.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         log.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# CORE LOG FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# _logPriority
# ------------------------------------------------------------------
_logPriority()
{
    _group 'internal'

    local level="${1?}" result

    case "${level^^}" in
        10)         result="TRACE";;
        100)        result="DEBUG";;
        200)        result="ROUTINE";;
        300)        result="INFO";;
        400)        result="NOTICE";;
        500)        result="WARNING";;
        600)        result="ALERT";;
        700)        result="ERROR";;
        800)        result="CRITICAL";;
        900)        result="FATAL";;
        TRACE)      result=10;;
        DEBUG)      result=100;;
        ROUTINE)    result=200;;
        INFO)       result=300;;
        NOTICE)     result=400;;
        WARNING)    result=500;;
        ALERT)      result=600;;
        ERROR)      result=700;;
        CRITICAL)   result=800;;
        FATAL)      result=900;;
        *) errorExit "Invalid Argument '$2'";;
    esac

    if [[ $result =~ ^[0-9]+$ ]]; then
        printf -- '%u' "$result"
    else
        printf -- '%s' "$result"
    fi
}
# ------------------------------------------------------------------
# log::checkLog
# ------------------------------------------------------------------
log::checkLog()
{
    group 'log'

    local size fileName="${1:-"dotfiles"}"
    # initialise logfile if it doesn't exist
    [ -f "$DOT_LOG/$fileName.log" ] || log::init "$fileName"
    # check logfile size
    size="$(wc -c "$DOT_LOG/$fileName.log" | awk 'print $1')"
    # rotate if necessary
    [ "$size" -ge "$LOG_SIZE" ] && log::rotate "$fileName"
}
# ------------------------------------------------------------------
# log::init
# ------------------------------------------------------------------
log::init()
{
    group 'log'

    local fileName="${1:-"dotfiles"}"

    [ ! -d "$DOT_LOG" ] && { mkdir -p "$DOT_LOG" || errorExit "Unable to create directory '$DOT_LOG'"; }
    [ ! -f "$DOT_LOG/$fileName.log" ] && { touch "$DOT_LOG/$fileName.log" || errorExit "Unable to create file '$DOT_LOG/$fileName.log'"; }
}
# ------------------------------------------------------------------
# log::rotate
# ------------------------------------------------------------------
log::rotate()
{
    group 'log'

    local fileName="${1:-"dotfiles"}"
    local filePath="$DOT_LOG/$fileName.log"
    local timestamp files diff c

    timestamp="$(date +%s)"

    # archive logfile if configured to do so
    ((LOG_ARCHIVE == 1)) && { tar -czf "$filePath" "$filePath.tar.gz"; filePath="$filePath.tar.gz"; }
    # timestamp current logfile
    mv "$filePath" "$filePath.$timestamp"
    # cull excess backups
    files="$(find "$DOT_LOG" -name "$fileName" | wc -l)"
    diff=$(( "$files" - "$LOG_BACKUPS" ))
    diff=$diff++
    if [ "$diff" -gt 0 ]; then
        c=1
        for file in "$DOT_LOG/$fileName"*
        do
            rm -f "$file"
            ((c == diff)) && break
            c=$c++
        done
    fi
    # open a fresh log file
    touch "$DOT_LOG/$fileName.log"
}
# ------------------------------------------------------------------
# log::write
# ------------------------------------------------------------------
log::write()
{
    group 'log'

    local msg="${1?}"
    local fileName user priority timestamp tag 
    local options isError=0 minLevel msgLevel msgLog

    shift

    options="$(getopt -l "file:,priority:,tag:,error" -o "f:p:t:e" -a -- "$@")"

    eval set --"$options"

    while true
    do
        case "$1" in
            -f|--file)
                fileName="${2?}"
                shift 2
                ;;
            -p|--priority)
                case "$2" in
                    10|trace)
                        priority="TRACE"
                        ;;
                    100|debug)
                        priority="DEBUG"
                        ;;
                    200|routine)
                        priority="ROUTINE"
                        ;;
                    300|info)
                        priority="INFO"
                        ;;
                    400|notice)
                        priority="NOTICE"
                        ;;
                    500|warning)
                        priority="WARNING"
                        ;;
                    600|alert)
                        priority="ALERT"
                        ;;
                    700|error)
                        priority="ERROR"
                        isError=1
                        ;;
                    800|critical)
                        priority="CRITICAL"
                        isError=1
                        ;;
                    900|fatal)
                        priority="FATAL"
                        isError=1
                        ;;
                    *) errorExit "Invalid Argument '$2'";;
                esac
                shift 2
                ;;
            -t|--tag)
                tag="${2?}"
                shift 2
                ;;
            -e|--error)
                isError=1
                shift
                ;;
            --)
                shift
                break
                ;;
            *)  errorExit "Invalid Argument '$1'";;
        esac
    done

    if [ -z "$priority" ] && ((isError == 1)); then priority="ERROR"; fi

    if [ -z "$fileName" ]; then fileName="dotfiles"; fi
    if [ -z "$priority" ]; then priority="INFO"; fi

    minLevel="$(_logPriority "$LOG_LEVEL")"
    msgLevel="$(_logPriority "$priority")"

    ((minLevel > msgLevel)) && return 0

    user="$(whoami)"

    timestamp="$(date '+%y-%m-%d:%I%M%S.%3N')"

    msgLog="$timestamp [$priority] ($user) :: ${tag}${msg}"

    log::checkLog "$fileName"

    if [[ -w "$DOT_LOG/$fileName.log" ]]; then
        echo "$msgLog" >> "$DOT_LOG/$fileName.log"
    else
        sudo bash -c 'echo "$msgLog" >> "$BB_LOG"'
    fi
}
####################################################################
# LOG ALIAS FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# logInit
# ------------------------------------------------------------------
logInit() { group 'log'; log::init "${1:-"info"}"; }
# ------------------------------------------------------------------
# log::trace
# ------------------------------------------------------------------
log::trace() { group 'log'; log::write "${1?}" -p 10; }
# ------------------------------------------------------------------
# log::debug
# ------------------------------------------------------------------
log::debug() { group 'log'; log::write "${1?}" -p 100; }
# ------------------------------------------------------------------
# log::routine
# ------------------------------------------------------------------
log::routine() { group 'log'; log::write "${1?}" -p 200; }
# ------------------------------------------------------------------
# log::info
# ------------------------------------------------------------------
log::info() { group 'log'; log::write "${1?}" -p 300; }
# ------------------------------------------------------------------
# log::notice
# ------------------------------------------------------------------
log::notice() { group 'log'; log::write "${1?}" -p 400; }
# ------------------------------------------------------------------
# log::warning
# ------------------------------------------------------------------
log::warning() { group 'log'; log::write "${1?}" -p 500; }
# ------------------------------------------------------------------
# log::alert
# ------------------------------------------------------------------
log::alert() { group 'log'; log::write "${1?}" -p 600; }
# ------------------------------------------------------------------
# log::error
# ------------------------------------------------------------------
log::error() { group 'log'; log::write "${1?}" -p 700; }
# ------------------------------------------------------------------
# log::critical
# ------------------------------------------------------------------
log::critical() { group 'log'; log::write "${1?}" -p 800; }
# ------------------------------------------------------------------
# log::fatal
# ------------------------------------------------------------------
log::fatal() { group 'log'; log::write "${1?}" -p 900; }
####################################################################
# LOG COMBO FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# echoLog
# ------------------------------------------------------------------
echoLog()
{
    group 'log'

    local msg="${1?}"
    local color symbol fileName user priority timestamp tag options logMsg
    local isError=0 isWarn=0 isInfo=0 isSuccess=0 minLevel msgLevel msgLog
    local -a LOGARGS OUTARGS

    shift

    options="$(getopt -l "color:,Symbol:,file:,priority:,tag:,noline,error,warn,info,success" -o "c:S:f:p:t:newis" -a -- "$@")"

    eval set --"$options"

    while true
    do
        case "$1" in
            -c|--color)
                color="$2"
                shift 2
                ;;
            -S|--Symbol)
                symbol="${2?}"
                shift 2
                ;;
            -f|--file)
                LOGARGS+=("-f")
                LOGARGS+=("${2?}")
                shift 2
                ;;
            -p|--priority)
                case "$2" in
                    10|trace)
                        priority="TRACE"
                        ;;
                    100|debug)
                        priority="DEBUG"
                        ;;
                    200|routine)
                        priority="ROUTINE"
                        ;;
                    300|info)
                        priority="INFO"
                        isInfo=1
                        ;;
                    400|notice)
                        priority="NOTICE"
                        ;;
                    500|warning)
                        priority="WARNING"
                        isWarn=1
                        ;;
                    600|alert)
                        priority="ALERT"
                        ;;
                    700|error)
                        priority="ERROR"
                        isError=1
                        ;;
                    800|critical)
                        priority="CRITICAL"
                        isError=1
                        ;;
                    900|fatal)
                        priority="FATAL"
                        isError=1
                        ;;
                    *) errorExit "Invalid Argument '$2'";;
                esac
                shift 2
                ;;
            -t|--tag)
                LOGARGS+=("-t")
                LOGARGS+=("${2?}")
                shift 2
                ;;
            -n|--noline)
                OUTARGS+=("-n")
                ;;
            -e|--error)
                LOGARGS+=("-e")
                OUTARGS+=("-E")
                isError=1
                shift
                ;;
            -w|--warn)
                isWarn=1
                shift
                ;;
            -i|--info)
                isInfo=1
                shift
                ;;
            -s|--success)
                isSuccess=1
                shift
                ;;
            --)
                shift
                break
                ;;
            *)  errorExit "Invalid Argument '$1'";;
        esac
    done

    if [ -z "$priority" ] && ((isError == 1)); then priority="ERROR"; fi
    if [ -z "$priority" ] && ((isWarn == 1)); then priority="WARNING"; fi
    if [ -z "$priority" ] && ((isInfo == 1)); then priority="INFO"; fi
    if [ -z "$priority" ] && ((isSuccess == 1)); then priority="ROUTINE"; fi
    if [ -z "$priority" ]; then priority="INFO"; fi

    minLevel="$(_logPriority "$LOG_LEVEL")"
    msgLevel="$(_logPriority "$priority")"

    ((minLevel > msgLevel)) && return 0

    LOGARGS+=("-p")
    LOGARGS+=("$priority")

    # shellcheck disable=SC2001
    logMsg="$(echo "$msg" | sed 's/\\e\[.+m//g')"

    log::write "$logMsg" "${LOGARGS[@]}"

    if [ -z "$color" ] && ((isError == 1)); then color="${RED}"; fi
    if [ -z "$color" ] && ((isWarn == 1)); then color="${GOLD}"; fi
    if [ -z "$color" ] && ((isInfo == 1)); then color="${LT_BLUE}"; fi
    if [ -z "$color" ] && ((isSuccess == 1)); then color="${LT_GREEN}"; fi

    if [ -n "$color" ]; then
        OUTARGS+=("-c")
        OUTARGS+=("$color")
    fi

    [ -n "$symbol" ] && msg="$symbol $msg"

    echoAlias "$msg" "${OUTARGS[@]}"
}
# ------------------------------------------------------------------
# debugLog
# ------------------------------------------------------------------
debugLog()
{
    group 'log'

    local msg="${ITALIC}${1?}${NORMAL}"

    echoLog "$msg" -c "${WHITE}" -S "⚑" -p 100
}
# ------------------------------------------------------------------
# infoLog
# ------------------------------------------------------------------
infoLog()
{
    group 'log'

    local msg="${1?}"

    echoLog "$msg" -S "$SYMBOL_INFO" -i
}
# ------------------------------------------------------------------
# warnLog
# ------------------------------------------------------------------
warnLog()
{
    group 'log'

    local msg="${1?}"

    echoLog "$msg" -S "$SYMBOL_WARNING" -w
}
# ------------------------------------------------------------------
# errorLog
# ------------------------------------------------------------------
errorLog()
{
    group 'log'

    local msg="${1?}"

    echoLog "$msg" -S "$SYMBOL_ERROR" -e
}
# ------------------------------------------------------------------
# successLog
# ------------------------------------------------------------------
successLog()
{
    group 'log'

    local msg="${1?}"

    echoLog "$msg" -S "$SYMBOL_SUCCESS" -s
}
# ------------------------------------------------------------------
# exitLog
# ------------------------------------------------------------------
exitLog()
{
    group 'log'

    local msg="${1?}"
    local type="${2:-}"
    local code="${3:-1}"
    local symbol

    case "${type,,}" in
        debug)
            debugLog "$msg"
            ;;
        success)
            successLog "$msg"
            ;;
        warn|warning)
            warnLog "$msg"
            ;;
        alert)
            echoLog "$msg" -c "${PINK}" -S "⛛" -p 600 -e
            ;;
        critical)
            echoLog "${BOLD}${BG_PINK}$msg${BG_RESET}${NORMAL}" -c "${BLACK}" -S "$SYMBOL_ERROR" -p 800 -e
            ;;
        fatal)
            echoLog "${BOLD}${BG_RED}$msg${BG_RESET}${NORMAL}" -c "${BLACK}" -S "$SYMBOL_ERROR" -p 900 -e
            ;;
        *)
            errorLog "$msg"
            ;;
    esac

    exit "$code"
}
