#!/bin/bash
# KillGShellsByDate.sh - Kill Project-Geany shells by inserting illegal command at start.
#	9/2/23.	wmk.
#
# Usage. bash  KillGShellsByDate.sh  <date>
#
#	<date> = (optional) if specified, all shells whose "modified" date
#		precedes this date will be killed "yyyy-mm-dd"; default is *TODAY.
#
# Entry.  *PWD = some ../Projects-Geany folder
#		  */*.sh shell files present
#
# Calls. KillShellsByDate.
#
# Exit.  <path>*.sh files modified with line 
#			"ECHO <shell-name> out-of-date;exit 1"
#
# Modification History.
# ---------------------
# 9/1/23.	wmk.	original code.
# 9/2/23.	wmk.	./ prefix added when passing path to KillShellsByDate.
# 9/2/23.	wmk.	modified for MNcrwg44586.
#
# Notes. This shell loops on all of the Projects-Geany folders killing
# all of the *.sh files to prevent them from
# executing when they have gone out-of-date (usually because of referenced
# paths changing or system file folder restructuring).
# This process became necessary for dealing with shells resident on a
# Windows-owned drive since even *sudo cannot use *chmod to change the 'x'
# flag (executable).
#
# P1=<before-date>
P1=$1
if [ -z "$P1" ];then
 case $- in
 "*i*")
 echo "KillGShellsByDate [<before-date>] - using *TODAY for default."
 read -p "  OK to coninue (y/n): "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  echo "KillGShellsByDate stopped by user."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
 fi
 ;;
 *)
 ;;
 esac
 b4date=$TODAY
fi		# <before-date> unspecified
# get today's date *TODAY.
if [ -z "$TODAY" ];then
. $WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev/SetToday.sh
echo "TODAY is '$TODAY'"
fi
# if P1 unspecified, use today's date.
b4date=$P1
if [ -z "$b4date" ];then
 b4date=$TODAY
fi
# create list of *.sh files from P1 path.
pwdlen=${#PWD}
if [ 1 -eq 0 ];then
 echo " pwdlen = $pwdlen"
 sleep 4
fi
frstchar=$(($pwdlen-14))
lastfolder=${PWD:$frstchar:14}
if [ "$lastfolder" != "Projects-Geany" ];then
 echo "  current folder is not a Projects-Geany folder..."
 echo "  KillGShellsByDate cannot continue."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
else
 echo "  current folder is Projects-Geany - continuing.."
fi
pushd ./ > /dev/null
ls -lh > $TEMP_PATH/Gprojfiles.txt
# use mawk to pare list down to files meeting date criteria.
mawk '{if(substr($1,1,1) == "d")print $8;;}' $TEMP_PATH/Gprojfiles.txt \
 > $TEMP_PATH/Gprojpaths.txt
mawk -F "/" '{print $NF}' $TEMP_PATH/Gprojpaths.txt \
 > $TEMP_PATH/Gprojfolders.txt
echo " cat *TEMP_PATH/Gprojfolders.txt for folder list..."
# now loop on files meeting date criteria.
if test -s $TEMP_PATH/Gprojfolders.txt;then
 binpath=$WINGIT_PATH/TerritoriesCB/MNcrwg44586/Procs-Dev
 file=$TEMP_PATH/Gprojfolders.txt
 #climit=10
 ccount=0
 while read -e;do
  fn=$REPLY
  frstchar=${fn:0:1}
  skip=0
  if [ "$frstchar" == "\$" ];then break;fi
  if [ "$frstchar" == "#" ];then skip=1;fi
  if [ ${#fn} -eq 0 ];then skip=1;fi
  if [ $skip -eq 0 ];then
   echo "  processing folder $PWD/$fn..."
   pushd ./ > /dev/null
   cd $fn
   $binpath/KillShellsByDate.sh ./
   popd > /dev/null
   #if [ $ccount -eq $climit ];then break;fi
   ccount=$((ccount++))
  fi	# skip
 done < $file
fi		# end non-empty datedlist
popd > /dev/null
echo " KillGShellsByDate - $ccount folders processed."
# end KillGShellsByDate.sh
