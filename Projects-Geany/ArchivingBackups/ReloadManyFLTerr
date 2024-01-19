#!/bin/bash
# ReloadManyFLTerr.sh - Reload multiple FL territories.
# 1/29/23.	wmk.
#
# Usage. bash  ReloadManyFLTerr  -u <mount-name>
#
#	-u = USB drive as source option
# 	<mount-name> = USB  <mount-name>
#
# Entry. ArchivingBackups/TIDList.txt = list of territories to reload.
#
# Exit. territories in TIDList.txt reloaded from archive.
#
# Modification History.
# ---------------------
# 1/29/23.	wmk.	original code.
# jumpto function.
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=${1^^}		# -U
P2=$2			# <mount-name> or SANDISK
umount=${P2^^}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "ReloadManyFLTerr -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" != "-U" ];then
 echo "ReloadManyFLTerr -u <mount-name> unrecognized option '$P1' - abandoned."
 exit 1
fi
thisproj=$codebase/Projects-Geany/ArchivingBackups
if ! test -f $thisproj/TIDList.txt;then
 echo "** ReloadManyFLTerr TIDList.txt not found - abandoned **"
 exit 1
fi
if [ "$umount" != "SANDISK" ];then
 if ! test -d $U_DISK/$P2;then
  echo "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "ReloadManyFLTerr abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    echo "$P2 still not mounted - ReloadManyFLTerr abandoned."
    exit 1
   else
   echo " continuing with $P2 mounted..."
   fi
  fi
  echo " $P2 mounted - continuing.."
 fi
else	# SANDISK
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "ReloadManyFLTerr abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P2 still not mounted - ReloadManyFLTerr abandoned."
    exit 1
   else
    echo "continuing with $P2 mounted..."
   fi
  fi
  echo "$P2 mounted - continuing.."
 fi
fi
# loop on TIDList.txt with Reload.
file=$thisproj/TIDList.txt
skip=1
while read -e; do
 TID=$REPLY
 len=${#REPLY}
 firstchar=${TID:0:1}
 if [ "$firstchar" == "#" ] || [ $len -eq 0 ];then
  skip=1
 elif [ "$firstchar" == "\$" ];then
  break
 else
  skip=0
 fi
 if [ $skip -eq 0 ];then
  echo " Processing '$TID'..."
  if [ "$umount" != "SANDISK" ];then
   $thisproj/ReloadFLTerr $TID ! -u $P2
  else
   source $thisproj/Sandisk.sh
   ReloadFLTerr $TID ! -u $P2
  fi
 fi
done <$file
echo " ReloadManyFLTerr  $P1 $P2 complete."
# end ReloadManyFLTerr
