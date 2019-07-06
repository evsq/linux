#!/bin/bash

FILE=$1

# check argument
if [ $# -ne 1 ]; then
  echo "Provide exactly one argument"
  exit 1
fi

# check if the file exists
if [ -f $FILE ]; then
  
  # default variables
  VAR_READ="-"
  VAR_WRITE="-"
  VAR_EXEC="-"

  # check if file is readable
  if [ -r $FILE ]; then
    VAR_READ="r"
  fi

  # check if file is writeable
  if [ -w $FILE ]; then
    VAR_WRITE="w"
  fi

  # check if file is executable
  if [ -x $FILE ]; then
    VAR_EXEC="x"
  fi

  # write permissions summary to user
  echo "$FILE $VAR_READ$VAR_WRITE$VAR_EXEC"

else
  if [ -d $FILE ]; then
    echo "$FILE is a directory"
  else
    echo "$FILE does not exists"
  fi
fi
