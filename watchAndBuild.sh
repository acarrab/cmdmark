#!/bin/bash



lastState=''

while true; do
  newState=$(cat ./src/* ./install.sh | tr '\0' '\n')
  if [[ "$lastState" !=  "$newState" ]]; then
	  lastState="$newState"
	  ./install.sh
  fi
  sleep 2
done
