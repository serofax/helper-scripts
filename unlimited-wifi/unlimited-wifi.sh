#!/bin/bash
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi
while :
do
    mainfacturePrefix="78:4f:43"
    randomSuffix=$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/.$//')
    newMACAddress="$mainfacturePrefix:$randomSuffix"
    echo "Your new MAC-Address will be $newMACAddress"
	ifconfig en0 ether $newMACAddress
    echo "Restart nework interface"
    ifconfig en0 down
    ifconfig en0 up
    currentMACAddress=$(ifconfig en0 | awk '/ether/{print $2}')
    if [ "$newMACAddress" = "$currentMACAddress" ]
        then echo "MAC-Address was changed successfully"
        else echo "MAC-Address change failed"
    fi
	sleep 600 # every 10 minutes
done
