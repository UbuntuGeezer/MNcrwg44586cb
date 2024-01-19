#!/bin/bash
# IncDumpBSCRaw.sh  - Incremental archive of BRawData/SCPA subdirectories.
# 5/11/22.	wmk.
#
#	Usage. bash IncDumpBSCRaw.sh 
#
# Dependencies.
#	~/Territories/BRawData/SCPA/SCPA-Downloads - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/BRawDataSC.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/BRawDataSC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 5/11/22.	wmk.	paths and filenames corrected.
# Legacy mods.
# 9/25/21.	wmk.	original shell; adapted from IncDumpBRawDataSC.
# 11/24/21	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpBSCRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/BRawDataSC.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartBRawDataSC.sh is provided to
# reset the RawData dump information so that the next IncDumpBSCRaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/BRawDataSC.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawBizlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpBSCRaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named BRawDataSC.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new BRawDataSC.snar-n file as the "listed-incremental"
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
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpBSCRaw <state> <county> <congno> missing parameter(s) - abandoned."
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
P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpBSCRaw initiated from Make."
  echo "   IncDumpBSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpBSCRaw initiated from Terminal."
  echo "   IncDumpBSCRaw initiated."
fi
TEMP_PATH="$HOME/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
rawdata=BRawDataSC
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $pathbase/log does not exist, initialize and perform level 0 tar.
if ! test -f $pathbase/log/$rawdata$level.txt;then
  # initial archive
 if ! test -d $pathbase/log;then
  mkdir log
 fi
  export archname=$congterr$rawdata.0.tar
  echo "0" > $pathbase/log/$rawdata$level.txt
  echo "1" > $pathbase/log/$rawdata$nextlevel.txt
  echo $archname
  tar --create \
	  --listed-incremental=$pathbase/log/$rawdata.snar-0 \
	  --file=$archname \
	  BRawData/SCPA
  ~/sysprocs/LOGMSG "  IncDumpBSCRaw $P1 $P2 $P3 complete."
  echo "  IncDumpBSCRaw $P1 $P2 $P3 complete"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=BRawDataSC.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawdata.snar-0
 awk '{$1++; print $0}' $pathbase/log/$congterr$rawdata$nextlevel.txt > $pathbase/log/$congterr$rawdata$newlevel.txt
 file=$pathbase/log/$congterr$rawdata$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawdata.$REPLY.tar
  export snarname=$oldsnar
# snarname=$congterr$rawdata.snar-$REPLY
# cp $pathbase/log/$oldsnar $pathbase/log/$snarname
# echo "$pathbase/log/$snarname"
 echo "$archname"
 tar --create \
	--listed-incremental=$pathbase/log/$snarname \
	--file=$archname \
	BRawData/SCPA
done < $file
cp $pathbase/log/$congterr$rawdata$newlevel.txt $pathbase/log/$congterr$rawdata$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  IncDumpBSCRaw complete."
echo "  IncDumpBSCRaw complete"
# end IncDumpBSCRaw
