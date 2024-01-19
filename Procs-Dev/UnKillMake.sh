#!/bin/bash
# UnKillMake.sh - UnKill Make by removing illegal command at start.
#	9/2/23.	wmk.
#
# Usage. bash  UnKillMake.sh <Make-name> [<Make>]
#
#	<Make-name> = name of Make to kill (with .sh extension if applies)
#	<path> = (optional) path to <Make-name> file; default is *PWD
#
# Entry.  [<path>/]<Make-name> exists
#		 line 2 is .."out-of-date"
#
# Exit.  [<path>/]<Make-name> modified with line 
#			"\$(error out-of-date)" removed
#		 # *TODAY   wmk. line added.
#
# Modification History.
# ---------------------
# 9/2/23.	wmk.	original code; adapted from UnKillShell.
#
# Notes. This Make "undoes" a KillMake operation by removing the
# \$(error out-of-date) line from the beginning of the *make file
# and adjusting the folderbase = Make to match ver2.0.
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "UnKillMake <Make-name> [<path>] missing parameter(s)"
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
killMake=$PWD
if [ ! -z "$P2" ];then
 killMake=$P2
fi
echo $killMake/$P1
if ! test -s $killMake/$P1;then
 echo " UnKillMake - $P1 is empty or non-existent."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
if [ -z "$b" ];then
 export b=$WINGITPATH/TerritoriesCB/MNcrwg44586/Procs-Dev
fi
if [ -z "$TODAY" ];then
 $b/SetToday.sh
fi
printf "%s\n" "/.*codebase =.*TerritoriesCB$/s?TerritoriesCB?TerritoriesCB/MNcrwg44586?1" \
  > $TEMP_PATH/sedunkillmake.txt
printf "%s\n" "/.*pathbase =.*Territories$/s?Territories?Territories/MN/CRWG/44586?1" \
  >> $TEMP_PATH/sedunkillmake.txt
printf "%s\n%s\n%s\n" "/.*(error out-of-date.*)/d" "/folderbase.*\/Users\/Bill/s?\/Users\/Bill??1" "1a# $TODAY   wmk.   \(automated\) ver2.0 Make fixes." >> $TEMP_PATH/sedunkillmake.txt
if [ "$killMake" == "./" ];then
 sed -i -f $TEMP_PATH/sedunkillmake.txt $killMake$P1

else
 sed -i -f $TEMP_PATH/sedunkillmake.txt $killMake/$P1
fi
if [ $? -eq 0 ];then
 echo "UnKillMake $P1 $P2 successful."
else
 echo "UnKillMake $P1 $P2 failed."
fi
# end UnKillMake.sh
