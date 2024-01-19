#!/bin/bash
# IncDumpTerr.sh  - Incremental archive of Terrxxx subdirectories.
#	8/12/22.	wmk.
#
#	Usage. bash IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>]
#
#		<terrid> = territory ID for which to dump files
#		-u		 = (optional) dump to removable device
#		<mount-name> = (mandagtory wih -u) removable device mount name
#
# Dependencies.
#	~/Territories/RawData/../RefUSA-Downloads/Terrxxx - base directory for Terrxxx
#    folders with territory RU information and code (including /Special).
#	~/Territories/RawData/../SCPA-Downloads/Terrxxx - base directory for Terrxxx
#    folders with territory SC information and code (including /Special).
#	~/Territories/TerrData/Terrxxx - base directory for Terrxxx
#    folders with publisher territory.

#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/*congterrTerr.n.tar - incremental dump of ~Terrxxx folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/*congterrTerr.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/*congterrTerrlevel.txt - current level of incremental Terr 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/7/22.	wmk.	original shell; adpated from IncDumpTerrData.
# 8/10/22.	wmk.	modified to use *P4 subfolder for consistency; change
#			 to use *dump_path instead of *flashbase; -u option for
#			 dumping to removable media; *pathbase qualifier used for
#			 tar files to dump, to avoid reloading issues.
# 8/12/22.	wmk.	*pathbase qualifier removed from dumps.
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
# Notes. IncDumpTerr.sh performs an incremental archive (tar) of the
# TerrData subdirectories. If the folder $pathbase/log does not exist under
# TerrData, it is created and a level-0 incremental dump is performed.
# A shell utility RestartTerrData.sh is provided to reset the TerrData dump
# information so that the next IncDumpTerr run will produce the level-0
# (full) dump.
# The file $pathbase/log/TerrData.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpTerr calls. The initial archive file is named
# TerrData.0.tar.
# If the $pathbase/log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/Terrlevel.txt. tar will be
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
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=$4			# terrid
P5=${5^^}		# -u (optional)
P6=$6			# mount-name
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>] missing parameter(s) - abandoned."
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
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
if [ ! -z "$P5" ];then
 if [ "$P5" != "-U" ];then
  echo "** IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P5 - abandoned. **"
  exit 1
 fi
 if [ -z "$P6" ];then
  echo "** IncDumpTerr <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
  exit 1
 fi
fi
if [ ! -z "$P5" ];then
 if ! test -d $U_DISK/$P6;then
  echo "$P6 not mounted... Mount flash drive $P6"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncTestBase abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P6;then
    echo "$P6 still not mounted - IncDumpTerrBase agandoned."
    exit 1
   else
   "echo continuing with $P6 mounted..."
   fi
  fi
 fi
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"		# terrID
echo "P5 = : '$P5'"
echo "P6 = : '$P6'"
echo "parameter tests complete."
#exit
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   IncDumpTerr initiated from Make."
  echo "   IncDumpTerr initiated."
else
  ~/sysprocs/LOGMSG "   IncDumpTerr initiated from Terminal."
  echo "   IncDumpTerr initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P6/$congterr
fi
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
terr=Terr
# if $dump_path/log/TerrData.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$terr.snar-0;then
  # initial archive 
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  archname=$congterr$terr.0.tar
  echo $archname
  echo "0" > $dump_path/log/$congterr$terr$level.txt
  echo "1" > $dump_path/log/$congterr$terr$nextlevel.txt
  pushd ./
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$terr.snar-0 \
	  --file=$dump_path/$archname \
	  RawData/RefUSA/RefUSA-Downloads/Terr$P4 \
	  RawData/SCPA/SCPA-Downloads/Terr$P4 \
	  TerrData/Terr$P4
  popd
  ~/sysprocs/LOGMSG "  IncDumpTerr $P1 $P2 $P3 $P4 $P5 $P6 complete."
  echo "  IncDumpTerr $P1 $P2 $P3 $P4 $P5 $P6 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=TerrData.snar-$REPLY
# done < $file
  oldsnar=$congterr$terr.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$terr$nextlevel.txt > $dump_path/log/$congterr$terr$newlevel.txt
 file=$dump_path/log/$congterr$terr$nextlevel.txt
 while read -e;do
  export archname=$congterr$terr.$REPLY.tar
  export snarname=$oldsnar
 echo "$archname"
# echo "PWD = : '$PWD'"
 pushd ./
 cd $pathbase
 tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	  RawData/RefUSA/RefUSA-Downloads/Terr$P4 \
	  RawData/SCPA/SCPA-Downloads/Terr$P4 \
	  TerrData/Terr$P4
 popd
done < $file
cp $dump_path/log/$congterr$terr$newlevel.txt $dump_path/log/$congterr$terr$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpTerr $P1 $P2 $P3 $P4 $P5 $P6 complete."
echo "  IncDumpTerr $P1 $P2 $P3 $P4 $P5 $P6 complete"
# end IncDumpTerr
