#!/bin/bash
# IncDumpMainDBs.sh  - Incremental archive of DB-Dev databases.
#	8/16/23.	wmk.
#
#	Usage. bash IncDumpMainDBs.sh [drive-spec]
#
# Dependencies.
#	~/Territories/DB-Dev - base directory main Territory databases.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/MainDBs.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/MainDBs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 11/27/22.	wmk.	exit handling allowing Terminal to continue; error message
#			 corrections; CB support.
# 12/19/22.	wmk.	correct mount-name testing logic.
# 3/27/23.	wmk.	verify dump prompt added.
# 4/9/23.	wmk.	verify complete message added.
# Legacy mods.
# 8/11/22.	wmk.	-u <mount-name> support.
# 10/10/22.	wmk.	*codebase support.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/30/22.	wmk.	bug fixes where old code was not removed.
# Legacy mods.
# 9/17/21.	wmk.	original shell; adapted from IncDumpRawRU; jumpto
#					function eliminated.
# 9/18/21.	wmk.	bug fix in level-1 MainDBDsnextlevel corrected to
#					MainDBsnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	notify-send conditional fixed;HOME changed to USER.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpMainDBs.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file $pathbase/log/MainDBs.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartMainDBs.sh is provided to
# reset the MainDBs dump information so that the next IncDumpMainDBs
# run will produce the level-0 (full) dump.
# The file $pathbase/log/MainDBs.snar is created as the listed-incremental archive
# information. The file $pathbase/log/MainDBslevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpMainDBs calls. The initial archive file is named
# MainDBs.0.tar.
# If the $pathbase/log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named MainDBs.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named MainDBs.n.tar.
P1=${1^^}	# <state>
P2=${2^^}	# <county>
P3=$3		# <congno>
P4=${4^^}	# -U
P5=$5		# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpMainDBs <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
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
if [ "$P4" != "-U" ];then
  echo "** IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpMainDBs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpMainDBs abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
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
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   IncDumpMainDBs initiated from Make."
  echo "   IncDumpMainDBs initiated."
else
  ~/sysprocs/LOGMSG "   IncDumpMainDBs initiated from Terminal."
  echo "   IncDumpMainDBs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
arch_path=${pathbase:14:50}
maindbs=MainDBs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $dump_path/log/$congterr$maindbs.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$maindbs.snar-0;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  echo "0" > $dump_path/log/$congterr$maindbs$level.txt
  echo "1" > $dump_path/log/$congterr$maindbs$nextlevel.txt
  archname=$congterr$maindbs.0.tar
  echo $archname
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
      --wildcards \
	  --listed-incremental=$dump_path/log/$congterr$maindbs.snar-0 \
	  --file=$dump_path/$archname \
	  -- DB-Dev
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5complete."
  echo "  IncDumpMainDBs $P1 $P2 $P3 $P4 $p5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "$archname verify complete."
  fi
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.$congterr
  oldsnar=$congterr$maindbs.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$maindbs$nextlevel.txt \
    > $dump_path/log/$congterr$maindbs$newlevel.txt
 file=$dump_path/log/$congterr$maindbs$nextlevel.txt
 while read -e;do
  export archname=$congterr$maindbs.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	-- DB-Dev
  popd > /dev/null
done < $file
cp $dump_path/log/$congterr$maindbs$newlevel.txt $dump_path/log/$congterr$maindbs$nextlevel.txt
#
if [ ! -z "${DIRSTACK[1]}" ];then popd > /dev/null;fi
#endprocbody
~/sysprocs/LOGMSG "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo "  $archname verify complete."
fi
# end IncDumpMainDBs
