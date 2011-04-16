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
message=""
mes=""
reader='read -sn1 -p "${mes}(${sl})>" IN';
esc=$(eval 'echo -en "\e"');
help='echo -e "
\e[1mh\e[0m or \e[1m?\e[0m - show this help ;-)\n
\e[1menter\e[0m - start and next\n
\e[1mf\e[0m - first page is opened\n
\e[1ms\e[0m - save actual position\n
\e[1mg\e[0m - go to saved position\n
\e[1mq\e[0m - quit the presentation\n
\e[1ma\e[0m - start automatic presentation\n
\e[1mp\e[0m - pause automatic presentation\n

You can use PgUp, PgDn, left, right, up, down and numeric values to jump to slides.\n"';

while true; do
  eval $reader
  mes=""
  case "$IN" in
    $esc)
      IN=""
      while read -sn1 a; do
        case $a in
          "A" | "B" | "C" | "D" | "E" | "~" | "H" | "F" | "S" | "R" | "Q" | "P")
            IN=$IN$a
            break;;
          *)
            IN=$IN$a;;
        esac
      done;;
    [0-9]*)
      echo -n $IN
      while read -sn1 a; do
        echo -n $a
        case $a in
          [0-9]*)
            IN=$IN$a;;
          *)
            break;;
        esac
      done;;
  esac
  echo $IN
  case "$IN" in
    "a") 
      read -p "Time in seconds:" time
      if [[ $time == 0 || $time == "" ]]; then 
        message="Error: Please define a numeric value greater than 0."
      else
        auto=1
        reader='read -t ${time} -sn1 -p "auto ${time}s (${sl})>" IN'
      fi
      ;;
    "?" | "h")
      echo "Need some help?" 
      eval $help
      continue;;
    
    "f" | "OH")
      sl=1;;
      
    "s")
      mes="Position ${sl} saved. "
      ssl=$sl;;
      
    "g")
      mes="Opened stored slide. "
      sl=$ssl;;
      
    "q")
      echo "Bye bye!"
      exit;;
      
    "p")
      mes="Automatic paused. "
      auto=0
      reader='read -sn1 -p "${mes}(${sl})>" IN';;
    
    "[B" | "[D" | "[6~" | "b")
      (( sl-- ));;
      
    [0-9]*)
      sl=$IN
      mes="Jumped to slide ${sl}. ";;
      
    "[A" | "[C" | "[5~" | *)
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
