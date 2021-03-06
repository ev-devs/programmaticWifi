#!/bin/bash
# Proper header for a Bash script.

#Checks the network links to a given computer. If there is an ethernet connected then the eth0 interface will register as up.
#Same with wifi where if there is a wifi connection the wlan0 interface will register as up.
#This is primarily used for ethernet as if there are no direct connections on wlan0 BUT if there are avilable networks
#then the ip link show will reveal the wlan0 as down which is not good because this is like us saying there are no connections
#WHEN in fact there very well could be.
LINKS=$(ip link show | grep 'state UP')
#Defines and sets flags for eth0 and wlan0
WFLAG="false"
EFLAG="false"

#Scans the wlan0 interface for Wi-Fi access points, specifically signling out the name, Quality and whether the access point needs a password
WLAN0=$(sudo iwlist wlan0 scan | grep 'ESSID\|Quality\|Encryption')
#Checks if there is an "up" status tied to eth0
ETH0=$(echo $LINKS | grep "eth0")
#If an ethernet is connected to the first ethernet interface (otherwise known as eth0) then the ETH0 variabel will not be "" and the "if" body will be executed
if [ "$ETH0" != "" ]
then
   printf "Ethernet registered on eth0\n\n"
fi
#If there are networks then the WLAN0 variable will not be "" and the if body will be executed
if [ "$WLAN0" != "" ]
then
   printf "Wi-Fi access points registered on wlan0\n"

   W=$(sudo iwlist wlan0 scan | grep 'ESSID\|Quality\|Encryption' | tr '=' 'x')
   W="${W//Qualityx/=^Quality:}"
   W="${W//Signal\ levelx/Signal-level:}"
   #Makes the output of the command a string. Before doing this $W size is 864, after $WIFICONS size is 363
   WIFICONS=$(echo $W)
   #Spits out $WIFICONS, takes all the ':' and makes them '\n', sorts by unique and gets rid of duplicates, replaces '\n' with '~'
   T=$(echo "$WIFICONS" | tr '=' '\n' | sort -u | tr '\n' '~')
   #Changes the internal field separator to be '~'
   IFS='~' read -r -a array <<< "$T"
   #lists the access points
   for element in "${array[@]}"
   do
      echo "$element"
   done
fi
