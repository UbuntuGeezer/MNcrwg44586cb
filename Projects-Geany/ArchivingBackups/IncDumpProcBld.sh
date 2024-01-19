#!/bin/bash
# IncDumpProcBld.sh  - Incremental archive of ProcBld-SQL folders.
# 6/27/22.	wmk.
#
#	Usage. bash IncDumpProcBld.sh
#
# Dependencies.
#	~/Territories/DB-Dev - base directory main Territory databases.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/ProcBld.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/ProcBld.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 6/27/22.	wmk.	original code; adpated from IncDumpProcs.
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
#					ProcBldnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	notify-send conditional fixed;HOME changed to USER.
# 3/14/22.	wmk.	terrbase environment var for <state> <county> <terrno>
#			 support; HOME changed to USER in host test; optional
#			 drive-spec parameter eliminated.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpProcBld.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file $pathbase/log/ProcBld.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartProcBld.sh is provided to
# reset the ProcBld dump information so that the next IncDumpProcBld
# run will produce the level-0 (full) dump.
# The file $pathbase/log/ProcBld.snar is created as the listed-incremental archive
# information. The file $pathbase/log/ProcBldlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpProcBld calls. The initial archive file is named
# ProcBld.0.tar.
# If the $pathbase/log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named ProcBld.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named ProcBld.n.tar.
echo "** IncDumpProcBld disabled - exiting. **"
read -p "Enter ctrl-c to remain in Terminal: "
exit 1
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpProcBld <state> <county> <congno> missing parameter(s) - abandoned."
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
echo "P1=:$P1" ;echo "P2=:$P2";echo "P3=:$P3"
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpProcBld abandoned **"
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
  bash ~/sysprocs/LOGMSG "   IncDumpProcBld initiated from Make."
  echo "   IncDumpProcBld initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpProcBld initiated from Terminal."
  echo "   IncDumpProcBld initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
cd $pathbase
procs=ProcBld
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $pathbase/log does not exist, initialize and perform level 0 tar.
if ! test -f $pathbase/log/$congterr$procs$level.txt;then
  # initial archive
 if ! test -d $pathbase/log;then
  mkdir log
 fi
  archname=$congterr$procs.0.tar
  echo $archname
  echo "0" > $pathbase/log/$congterr$procs$level.txt
  echo "1" > $pathbase/log/$congterr$procs$nextlevel.txt
  tar --create \
	  --listed-incremental=$pathbase/log/$congterr$procs.snar-0 \
	  --file=$congterr$procs.0.tar \
	  Procs-Build
  ~/sysprocs/LOGMSG "  IncDumpProcBld $P1 $P2 $P3 complete."
  echo "  IncDumpProcBld $P1 $P2 $P3 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=$congterr$procs.snar-$REPLY
# done < $file
  oldsnar=$congterr$procs.snar-0
 awk '{$1++; print $0}' $pathbase/log/$congterr$procs$nextlevel.txt > $pathbase/log/$congterr$procs$newlevel.txt
 file=$pathbase/log/$congterr$procs$nextlevel.txt
 while read -e;do
  export archname=$congterr$procs.$REPLY.tar
  export snarname=$oldsnar
# snarname=$congterr$procs.snar-$REPLY
# cp $pathbase/log/$oldsnar $pathbase/log/$snarname
# echo "./log/$snarname"
  echo "$archname"
  tar --create \
	--listed-incremental=$pathbase/log/$snarname \
	--file=$archname \
	Procs-Build
 done < $file
 cp $pathbase/log/$congterr$procs$newlevel.txt $pathbase/log/$congterr$procs$nextlevel.txt
#
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
~/sysprocs/LOGMSG "  IncDumpProcBld $P1 $P2 $P3 complete."
echo "  IncDumpProcBld $P1 $P2 $P3 complete"
# end IncDumpProcBld
