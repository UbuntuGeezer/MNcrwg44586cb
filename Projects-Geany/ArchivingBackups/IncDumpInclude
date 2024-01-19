#!/bin/bash
# IncDumpInclude.sh  - Incremental archive of Include subdirectories.
#	8/16/23.	wmk.
#
#	Usage. bash IncDumpInclude <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/Include - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Include.n.tar - incremental dump of ./Include folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Include/log/Include.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Includelevel.txt - current level of incremental Include 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 11/1/22.	wmk.	*sysid support; *codebase support; -u <mount-name> support.
# 3/27/23.	wmk.	verify dump prompt added.
# Legacy mods.
# 4/25/22.	wmk.	original code;adapted from IncDumpBasic.
# 5/5/22.	wmk.	dump origin folder corrected from Include to include.	
#
# Notes. IncDumpInclude.sh performs an incremental archive (tar) of the
# Include subdirectories. If the folder $pathbase/log does not exist under
# Include, it is created and a level-0 incremental dump is performed.
# A shell utility RestartInclude.sh is provided to reset the Include dump
# information so that the next IncDumpInclude run will produce the level-0
# (full) dump.
# The file $pathbase/log/Include.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpInclude calls. The initial archive file is named
# Include.0.tar.
# If the $pathbase/log folder exists under Include a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Include.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/$basiclevel.txt. tar will be
# invoked with this new Include.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# P1=<state>, P2=<county>, P3=<congno>, P4=-u, P5=<mount-name>
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpInclude <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** IncDumpInclude <state> <county> <congno> <terrid> -u <mount-name> unrecognized option $P4 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpInclude abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpInclude abandoned."
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
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpInclude initiated from Make."
  echo "   IncDumpInclude initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpInclude initiated from Terminal."
  echo "   IncDumpInclude initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
basic=Include
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $dump_path/log/Include.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$basic.snar-0;then
  # initial archive 
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  echo "0" > $dump_path/log/$congterr$basic$level.txt
  echo "1" > $dump_path/log/$congterr$basic$nextlevel.txt
  archname=$congterr$basic.0.tar
  echo $archname
  pushd ./ > /dev/null
  cd $codebase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$basic.snar-0 \
	  --file=$dump_path/$archname \
	  -- include
  ~/sysprocs/LOGMSG "  IncDumpInclude $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpInclude $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "$archname verify complete."
  fi
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=Include.snar-$REPLY
# done < $file
  oldsnar=Include.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$basic$nextlevel.txt \
  > $dump_path/log/$congterr$basic$newlevel.txt
 file=$dump_path/log/$congterr$basic$nextlevel.txt
 while read -e;do
  export archname=$congterr$basic.$REPLY.tar
  export snarname=$oldsnar
# snarname=Include.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 pushd ./ > /dev/null
 cd $codebase
 tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=dump_path/$archname \
	-- include
 popd > /dev/null
done < $file
cp $dump_path/log/$congterr$basic$newlevel.txt \
 $dump_path/log/$congterr$basic$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpInclude $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpInclude $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo "$archname verify complete."
fi
# end IncDumpInclude
