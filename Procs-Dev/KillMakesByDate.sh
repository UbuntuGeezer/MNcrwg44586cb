#!/bin/bash
# KillMakesByDate.sh - Kill shell by inserting illegal command at start.
#	9/2/23.	wmk.
#
# Usage. bash  KillMakesByDate.sh <path> <date>
#
#	path = path to shell files; only processes files
#		with '.sh' file extension
#	<date> = (optional) if specified, all shells whose "modified" date
#		precedes this date will be killed "yyyy-mm-dd"
#
# Entry.  <path>/Make* files exist
#
# Exit.  <path>Make files modified with line 
#			"($)(error out-of-date)"
#
# Modification History.
# ---------------------
# 9/2/23.	wmk.	original code; adapted from KillShell.
#
# Notes. This shell is an alternative way of preventing *make* files from
# executing when they have gone out-of-date (usually because of referenced
# paths changing or system file folder restructuring).
# This process arose to further enforce version control when shells attempt
# to execute *make* files.
#
# P1=<path>, P2=<before-date>
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "KillPath <path> [<before-date>] missing parameter(s)"
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
killpath=$P1
if [ "$killpath" == "./" ];then
 msgsep=
else
 msgsep=/
fi
# get today's date *TODAY.
if [ -z "$TODAY" ];then
. $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev/SetToday.sh
echo "TODAY is '$TODAY'"
fi
# if P2 unspecified, use today's date.
b4date=$P2
if [ -z "$b4date" ];then
 case $- in
 "*i*")
 echo "  KillMakesByDate <path> [<before-date>] default date is TODAY"
 read -p "   OK to proceed (y/n)? :"
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  echo "KillMakesByDate terminated at user request."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
 fi
 ;;
 *)
 ;;
 esac
 b4date=$TODAY
fi
# create list of Make* files from P1 path.
pushd ./ > /dev/null
binpath=$WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev
cd $killpath
ls -lh Make* > $TEMP_PATH/fullmakes.txt
# use mawk to pare list down to files meeting date criteria.
mawk -v testdate=$b4date -f $binpath/awkkilldates.txt $TEMP_PATH/fullmakes.txt\
 > $TEMP_PATH/datedmakes.txt
echo " cat *TEMP_PATH/datedshells.txt for file list..."
read -p "Enter ctrl-c when testing...: "
# now loop on files meeting date criteria.
if test -s $TEMP_PATH/datedmakes.txt;then
 dfile=$TEMP_PATH/datedmakes.txt
 while read -e;do
  fn=$REPLY
  echo "  processing $killpath$msgsep$fn..."
  $binpath/KillMake.sh $fn $killpath
 done < $dfile
fi		# end non-empty datedlist
popd > /dev/null
# end KillMakesByDate.sh
