#!/bin/bash
# Bash presenter script by Carsten Nielsen <carsten@redpill-linpro.com>

if [ "$1" != "" ]; then
  echo "Welcome! To start just press enter...(or ? for a bit help)";
else 
  echo "Uuups! You have to define a command with a counting placeholder (?) like:
  ./show.sh \"cat path/file?.txt\"";
  exit
fi

sl=0
auto=0
time=0
ssl=1
cmd=$1
reader='read -p "(${sl})>" IN';
message=""

help='echo -e "
\e[1mh\e[0m or \e[1m?\e[0m - show this help ;-)\n
\e[1menter\e[0m - start and next\n
\e[1mf\e[0m - first page is opened\n
\e[1ms\e[0m - save actual position\n
\e[1mg\e[0m - go to saved position\n
\e[1mq\e[0m - quit the presentation\n
\e[1mauto\e[0m - start automatic presentation\n
\e[1mp\e[0m - pause automatic presentation\n"';

while true; do
  eval $reader 
  case "$IN" in
    "auto"*) 
      time=$(echo $IN | grep -o "[0-9]*")
      if [[ $time == 0 || $time == "" ]]; then 
        message="Please define a time in seconds like 'auto 300'"
      else
        auto=1
        reader='read -t ${time} -p "auto ${time}s (${sl})>" IN'
      fi
      ;;
       
    "?" | "h")
      echo "Need some help?" 
      eval $help
      continue;;
    
    "f")
      sl=1;;
      
    "s") 
      ssl=$sl;;
      
    "g")
      sl=$ssl;;
      
    "q")
      exit;;
      
    "p")
      auto=0
      reader='read -p "(${sl})>" IN';;
    
    "b")
      (( sl-- ));;
      
    [0-9]*)
      sl=$IN;;
      
    *)
      (( sl++ ));;
  esac
  if [[ $message != "" ]]; then
    echo $message
    message=""
  else
    clear;
    eval ${cmd/\?/$sl};
  fi
done;
