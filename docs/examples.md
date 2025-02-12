# Examples

## Proof of concept

1. Open two terminals.

1. In the first, type _but do not accept_

   ```shell
   id=$(job-queue push testing); sleep 10; job-queue pop testing $id; echo first job done at $(date)
   ```

1. In the second, type _but do not accept_

   ```shell
   id=$(job-queue push testing); job-queue pop testing $id; echo second job done at $(date)
   ```

1. Accept the first terminal's command, and immediately accept the second terminal's command. See that the second terminal's command is blocked (waits for) the first terminal's.

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
  local file=~/myfile.txt
  local scope=$funcstack[1] # name of the immediate parent function, here `"myfunction"`
  local id=$(job-queue push myfunction)

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
