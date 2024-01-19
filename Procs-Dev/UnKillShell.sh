#!/bin/bash
# UnKillShell.sh - UnKill shell by removing illegal command at start.
#	9/2/23.	wmk.
#
# Usage. bash  UnKillShell.sh <shell-name> [<path>]
#
#	<shell-name> = name of shell to kill (with .sh extension if applies)
#	<path> = (optional) path to <shell-name> file; default is *PWD
#
# Entry.  [<path>/]<shell-name> exists
#		 line 2 is .."out-of-date"
#
# Exit.  [<path>/]<shell-name> modified with line 
#			"ECHO <shell-name> out-of-date" removed
#		 # *TODAY   wmk. line added.
#
# Modification History.
# ---------------------
# 9/1/23.	wmk.	original code.
# 9/2/23.	wmk.	modified for MNcrwg44586.
#
# Notes. This shell is an alternative way of preventing a shell from executing
# when it has gone out-of-date (usually because of referenced paths changing).
# It became necessary for dealing with shells resident on a Windows-owned drive
# since even *sudo cannot use *chmod to change the 'x' flag (executable).
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "UnKillPath <shell-name> [<path>] missing parameter(s)"
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
killpath=$PWD
if [ ! -z "$P2" ];then
 killpath=$P2
fi
echo $killpath/$P1
if ! test -s $killpath/$P1;then
 echo " UnKillPath - $P1 is empty or non-existent."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
printf "%s\n" "/terrbase = .*\/Users\/Bill/s?\/Users\/Bill??1" > $TEMP_PATH/sedunkillsh.txt
printf "%s\n%s\n" "/out-of-date \*\*\";exit/d" "/folderbase =.*\/Users\/Bill/s?\/Users\/Bill??1" "1a# $TODAY   wmk.   \(automated\) ver2.0 path fixes." >> $TEMP_PATH/sedunkillsh.txt
if [ "$killpath" == "./" ];then
 sed -i -f $TEMP_PATH/sedunkillsh.txt $killpath$P1
else
 sed -i -f $TEMP_PATH/sedunkillsh.txt $killpath/$P1
fi
if [ $? -eq 0 ];then
 echo "UnKillShell $P1 $P2 successful."
else
 echo "UnKillShell $P1 $P2 failed."
fi
# end UnKillShell.sh
