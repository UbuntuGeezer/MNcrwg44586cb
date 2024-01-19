#!/bin/bash
# IncDumpTerrData.sh  - Incremental archive of TerrData subdirectories.
#	8/15/23.	wmk.
#
#	Usage. bash IncDumpTerrData <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		<mount-name> = removable media mount name
#
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.n.tar - incremental dump of ./TerrData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TDlevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 9/13/22.	wmk.	-u, <mount-name> support.
# 3/27/23.	wmk.	verify dump prompt added.
# 4/9/23.	wmk.	verify complete message added.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL SARA 86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 5/2/22.	wmk.	path fixes incorporating *congterr* var.
# 6/12/22.	wmk.	bug fix with superfluous '.' in log path check.
# Legacy mods.
# 6/29/21.	wmk.	original shell.
# 9/8/21.	wmk.	documentation review and minor corrections.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpTerrData.sh performs an incremental archive (tar) of the
# TerrData subdirectories. If the folder $pathbase/log does not exist under
# TerrData, it is created and a level-0 incremental dump is performed.
# A shell utility RestartTerrData.sh is provided to reset the TerrData dump
# information so that the next IncDumpTerrData run will produce the level-0
# (full) dump.
# The file $pathbase/log/TerrData.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpTerrData calls. The initial archive file is named
# TerrData.0.tar.
# If the $pathbase/log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/TDlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpTerrData <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
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
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpTerrData abandoned **"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** IncDumpTerrData <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpTerrData abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpTerrData abandoned."
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi
  fi
else
 echo "continuing with $P5 mounted..."
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpTerrData initiated from Make."
  echo "   IncDumpTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpTerrData initiated from Terminal."
  echo "   IncDumpTerrData initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
td=TerrData
# if $dump_path/log/TerrData.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$td.snar-0;then
  # initial archive 
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  archname=$congterr$td.0.tar
  echo $archname
  echo "0" > $dump_path/log/$congterr$td$level.txt
  echo "1" > $dump_path/log/$congterr$td$nextlevel.txt
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$td.snar-0 \
	  --file=$dump_path/$archname \
	  TerrData
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
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
#  oldsnar=TerrData.snar-$REPLY
# done < $file
  oldsnar=$congterr$td.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$td$nextlevel.txt \
  > $dump_path/log/$congterr$td$newlevel.txt
 file=$dump_path/log/$congterr$td$nextlevel.txt
 while read -e;do
  export archname=$congterr$td.$REPLY.tar
  export snarname=$oldsnar
# snarname=$td.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 pushd ./ > /dev/null
 cd $pathbase
 tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	TerrData
 popd > /dev/null
done < $file
cp $dump_path/log/$congterr$td$newlevel.txt $dump_path/log/$congterr$td$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpTerrData $P1 $P2 $P3 $P4 complete."
echo "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo "  $archname  veify complete."
fi
# end IncDumpTerrData
