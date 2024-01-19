#!/bin/bash
# IncDumpTestBase.sh  - Incremental archive of TestBase subdirectories.
# 8/9/22.	wmk.
#
#	Usage. bash IncDumpTestBase <state> <county> <congno> [-u <mount-name>]
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
# 8/8/22.	wmk.	original code; adapted from IncDumpTerrData.
# 8/9/22.	wmk.	modified to use *P4 subfolder for consistency; change
#			 to use *dump_path instead of *flashbase; -u option for
#			 dumping to removable media.
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
# Notes. IncDumpTestBase.sh performs an incremental archive (tar) of the
# TerrData subdirectories. If the folder $pathbase/log does not exist under
# TerrData, it is created and a level-0 incremental dump is performed.
# A shell utility RestartTerrData.sh is provided to reset the TerrData dump
# information so that the next IncDumpTestBase run will produce the level-0
# (full) dump.
# The file $pathbase/log/TerrData.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpTestBase calls. The initial archive file is named
# TerrData.0.tar.
# If the $pathbase/log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/TDlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpTestBase <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
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
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpTestBase abandoned **"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** IncDumpTestBase <state> <county> <congno> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  exit 1
 fi
fi
if [ -z "$P4" ];then
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncTestBase abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpTerrBase agandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
fi
echo "parameter tests complete."
#exit
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpTestBase initiated from Make."
  echo "   IncDumpTestBase initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpTestBase initiated from Terminal."
  echo "   IncDumpTestBase initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/$P5/$congterr
terr=TestBase
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
td=TestBase
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
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$td.snar-0 \
	  --file=$dump_path/$congterr$td.0.tar \
	  $pathbase/TestBase
  ~/sysprocs/LOGMSG "  IncDumpTestBase $P1 $P2 $P3 $P4 complete."
  echo "  IncDumpTestBase $P1 $P2 $P3 $P4 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=TerrData.snar-$REPLY
# done < $file
  oldsnar=$congterr$td.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$td$nextlevel.txt > $dump_path/log/$congterr$td$newlevel.txt
 file=$dump_path/log/$congterr$td$nextlevel.txt
 while read -e;do
  export archname=$congterr$td.$REPLY.tar
  export snarname=$oldsnar
 echo "$archname"
 tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	$pathbase/TestBase
done < $file
cp $dump_path/log/$congterr$td$newlevel.txt $dump_path/log/$congterr$td$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpTestBase $P1 $P2 $P3 $P4 complete."
echo "  IncDumpTestBase $P1 $P2 $P3 $P4 complete"
# end IncDumpTestBase
