#!/bin/bash
# RestartIncPDFs.sh  - Set up for fresh incremental archiving of TerrData.
# 	1/28/23.	wmk.
#
#	Usage. bash  RestartIncPDFs.sh <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation number
#		-u = (optional) restart on USB drive
#		<mount-name> = (optional, mandatory if -u specified) USB mount name
#
# Dependencies.
#	~/Territories/Territory-PDFs - base directory for territory PDF files.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.nnn.tar files all deleted after warning;
#	/Territories/log/TerrData.snar-0 deleted after warning;
#	/Territories/log/TerrDatalevel.txt deleted; this sets up next run of
#	IncDumpTerrData to start at level 0;
#
# Modification History.
# ---------------------
# 10/9/22.	wmk.	original code; adapted from RestartIncTerrData; -u, <mount-name>
#			 support added; *codebase support added; jumpto references removed.
# 1/28/23.	wmk.	USB drive mounted checks added; exit handling allowing Terminal continue.
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
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4,,}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncPDFs <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-u" ];then
  echo "RestartIncPDFs <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "RestartIncPDFs <state> <county> <congno> [-u <mount-name>] missing <mount-name> - abandoned."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi 
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncSCRaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - RestartIncSCRaw abandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 else
  echo "$P5 mounted - continuing.."
 fi
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncPDFs initiated from Make."
  echo "   RestartTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncPDFs initiated from Terminal."
  echo "   RestartTerrData initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
echo " **WARNING - proceeding will remove all prior PDF incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncPDFs."
  echo " Stopping RestartIncPDFs - secure TerrPDFs incremental backups.."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P5" ];then
 dump_path=$U_DISK/$P5/$congterr
else
 dump_path=$pathbase
fi
cd $pathbase
pdfs=pdfs
level=level
nextlevel=nextlevel
if test -f $dump_path/log/$congterr$pdfs$level.txt;then
 rm $dump_path/log/$congterr$pdfs$level.txt
fi
echo "0" > $dump_path/log/$congterr$pdfs$nextlevel.txt
#cat $dump_path/log/$congterr$pdfs$nextlevel.txt
if test -f $dump_path/log/$congterr$pdfs.snar-0; then
 rm $dump_path/log/$congterr$pdfs.snar-0
fi
if test -f $dump_path/$congterr$pdfs.0.tar; then
 rm $dump_path/$congterr$pdfs*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncPDFs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncPDFs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncPDFs

