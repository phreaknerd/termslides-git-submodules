#!/bin/bash
# Bash presenter script by Carsten Nielsen <carsten@redpill-linpro.com>

if [ "$1" != "" ]; then
  echo "Welcome! To start just press enter...(or ? for a bit help)";
else 
  echo "Uuups! You have to define a command with a counting placeholder like:
  ./show.sh \"cat path/file?.txt\"";
  exit;
fi;

sl=0;
osl=$sl;
ssl=$sl;
cmd=$1

help='echo -e "
\e[1mh\e[0m or \e[1m?\e[0m - show this help ;-)\n
\e[1menter\e[0m - start and next\n
\e[1mf\e[0m - go to first page\n
\e[1ms\e[0m - save actual position\n
\e[1mp\e[0m - proceed at saved position\n
\e[1mq\e[0m - quit the presentation\n"';

while [ 1 ]; do 
  read -p "($sl)>" IN; 
  if [ "$IN" = "" ]; then 
    let sl=$sl+1;
  elif [[ "$IN" = "h" || "$IN" = "?" ]]; then
    echo "Need some help?"; 
    eval $help;
    continue;
  elif [ "$IN" = "b" ]; then 
    let sl=$sl-1;
  elif [ "$IN" = "f" ]; then 
    let sl=1;
  elif [ "$IN" = "s" ]; then 
    ssl=$sl;
  elif [ "$IN" = "p" ]; then 
    let sl=$ssl;
  elif [ "$IN" = "q" ]; then 
    exit; 
  else 
    let sl=$IN; 
  fi;
  clear;
  eval ${cmd/\?/$sl};
done;
