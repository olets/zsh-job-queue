#!/usr/bin/env zsh

# https://github.com/olets/zsh-job-queue

# Log debugging messages?
typeset -gi JOB_QUEUE_DEBUG=${JOB_QUEUE_DEBUG:-0}

typeset -g _job_queue_tmpdir=${${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue}%/}/
if [[ ${(%):-%#} == '#' ]]; then
  _job_queue_tmpdir=${${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue-privileged-users}%/}/
fi

# _job_queue:pop
_job_queue:debugger() {
  emulate -LR zsh

  (( JOB_QUEUE_DEBUG )) && 'builtin' 'echo' - $funcstack[2]
}

# _job_queue:pop
#
# @param {string} cmd
# @param {string} job_name
function _job_queue:pop() {
  emulate -LR zsh

  _job_queue:debugger

  local cmd
  local job_name

  cmd=$1 # todo
  job_name=$2

  'command' 'rm' $_job_queue_tmpdir${cmd}/$job_name &>/dev/null
}

# _job_queue:push
#
# @param {string} cmd
# @param {string} job_name
# @param {string} job_description
# @param {string} support_ticket_url
function _job_queue:push() {
  emulate -LR zsh

  {
    _job_queue:debugger

    local cmd
    local next_job_age
    local next_job_name
    local next_job_path
    local job_description
    local job_name
    local job_path
    local support_ticket_url
    local timeout_age

    cmd=$1
    job_name=$2
    job_description=$3
    support_ticket_url=$4
    timeout_age=30 # seconds

    # gets unfunction'd
    function _job_queue:push:add_job() {
      _job_queue:debugger

      if ! [[ -d $_job_queue_tmpdir${cmd} ]]; then
        mkdir -p $_job_queue_tmpdir${cmd}
      fi

      'builtin' 'echo' $job_description > $_job_queue_tmpdir${cmd}/$job_name
    }

    # gets unfunction'd
    function _job_queue:push:next_job_name() {
      # cannot support debug message

      'command' 'ls' -t $_job_queue_tmpdir${cmd} | tail -1
    }

    # gets unfunction'd
    function _job_queue:push:handle_timeout() {
      _job_queue:debugger

      next_job_path=$_job_queue_tmpdir${cmd}/$next_job_name

      'builtin' 'echo' "job-queue: A job added at $(strftime '%T %b %d %Y' ${next_job_name%%.*}) has timed out."
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
      next_job_name=$(_job_queue:push:next_job_name)

      while [[ $next_job_name != $job_name ]]; do
        next_job_name=$(_job_queue:push:next_job_name)

        next_job_age=$(( $EPOCHREALTIME - ${next_job_name%-*} ))

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
    unfunction -m _job_queue:push:next_job_name
    unfunction -m _job_queue:push:handle_timeout
    unfunction -m _job_queue:push:wait_turn
  }
}

function _job_queue:get-name() {
  emulate -LR zsh

  # cannot support debug message

  'builtin' 'echo' $EPOCHREALTIME
}

function job-queue() {
  emulate -LR zsh

  for opt in "$@"; do
    case $opt in
      get-name)
        _job_queue:get-name
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
        'builtin' 'echo' "Invalid option: $opt"
        return 1
        ;;
    esac
  done
}

job-queue