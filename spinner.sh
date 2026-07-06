#!/bin/bash

############################################################################################################################
# Description: Reusable Claude-style terminal spinner utility.
# Usage:
#   source ./spinner.sh
#   spinner_start "Doing something..."
#   <long running command>
#   spinner_stop            # generic success (green check)
#   spinner_stop "done"     # explicit success (green check)
#   spinner_stop "fail"     # failure (red cross) -- still returns 0 so
#                             it can be chained with `spinner_stop "fail" && ...`
############################################################################################################################

SPINNER_PID=""
SPINNER_FRAMES='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
SPINNER_DELAY=0.08

# Hide/show cursor helpers (no-ops if tput isn't available)
_spinner_cursor_hide() { tput civis 2>/dev/null; }
_spinner_cursor_show() { tput cnorm 2>/dev/null; }

# Make sure we never leave a hidden cursor or an orphaned spinner process
# behind if the script exits unexpectedly (Ctrl+C, error, etc.)
_spinner_cleanup() {
  if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
    kill "$SPINNER_PID" 2>/dev/null
    wait "$SPINNER_PID" 2>/dev/null
  fi
  _spinner_cursor_show
}
trap _spinner_cleanup EXIT INT TERM

# spinner_start "message"
spinner_start() {
  local message="${1:-Loading...}"

  # If a spinner is already running, stop it first
  if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
    kill "$SPINNER_PID" 2>/dev/null
    wait "$SPINNER_PID" 2>/dev/null
  fi

  _spinner_cursor_hide

  (
    local i=0
    local len=${#SPINNER_FRAMES}
    while true; do
      printf "\r\e[36m%s\e[0m %s" "${SPINNER_FRAMES:$((i % len)):1}" "$message"
      i=$((i + 1))
      sleep "$SPINNER_DELAY"
    done
  ) &

  SPINNER_PID=$!
  disown "$SPINNER_PID" 2>/dev/null
}

# spinner_stop ["done"|"fail"|<custom label>]
# Always returns 0, so `spinner_stop "fail" && <next command>` works as intended.
spinner_stop() {
  local status="${1:-done}"

  if [[ -n "$SPINNER_PID" ]] && kill -0 "$SPINNER_PID" 2>/dev/null; then
    kill "$SPINNER_PID" 2>/dev/null
    wait "$SPINNER_PID" 2>/dev/null
  fi
  SPINNER_PID=""

  _spinner_cursor_show

  # Clear the spinner line
  printf "\r\033[K"

  case "$status" in
    done|success)
      printf "\e[32m✔ Done\e[0m\n"
      ;;
    fail|failed|error)
      printf "\e[31m✘ Failed\e[0m\n"
      ;;
    "")
      : # silent stop, no symbol
      ;;
    *)
      printf "\e[33m%s\e[0m\n" "$status"
      ;;
  esac

  return 0
}
