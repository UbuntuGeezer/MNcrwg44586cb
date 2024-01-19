#!/bin/bash
# IncDumpSCRaw.sh  - Incremental archive of RawData subdirectories.
# 8/6/22.	wmk.
#
#	Usage. bash IncDumpSCRaw.sh <state> <county> <congno> [<flash-drive>]
#
#		<state> = 2 char state abbreviation
#		<county> = 4 char county abbreviation
#		<congno> = congregation number
#		<flash-drive> (optional) = mount name of drive to dump to; if not
#		  specified, will be dumped to local hard disk *pathbase
#
# Dependencies.
#	~/Territories/RawData/SCPA - base directory for Terrxxx folders with
#	  SCPA raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataSC.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataSC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/30/22.	wmk.	superfluous P1 removed from file = (tar).
# 8/6/22.	wmk.	dump to flashdrive option added.
# Legacy mods.
# 9/8/21.	wmk.	original shell; adapted from IncDumpRawDataSC.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpSCRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/RawDataSC.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataSC.sh is provided to
# reset the RawData dump information so that the next IncDumpSCRaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/RawDataSC.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawSClevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpSCRaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataSC.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataSC.snar-n file as the "listed-incremental"
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
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpSCRaw <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
flashdump=0
if [ ! -z "$P4" ];then
 flashdump=1
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
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Make."
  echo "   IncDumpSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Terminal."
  echo "   IncDumpSCRaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ $flashdump -eq 0 ];then
 dumpbase=$pathbase
else
# cd $U_DISK/$P4/$congterr
 dumpbase=$U_DISK/$P4/$congterr
fi
cd $dumpbase
echo "PWD = : '$PWD'"
echo "dumpbase = : '$dumpbase'"
echo "IncDumpSCRaw completed through flash drive selection"
exit 
level=level
nextlevel=nextlevel
newlevel=newlevel
rawsc=RawDataSC
# if $dumpbase/log does not exist, initialize and perform level 0 tar.
if ! test -f $dumpbase/log/$congterr$rawsc$level.txt;then
  # initial archive
 if ! test -d $dumpbase/log;then
  mkdir log
 fi
  archname=$congterr$rawsc.0.tar
  echo $archname
  echo "0" > $dumpbase/log/$congterr$rawsc$level.txt
  echo "1" > $dumpbase/log/$congterr$rawsc$nextlevel.txt
  archname=$congterr$rawsc.0.tar
  echo $archname
  pushd ./
  cd $pathbase
   tar --create \
	  --listed-incremental=$dumpbase/log/$congterr$rawsc.snar-0 \
	  --file=$dumpbase/$archname \
	  RawData/SCPA
  popd
  ~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 $P4 complete."
  echo "  IncDumpSCRaw $P1 $P2 $P3 $P4 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=RawDataSC.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawsc.snar-0
 awk '{$1++; print $0}' $dumpbase/log/$congterr$rawsc$nextlevel.txt \
  > $dumpbase/log/$congterr$rawsc$newlevel.txt
 file=$dumpbase/log/$congterr$rawsc$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawsc.$REPLY.tar
  export snarname=$oldsnar
# snarname=RawDataSC.snar-$REPLY
# cp $dumpbase/log/$oldsnar $dumpbase/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 pushd ./
 cd $pathbase
  tar --create \
	--listed-incremental=$dumpbase/log/$snarname \
	--file=$dumpbase/$archname \
	RawData/SCPA
 popd
done < $file
cp $dumpbase/log/$congterr$rawsc$newlevel.txt $dumpbase/log/$congterr$rawsc$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 complete."
echo "  IncDumpSCRaw $P1 $P2 $P3 complete"
# end IncDumpSCRaw
