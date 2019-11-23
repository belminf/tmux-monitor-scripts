#!/usr/bin/env bash

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

set_tmux_option() {
  tmux set-option -gq "$1" "$2"
}

update_tmux_option() {
  local option="$1"
  local interpolated original_option
  original_option="$(get_tmux_option "$option")"
  interpolated="$(do_interpolation "$original_option")"
  set_tmux_option "$option" "$interpolated"
}

do_interpolation() {
  local interpolated="$1"
  local monitor_tag="monitor_scripts_output"
  local script_path="${HOME}/.tmux/monitors"
  local all_monitor_output=""
  local monitor_string monitor_sep monitor_format
  monitor_sep="$(get_tmux_option "@monitor_scripts_sep" " | ")"
  [ "$monitor_sep" = "NONE" ] && monitor_sep=""
  monitor_format="$(get_tmux_option "@monitor_scripts_format" "#{monitor_name}: #{monitor_output}")"
  for f in "${script_path}"/*.sh; do
    [ ! -x "$f" ] && continue
    script_name="$(basename -- "$f")"
    monitor_name="${script_name%.*}"
    [ -z "$monitor_name" ] && continue
    monitor_string="$monitor_format"
    monitor_string="${monitor_string/\#\{monitor_name\}/$monitor_name}"
    monitor_string="${monitor_string/\#\{monitor_output\}/#($f)}"
    if [ -z "$all_monitor_output" ]; then
      all_monitor_output="$monitor_string"
    else
      all_monitor_output="${all_monitor_output}${monitor_sep}${monitor_string}"
    fi
  done
  echo "${interpolated/\#\{${monitor_tag}\}/${all_monitor_output}}"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main
