#!/bin/bash
# UnKillMake.sh - UnKill multiple *make files removing error at start.
#	9/2/23.	wmk.
#
# Usage. bash  UnKillMultMakes.sh <path>
#
#	<path> = (optional) path to <Make-name> file; default is *PWD
#
# Entry.  [<path>/]<Make-name> exists
#		 line 2 is .."(error out-of-date)"
#
# Exit.  [<path>/]<Make-name> modified with line 
#			"\$(error out-of-date)" removed
#		 # *TODAY   wmk. line added.
#
# Modification History.
# ---------------------
# 9/2/23.	wmk.	original code; adapted from UnKillMake.
#
# Notes. This Make "undoes" all KillMake operations on *make files in the
# specified <path> by removing the
# \$(error out-of-date) line from the beginning of the *make file
# and adjusting the folderbase = Make to match ver2.0.
#
P1=$1
if [ -z "$P1" ];then
 echo "UnKillMultMake <path> missing parameter(s)"
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
killMake=$PWD
if [ ! -z "$P1" ];then
 killMake=$P1
fi
echo $killMake
pushd ./ > /dev/null
if [ "$killmake" != "./" ];then
 cd $killMake
fi
echo $PWD
t=$TEMP_PATH
grep -rle "error.*out-of-date" --include "Make*" > $t/killedmakes.txt
echo "  back from grep..."
if [ $? -ne 0 ];then
 echo " no out-of-date files found - UnKillMultMakes.sh exiting."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
if [ 1 -eq 0 ];then
 cat $t/killedmakes.txt
 popd > /dev/null
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
# loop on TEMP_PATH/killedmakes.txt.
if [ 1 -eq 0 ];then
 cat $t/killedmakes.txt
 read -p "Enter ctrl-c to interrupt :"
 touch $t/killedmakes.txt	# rewind killedmakes.txt
fi
b=$WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev
file=$t/killedmakes.txt
while read -e;do
 fn=$REPLY
 echo "   processing $fn ..."
 $b/UnKillMake.sh $fn
 if [ $? -eq 0 ];then
  echo "UnKillMake $fn successful."
 else
  echo "UnKillMake $fn failed."
 fi
done < $file
# end UnKillMake.sh
