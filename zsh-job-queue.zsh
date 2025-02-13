#!/usr/bin/env zsh

# Cross-session job queues manager for zsh
# https://zsh-job-queue.olets.dev
# v2.0.1
# Copyright (c) 2024 Henry Bley-Vroman
#
# Usage:
#
# ```
# id=$(job-queue push <scope> [<job-description> [<support-ticket-url>]])
# # waits for its turn in the <scope> queue
# # do some work
# job-queue pop $id
# ```
#
# Optionally include a suffix argument when sourcing this file
#   source path/to/zsh-job-queue.zsh <suffix>
# The suffix is appended to the names of the file's exported functions.
# This can be used, for instance, to distinguish multiple copies
# of zsh-job-queue.
#
# In .zshrc:
#   source path/to/zsh-job-queue/zsh-job-queue.zsh
# In a plugin which bundles its own (e.g. Git submodule or subtree) copy:
#   source ./zsh-job-queue/zsh-job-queue.zsh __my-plugin
#
# Refer to zsh-abbr for an example of the latter

function _job_queue:init"${1:-}"() { # this quotation mark to fix syntax highlighting "
  zmodload zsh/datetime
  zmodload -i zsh/sched

  # Log debugging messages?
  typeset -gi JOB_QUEUE_DEBUG=${JOB_QUEUE_DEBUG:-0}

  # How old does a job have to be to be considered timed out?
  typeset -gi JOB_QUEUE_TIMEOUT_AGE_SECONDS=${JOB_QUEUE_TIMEOUT_AGE_SECONDS:-30}

  # Temp dir
  typeset -g _job_queue_tmpdir=${${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue}%/}/

  # Temp dir for privileged users
  if [[ ${(%):-%#} == '#' ]]; then
    _job_queue_tmpdir=${${JOB_QUEUE_PRIVILEGED_TEMPDIR:-${JOB_QUEUE_TMPDIR:-${${TMPDIR:-/tmp}%/}/zsh-job-queue-privileged-users}}%/}/
  fi
}

function job-queue"${1:-}"() { # this quotation mark to fix syntax highlighting "
  emulate -LR zsh

  {
    # gets unfunction'd
    function _job_queue:debugger() {
      emulate -LR zsh

      (( JOB_QUEUE_DEBUG )) && 'builtin' 'echo' - $funcstack[2]
    }

    # gets unfunction'd
    function _job_queue:help() {
      emulate -LR zsh

      'command' 'man' job-queue 2>/dev/null || 'command' 'man' ${0:A:h}/man/man1/job-queue.1
    }

    # _job_queue:pop
    # gets unfunction'd
    #
    # @param {string} scope
    # @param {string} job_id
    function _job_queue:pop() {
      emulate -LR zsh

      _job_queue:debugger

      local scope
      local job_id

      scope=$1 # todo
      job_id=$2

      'command' 'rm' $_job_queue_tmpdir${scope}/$job_id &>/dev/null
    }

    # _job_queue:push
    # gets unfunction'd
    #
    # @param {string} scope
    # @param {string} job_id
    # @param {string} job_description
    # @param {string} support_ticket_url
    function _job_queue:push() {
      emulate -LR zsh

      {
        _job_queue:debugger

        local next_job_age
        local next_job_id
        local next_job_path
        local job_description
        local job_id
        local scope
        local support_ticket_url

        job_id=$(_job_queue:generate-id)

        scope=$1
        job_description=$2
        support_ticket_url=$3

        # gets unfunction'd
        function _job_queue:push:add_job() {
          _job_queue:debugger

          if ! [[ -d $_job_queue_tmpdir${scope} ]]; then
            mkdir -p $_job_queue_tmpdir${scope}
          fi

          'builtin' 'echo' $job_description > $_job_queue_tmpdir${scope}/$job_id
          'builtin' 'echo' $support_ticket_url >> $_job_queue_tmpdir${scope}/$job_id
        }

        # gets unfunction'd
        function _job_queue:push:next_job_id() {
          # cannot support debug message

          'command' 'ls' -t $_job_queue_tmpdir${scope} | 'command' 'tail' -1
        }

        # gets unfunction'd
        function _job_queue:push:handle_timeout() {
          _job_queue:debugger

          local msg
          local -a msg_data
          local msg_description
          local msg_url

          next_job_path=$_job_queue_tmpdir${scope}/$next_job_id

          msg_data=( ${(f)"$('command' 'cat' $next_job_path)"} ) # " this paren for syntax highlighting )
          msg_description=$msg_data[1]
          msg_url=$msg_data[2]

          'builtin' 'echo' "job-queue: A job added at $(strftime '%T %b %d %Y' ${${next_job_id%%-*}%%.*}) has timed out."

          msg="The job was related to \`$scope\`"

          if [[ -n $msg_description ]]; then
            msg+="'s \`$msg_description\`"
          fi

          msg+="."

          'builtin' 'echo' $msg
          'builtin' 'echo' "This could be the result of manually terminating an activity in \`$scope\`."

          if [[ -n $msg_url ]]; then
            'builtin' 'echo' "If you believe it reflects bug in \`$scope\`, please report it at $msg_url"
          fi

          'builtin' 'echo'

          'command' 'rm' $next_job_path &>/dev/null
        }

        function _job_queue:push:remove_scheduled_event() {
          _job_queue:debugger

          # Remove existing event, so that multiple calls to
          # _job_queue:push:remove_scheduled_event work OK
          typeset -i i=${"${(@)zsh_scheduled_events#*:*:}"[(I)_job_queue:push:wait_turn:$job_id]}
          (( i )) && sched -$i
        }

        # gets unfunction'd
        function _job_queue:push:wait_turn() {
          _job_queue:debugger
          next_job_id=$(_job_queue:push:next_job_id)

          while [[ $next_job_id != $job_id ]]; do
            _job_queue:push:remove_scheduled_event

            next_job_id=$(_job_queue:push:next_job_id)

            next_job_age=$(( $EPOCHREALTIME - ${next_job_id%%-*} ))

            if ((  $next_job_age > $JOB_QUEUE_TIMEOUT_AGE_SECONDS )); then
              _job_queue:push:handle_timeout
              return 1
            fi

            [[ $next_job_id != $job_id ]] && {
              sched +1 _job_queue:push:wait_turn:$job_id
            }
          done
        }

        _job_queue:push:add_job
        _job_queue:push:wait_turn
        'builtin' 'echo' - $job_id
      } always {
        unfunction -m _job_queue:push:add_job
        unfunction -m _job_queue:push:next_job_id
        unfunction -m _job_queue:push:handle_timeout
        unfunction -m _job_queue:push:wait_turn
      }
    }

    # gets unfunction'd
    function _job_queue:generate-id() {
      emulate -LR zsh

      # cannot support debug message

      local uuid

      uuid=$('command' 'uuidgen' 2>/dev/null || cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c36)

      'builtin' 'echo' - $EPOCHREALTIME--$uuid
    }

    # gets unfunction'd
    function _job_queue:version() {
      emulate -LR zsh

      'builtin' 'printf' "zsh-job-queue version %s\n" 2.0.1
    }

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
  } always {
    unfunction -m _job_queue:debugger
    unfunction -m _job_queue:help
    unfunction -m _job_queue:pop
    unfunction -m _job_queue:push
    unfunction -m _job_queue:generate-id
    unfunction -m _job_queue:version
  }
}

_job_queue:init${1:-}
unfunction -m _job_queue:init${1:-}
