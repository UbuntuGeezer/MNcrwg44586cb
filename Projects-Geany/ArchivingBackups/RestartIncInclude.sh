#!/bin/bash
# RestartInclude.sh  - Set up for fresh incremental archiving of Include.
# 	8/16/23.	wmk.
#
#	Usage. bash RestartInclude.sh <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state
#		<county> = 4 char county
#		<congno> = congregation number
#		-u = dump to removable device
#		<mount-name> = mount name for removable device
#
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Include.nnn.tar files all deleted after warning;
#	/Territorie $pathbase/log/Include.snar-0 deleted after warning;
#	/Territorie $pathbase/log/Includelevel.txt deleted; this sets up next run of
#	IncDumpInclude to start at level 0;
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 11/1/22.	wmk.	!! *sysid environment var support for all archiving
#			 operations; this will keep code segment dumps separated in the
#			 archiving system to avoid unwanted overwriting of macros/modules
#			 with the same name; *codebase support; -u, <mount-name> support.
# Legacy mods.
# 4/25/22.	wmk.	original code; adapted from IncDumpGeany.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
# P1=<state>, P2=<county>, P3=<congno>, P4=-u, P5-<mount-name>
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncInclude <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** RestartIncInclude <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncInclude abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncInclude abandoned."
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi
  fi
else
 echo "continuing with $P5 mounted..."
fi
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
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
 echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncInclude abandoned **"
 exit 1
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncInclude initiated from Make."
  echo "   RestartInclude initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncInclude initiated from Terminal."
  echo "   RestartInclude initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
echo " **WARNING - proceeding will remove all prior Include incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncInclude."
  echo " Stopping RestartIncInclude - secure Include incremental backups.."
  exit 0
fi
fi
#
#procbodyhere
pushd ./ > /dev/null
cd $U_DISK/$P5
if -test -d $congterr;then
  mkdir $congterr
fi
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
if ! test -d ./log;then
 mkdir log
fi
geany=Include
level=level
nextlevel=nextlevel
if test -f  $dump_path/log/$congterr$geany$level.txt;then
 rm  $dump_path/log/$congterr$geany$level.txt
fi
echo "0" >  $dump_path/log/$congterr$geany$nextlevel.txt
if test -f  $dump_path/log/$congterr$geany.snar-0; then
 rm  $dump_path/log/$congterr$geany.snar-0
fi
rm $pathbase/$congterr$geany*.tar
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  RestartIncInclude $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncInclude $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncludeData
