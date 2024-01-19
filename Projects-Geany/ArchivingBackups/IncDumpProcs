#!/bin/bash
# IncDumpProcs.sh  - Incremental archive of Procs-SQL folders.
#	6/3/23.	wmk.
#
#	Usage. bash IncDumpProcs.sh  <state> <county> <congno> [-u <mount-name>]
#
#		<state>
#		<county>
#		<congno>
#		-u	= (optional) dump to removable device
#		<mount-name> = removable device name
#
# Dependencies.
#	~/Territories/DB-Dev - base directory main Territory databases.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Procs.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/Procs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 8/15/22.	wmk.	removable device support.
# 11/2/22.	wmk.	*sysid support; *codebase support; -u <mount-name> support.
# 11/27/22.	wmk.	remove *sysid support; exit handling to allow Terminal to
#			 continue; comments tidied.
# 1/21/23.	wmk.	bug fix in USB drive check logic.
# 3/27/23.	wmk.	verify dump prompt added.
# 6/3/23.	wmk.	verify complete message added.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file=
# 6/27/22.	wmk.	Procs-Build added to archiving list.
# Legacy mods.
# 9/17/21.	wmk.	original shell; adapted from IncDumpRawRU; jumpto
#					function eliminated.
# 9/18/21.	wmk.	bug fix in level-1 MainDBDsnextlevel corrected to
#					Procsnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	notify-send conditional fixed;HOME changed to USER.
# 3/14/22.	wmk.	terrbase environment var for <state> <county> <terrno>
#			 support; HOME changed to USER in host test; optional
#			 drive-spec parameter eliminated.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpProcs.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file $pathbase/log/Procs.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartProcs.sh is provided to
# reset the Procs dump information so that the next IncDumpProcs
# run will produce the level-0 (full) dump.
# The file $pathbase/log/Procs.snar is created as the listed-incremental archive
# information. The file $pathbase/log/Procslevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpProcs calls. The initial archive file is named
# Procs.0.tar.
# If the $pathbase/log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Procs.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named Procs.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpProcs <state> <county> <congno> [-u <mount-name>] missing parameter(s) - abandoned."
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** IncDumpProcs <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** IncDumpProcs <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
fi
if [ ! -z "$P4" ];then
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpProcs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpProcs agandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
echo "P1=:$P1" ;echo "P2=:$P2";echo "P3=:$P3"
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpProcs abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   IncDumpProcs initiated from Make."
  echo "   IncDumpProcs initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpProcs initiated from Terminal."
  echo "   IncDumpProcs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$codebase
else
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
procs=Procs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $pathbase/log does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$procs$level.txt;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  archname=$congterr$procs.0.tar
  echo $archname
  echo "0" > $dump_path/log/$congterr$procs$level.txt
  echo "1" > $dump_path/log/$congterr$procs$nextlevel.txt
  pushd ./
  cd $codebase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$procs.snar-0 \
	  --file=$dump_path/$archname \
	  -- Procs-Dev
  ~/sysprocs/LOGMSG "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo " $dump_path/$archname verify complete."
  fi
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=$congterr$procs.snar-$REPLY
# done < $file
  oldsnar=$congterr$procs.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$procs$nextlevel.txt > $dump_path/log/$congterr$procs$newlevel.txt
 file=$dump_path/log/$congterr$procs$nextlevel.txt
 while read -e;do
  export archname=$congterr$procs.$REPLY.tar
  export snarname=$oldsnar
  echo "$archname"
  pushd ./
  cd $codebase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	Procs-Dev
  popd
 done < $file
 cp $dump_path/log/$congterr$procs$newlevel.txt $dump_path/log/$congterr$procs$nextlevel.txt
#
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
~/sysprocs/LOGMSG "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
 echo " $dump_path/$archname verify complete."
fi
# end IncDumpProcs
