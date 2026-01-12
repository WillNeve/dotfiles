#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BORDER_LINE_THICK="================================================"
BORDER_LINE="--------------------------------"
NEW_LINE="\n"

print_border() {
  if [ "$QUIET" != true ]; then
    if [ "$1" = "thick" ]; then
      echo "$BORDER_LINE_THICK"
    else
      echo "$BORDER_LINE"
    fi
  fi
}

print_new_line() {
  if [ "$QUIET" != true ]; then
    echo -e "$NEW_LINE"
  fi
}

print_title() {
  if [ "$QUIET" != true ]; then
    print_border "thick"
    local color="$(echo "$2" | tr '[:lower:]' '[:upper:]')"
    case "$color" in
      "RED") echo -e "${RED}$1${NC}" ;;
      "GREEN") echo -e "${GREEN}$1${NC}" ;;
      "YELLOW") echo -e "${YELLOW}$1${NC}" ;;
      "BLUE") echo -e "${BLUE}$1${NC}" ;;
      "WHITE") echo -e "${WHITE}$1${NC}" ;;
      *) echo -e "${CYAN}$1${NC}" ;;
    esac
    print_border "thick"
  fi
}

print_subtitle() {
  if [ "$QUIET" != true ]; then
    print_border
    local color="$(echo "$2" | tr '[:lower:]' '[:upper:]')"
    case "$color" in
      "RED") echo -e "${RED}$1${NC}" ;;
      "GREEN") echo -e "${GREEN}$1${NC}" ;;
      "YELLOW") echo -e "${YELLOW}$1${NC}" ;;
      "CYAN") echo -e "${CYAN}$1${NC}" ;;
      "WHITE") echo -e "${WHITE}$1${NC}" ;;
      *) echo -e "${BLUE}$1${NC}" ;;
    esac
    print_border
  fi
}
