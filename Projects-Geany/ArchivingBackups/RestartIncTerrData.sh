#!/bin/bash
# RestartIncTerrData.sh  - Set up for fresh incremental archiving of TerrData.
#	8/15/23. wmk.
#
#	Usage. bash RestartIncTerrData.sh <state> <county> <congno>  -u <mount-name>
#
#		<state> = 2-char state
#		<county> = 4-char county
#		<congno> = congregation number
#		-u - (optional) restart on USB flash drive
#		<mount-name> - (optional, mandatory if -u present) USB flash drive name
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/*congterr/TerrData.nnn.tar files all deleted after warning;
#	/*congterr/log/TerrData.snar-0 deleted after warning;
#	/*congterr/log/TerrDatalevel.txt deleted; this sets up next run of
#	IncDumpTerrData to start at level 0;
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MN/CRWG/44586.
# Legacy mods.
# 2/15/23.	wmk.	-u, <mount-name> support; jumpto references removed;
#			 notify-send removed; comments tidied.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}		# -U
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncTerrData <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "RestartIncTerrData <state> <county> <congno> [-u <mount-name>] '-' unrecognized option - abandoned."
  exit 1
fi	# not -U
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncTerrData abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncTerrData abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi
  fi
else
 echo "continuing with $P5 mounted..."
fi		# P5 not mounted
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncTerrData abandoned **"
 exit 1
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncTerrData initiated from Make."
  echo "   RestartTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncTerrData initiated from Terminal."
  echo "   RestartTerrData initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
echo " **WARNING - proceeding will remove all prior TerrData incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncTerrData."
  echo " Stopping RestartIncTerrData - secure TerrData incremental backups.."
  exit 0
fi
fi
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
geany=TerrData
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$geany$level.txt;then
 rm $dump_path/log/$congterr$geany$level.txt
fi
echo "0" > $dump_path/log/$congterr$geany$nextlevel.txt
if test -f $dump_path/log/$congterr$geany.snar-0; then
 rm $dump_path/log/$congterr$geany.snar-0
fi
if test -f $dump_path/$congterr$geany.0.tar; then
 rm $dump_path/$congterr$geany*.tar
fi
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  RestartIncTerrData $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncTerrData $P1 $P2 $P3 $P4 $P5 complete."
# end RestartTerrDataData
