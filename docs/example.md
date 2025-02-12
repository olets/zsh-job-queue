# Example

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
  local id=$(job-queue generate-id)
  local scope=$funcstack[1] # name of the immediate parent function, here `"myfunction"`
  job-queue push myfunction $id

  # if there any jobs ahead of this one in the 'myfunction' queue
  # (ahead of is id generated before this one
  # and job pushed to the queue before this one),
  # the script pauses here until they have been remove from the queue

  local content=$(cat $file 2>dev/null)
  rm $file 2>/dev/null
  echo $1 > $file
  echo $content >> $file

  job-queue pop $scope $id
}

myfunction $RANDOM
```

Now if you open many terminals in quick succession you'll add one line to `myfile.txt` per terminal (note that in this example the order of the added lines is not guaranteed.)
