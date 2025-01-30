#!/usr/bin/env bash
#   Use this script to test if a given TCP host/port are available

set -e

TIMEOUT=15
STRICT=0
HOST=""
PORT=""
QUIET=0
PROTOCOL="tcp"
WAIT_TIME=0.5

echoerr() {
  if [[ "$QUIET" -ne 1 ]]; then echo "$@" 1>&2; fi
}

usage() {
  cat << USAGE >&2
Usage:
  $0 host:port [-s] [-t timeout] [-- command args]
  -h HOST | --host=HOST       Host or IP under test
  -p PORT | --port=PORT       TCP port under test
                              Alternatively, you specify the host and port as host:port
  -s | --strict               Only execute subcommand if the test succeeds
  -q | --quiet                Don't output any status messages
  -t TIMEOUT | --timeout=TIMEOUT
                              Timeout in seconds, zero for no timeout
  -- COMMAND ARGS             Execute command with args after the test finishes
USAGE
  exit 1
}

wait_for() {
  if [[ "$TIMEOUT" -gt 0 ]]; then
    echoerr "$0: waiting $TIMEOUT seconds for $HOST:$PORT"
  else
    echoerr "$0: waiting for $HOST:$PORT without a timeout"
  fi
  WAIT_START=$(date +%s)
  while :; do
    if ! nc -z "$HOST" "$PORT"; then
      TIMEOUT_END=$(($(date +%s) - WAIT_START))
      if [[ "$TIMEOUT" -gt 0 ]] && [[ $TIMEOUT_END -ge "$TIMEOUT" ]]; then
        echoerr "$0: timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT"
        exit 1
      fi
      sleep $WAIT_TIME
      continue
    fi
    TIMEOUT_END=$(($(date +%s) - WAIT_START))
    echoerr "$0: $HOST:$PORT is available after $TIMEOUT_END seconds"
    break
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    *:* )
    HOST=$(echo $1 | cut -d : -f 1)
    PORT=$(echo $1 | cut -d : -f 2)
    shift 1
    ;;
    -q | --quiet)
    QUIET=1
    shift 1
    ;;
    -s | --strict)
    STRICT=1
    shift 1
    ;;
    -h)
    HOST="$2"
    if [[ $HOST == "" ]]; then break; fi
    shift 2
    ;;
    --host=*)
    HOST="${1#*=}"
    shift 1
    ;;
    -p)
    PORT="$2"
    if [[ $PORT == "" ]]; then break; fi
    shift 2
    ;;
    --port=*)
    PORT="${1#*=}"
    shift 1
    ;;
    -t)
    TIMEOUT="$2"
    if [[ $TIMEOUT == "" ]]; then break; fi
    shift 2
    ;;
    --timeout=*)
    TIMEOUT="${1#*=}"
    shift 1
    ;;
    --)
    shift
    break
    ;;
    *)
    usage
    ;;
  esac
done

if [[ "$HOST" == "" || "$PORT" == "" ]]; then
  echoerr "Error: you need to provide a host and port to test."
  usage
fi

wait_for

if [[ "$STRICT" == 1 ]]; then
  if ! nc -z "$HOST" "$PORT"; then
    echoerr "$0: strict mode, refusing to execute subprocess"
    exit 1
  fi
fi

if [[ $# -gt 0 ]]; then
  exec "$@"
else
  exit 0
fi
