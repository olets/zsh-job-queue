# Examples

## Proof of concept

1. Open three terminals.

1. In the first, type _but do not accept_

   ```shell
   REPLY=; job-queue push one-scope; id=$REPLY; sleep 20; job-queue pop one-scope $id; echo first job done at $(date)
   ```

1. In the second, type _but do not accept_

   ```shell
   REPLY=; job-queue push one-scope; id=$REPLY; job-queue pop one-scope $id; sleep 1; echo second job done at $(date)
   ```

1. In the third, type _but do not accept_

   ```shell
   REPLY=; job-queue push another-scope; id=$REPLY; sleep 5; job-queue pop another-scope $id; echo third job done at $(date)
   ```

1. In the fourth, type _but do not accept_

   ```shell
   REPLY=; job-queue push another-scope; id=$REPLY; job-queue pop another-scope $id; sleep 1; echo fourth job done at $(date)   ```

1. Accept the first terminal's command, then second terminal's command, then the third terminal's command, then the fourth terminal's, all quickly one after the other in that order.

1. Confirm that the terminals complete their commands in the order terminal 3, terminal 4, terminal 1, terminal 2. Terminals 1 and 2 used the same global queue as each other, as did terminals 3 and 4. Terminal 4 waited for terminal 3, and terminal 2 waited for terminal 1.

## Closer to real life

zsh-job-queue is helpful if have a script that destructively modifies a file, you want to support running the script in multiple terminals in quick succession, and you want to make sure that none of the runs' changes are lost.

Don't do something like

```shell
# .zshrc

myfunction() {
  local file=~/myfile.txt
  local content=$(cat $file 2>dev/null)
  rm $file 2>/dev/null
  echo $1 > $file
  echo $content >> $file
}

myfunction $RANDOM
```

because if you open three terminals in quick succession it's possible you'll end up adding just one or two lines to `myfile.txt` when you expect to add three.

Instead, do something like

```shell
# .zshrc

# load zsh-job-queue

myfunction() {
  local REPLY
  local file=~/myfile.txt
  local scope=$funcstack[1] # name of the immediate parent function, here `"myfunction"`

  job-queue push myfunction

  local id=$REPLY

  # if there any jobs ahead of this one in the 'myfunction' queue
  # the script pauses here until they have been removed from the queue

  local content=$(cat $file 2>dev/null)
  rm $file 2>/dev/null
  echo $1 > $file
  echo $content >> $file

  job-queue pop $scope $id
}

myfunction $RANDOM
```

Now if you open many terminals in quick succession you'll add one line to `myfile.txt` per terminal (note that in this example the order of the added lines is not guaranteed.)
