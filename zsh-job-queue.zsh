#!/usr/bin/env zsh

# Cross-session job queue manager for zsh
# https://github.com/olets/zsh-job-queue
# v1.0.0
# Copyright (c) 2024-present Henry Bley-Vroman

# Log debugging messages?
typeset -gi JOB_QUEUE_DEBUG=${JOB_QUEUE_DEBUG:-0}

typeset -g _job_queue_tmpdir=${${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue}%/}/
if [[ ${(%):-%#} == '#' ]]; then
  _job_queue_tmpdir=${${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue-privileged-users}%/}/
fi

_job_queue:debugger() {
  emulate -LR zsh

  (( JOB_QUEUE_DEBUG )) && 'builtin' 'echo' - $funcstack[2]
}

function _job_queue:help() {
  emulate -LR zsh

  'command' 'man' job-queue 2>/dev/null || 'command' 'man' ${0:A:h}/man/man1/job-queue.1
}

# _job_queue:pop
#
# @param {string} cmd
# @param {string} job_id
function _job_queue:pop() {
  emulate -LR zsh

  _job_queue:debugger

  local cmd
  local job_id

  cmd=$1 # todo
  job_id=$2

  'command' 'rm' $_job_queue_tmpdir${cmd}/$job_id &>/dev/null
}

# _job_queue:push
#
# @param {string} cmd
# @param {string} job_id
# @param {string} job_description
# @param {string} support_ticket_url
function _job_queue:push() {
  emulate -LR zsh

  {
    _job_queue:debugger

    local cmd
    local next_job_age
    local next_job_id
    local next_job_path
    local job_description
    local job_id
    local job_path
    local support_ticket_url
    local timeout_age

    cmd=$1
    job_id=$2
    job_description=$3
    support_ticket_url=$4
    timeout_age=30 # seconds

    # gets unfunction'd
    function _job_queue:push:add_job() {
      _job_queue:debugger

      if ! [[ -d $_job_queue_tmpdir${cmd} ]]; then
        mkdir -p $_job_queue_tmpdir${cmd}
      fi

      'builtin' 'echo' $job_description > $_job_queue_tmpdir${cmd}/$job_id
    }

    # gets unfunction'd
    function _job_queue:push:next_job_id() {
      # cannot support debug message

      'command' 'ls' -t $_job_queue_tmpdir${cmd} | tail -1
    }

    # gets unfunction'd
    function _job_queue:push:handle_timeout() {
      _job_queue:debugger

      next_job_path=$_job_queue_tmpdir${cmd}/$next_job_id

      'builtin' 'echo' "job-queue: A job added at $(strftime '%T %b %d %Y' ${${next_job_id%%-*}%%.*}) has timed out."
      'builtin' 'echo' "The job was related to \`$cmd\`'s \`$(cat $next_job_path)\`."
      'builtin' 'echo' "This could be the result of manually terminating an activity in \`$cmd\`."

      if [[ -n $support_ticket_url ]]; then
        'builtin' 'echo' "If you believe it reflects bug in \`$cmd\`, please report it at $support_ticket_url"
      fi
      
      'builtin' 'echo'

      'command' 'rm' $next_job_path &>/dev/null
    }

    # gets unfunction'd
    function _job_queue:push:wait_turn() {
      next_job_id=$(_job_queue:push:next_job_id)

      while [[ $next_job_id != $job_id ]]; do
        next_job_id=$(_job_queue:push:next_job_id)

        next_job_age=$(( $EPOCHREALTIME - ${next_job_id%%-*} ))

        if ((  $next_job_age > $timeout_age )); then
          _job_queue:push:handle_timeout
        fi

        sleep 0.01
      done
    }

    _job_queue:push:add_job
    _job_queue:push:wait_turn
  } always {
    unfunction -m _job_queue:push:add_job
    unfunction -m _job_queue:push:next_job_id
    unfunction -m _job_queue:push:handle_timeout
    unfunction -m _job_queue:push:wait_turn
  }
}

function _job_queue:generate-id() {
  emulate -LR zsh

  # cannot support debug message
  
  local uuid

  uuid=$('command' 'uuidgen' 2>/dev/null || cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c36)

  'builtin' 'echo' $EPOCHREALTIME--$uuid
}

function _job_queue:version() {
  emulate -LR zsh

  'builtin' 'printf' "zsh-job-queue version %s\n" 1.0.0
}

function job-queue() {
  emulate -LR zsh

  for opt in "$@"; do
    case $opt in
      --help|\
      help)
        _job_queue:help
        return
        ;;
      --version|\
      -v)
        _job_queue:version
        return
        ;;
      generate-id)
        _job_queue:generate-id
        return
        ;;
      pop)
        shift
        _job_queue:pop $@
        return
        ;;
      push)
        shift
        _job_queue:push $@
        return
        ;;
      *)
        'builtin' 'echo' "job-queue: Invalid option $opt"
        return 1
        ;;
    esac
  done
}

job-queue