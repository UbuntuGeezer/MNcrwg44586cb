#!/bin/bash
# IncDumpRelease.sh  - Incremental archive of Release subdirectories.
#	6/30/23.	wmk.
#
#	Usage. bash IncDumpRelease <state> <county> <congno> -u <mount-name>
#
#		<state> = 2 char state abbreviation
#		<county> = 4 char county abbreviation
#		<congno> = congregation number
#		-u = dump to USB flash drive
#		<usb-drive> = USB drive name
#
# Dependencies.
#	~/Territories/Release - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Release.n.tar - incremental dump of ./Release folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Release/log/Release.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Releaselevel.txt - current level of incremental Release 
#	  archive files.
#
# Modification History.
# ---------------------
# 4/15/23.	wmk.	-u <drive> support added.
# 6/30/23.	wmk.	read -p added to preserve Terminal session; change to use
#			 /dev/null for push and pop operations.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/8677.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 5/5/22.	wmk.	bug fix where *archname* not displayed with level 0 dump;
#			 level-0 archname corrected from *basic* to *release*.
# 3/27/23.	wmk.	verify dump prompt added.
# Legacy mods.
# 11/16/21.	wmk.	original shell; adapted from IncDumpRURaw.
# 11/18/21.	wmk.	TD corrected to Release.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/21.	wmk.	HOME changed to USER in host check.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpRelease.sh performs an incremental archive (tar) of the
# Release subdirectories. If the folder $pathbase/log does not exist under
# Release, it is created and a level-0 incremental dump is performed.
# A shell utility RestartRelease.sh is provided to reset the Release dump
# information so that the next IncDumpRelease run will produce the level-0
# (full) dump.
# The file $pathbase/log/Release.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpRelease calls. The initial archive file is named
# Release.0.tar.
# If the $pathbase/log folder exists under Release a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Release.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/Releaselevel.txt. tar will be
# invoked with this new Release.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}
P5=$5
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpRelease <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$pathbase" ];then
 if [ "USER" = "ubuntu" ]; then
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
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpRelease abandoned **"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "IncDumpRelease <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpRelease abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpRelease abandoned."
    exit 1
   else
    echo "continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
fi  #end drive not mounted
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$folderbase/temp
  bash ~/sysprocs/LOGMSG "   IncDumpRelease initiated from Make."
  echo "   IncDumpRelease initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpRelease initiated from Terminal."
  echo "   IncDumpRelease initiated."
fi
#
TEMP_PATH=$folderbase/temp
#procbodyhere
pushd ./ > /dev/null
if [ -z "$P5" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
level=level
nextlevel=nextlevel
newlevel=newlevel
release=Release
# if $dump_path/log/$congterr$release.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$release.snar-0;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  echo "0" > $dump_path/log/$congterr$release$level.txt
  echo "1" > $dump_path/log/$congterr$release$nextlevel.txt
  archname=$congterr$release.0.tar
  echo $archname
  pushd ./ > $TEMP_PATH/scratchfile
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$release.snar-0 \
	  --file=$dump_path/$archname \
	  ReleaseData
  .popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpRelease $P1 complete."
  echo "  IncDumpRelease $P1 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
  fi
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
fi
# this is a level-1 tar incremental.
 file=$dump_path/log/$congterr$release$nextlevel.txt
# while read -e; do
#  oldsnar=$congterr$release.snar-$REPLY
# done < $file
  oldsnar=$congterr$release.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$release$nextlevel.txt \
  > $dump_path/log/$congterr$release$newlevel.txt
 file=$dump_path/log/$congterr$release$nextlevel.txt
 while read -e;do
  export archname=$congterr$release.$REPLY.tar
  export snarname=$oldsnar
 # snarname=$congterr$release.snar-$REPLY
# cp $dump_path/log/$oldsnar $pathbase/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 pushd ./ > $TEMP_PATH/scratchfile
 cd $pathbase
 tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	ReleaseData
 popd  > $TEMP_PATH/scratchfile
done < $file
cp $dump_path/log/$congterr$release$newlevel.txt \
  $dump_path/log/$congterr$release$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpRelease $P1 complete."
echo "  IncDumpRelease $P1 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
fi
# end IncDumpRelease
