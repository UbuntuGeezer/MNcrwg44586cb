#!/bin/bash
# IncDumpPDFs.sh  - Incremental archive of Geany subdirectories.
#	6/16/23.	wmk.
#
#	Usage. bash IncDumpPDFs <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		<mount-name> = removable media mount name
#
# Dependencies.
#	~/Territories/Territories-PDFs - base directory for territory PDFs
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/*congterr/*congterr*pdfs.n.tar - incremental dump of ./Territories-PDFs
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/*congterr/log/*congterr*pdfs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/*congterr/log/pdfslevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 10/9/22.	wmk.	original code; adapted from IncDumpGeany; jumpto references removed.
# 10/10/22.	wmk.	bug fix missing '$' in *archname reference.
# 1/28/23.	wmk.	bug fix in drive tests echo; exit handling allowing remain in
#			 Terminal; debug stuff removed.
# 3/27/23.	wmk.	verify dump prompt added.
# 6/16/23.	wmk.	bug fix level 0 cntl-C prompt moved.
# Legacy mods.
# 8/11/22.	wmk.	-u and <mount-name> support as dump target.
# 9/2/22.	wmk.	error messages cleaned up.
# 9/5/22.	wmk.	correct oldsnar eliminating *dump_path.
# 9/11/22.	wmk.	bug fix checking P4 for mount.	
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	corrected awk to use *pathbase* in all file refs;
#			 *congterr* env var support.
# 4/24/22.	wmk.	*congterr* used througout.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from IncDumpRURaw.
# 11/24/21.	wmk.	notify-send condtional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 3/31/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpPDFs.sh performs an incremental archive (tar) of the
# Projects-Geany subdirectories. If the folder ./log does not exist under
# Territories, it is created and a level-0 incremental dump is performed.
# A shell utility RestartGeany.sh is provided to reset the Geany dump
# information so that the next IncDumpPDFs run will produce the level-0
# (full) dump.
# Note. 8/11/22. Starting with this date, the .tar paths are full paths which
# include the *pathbase prefix. This is to avoid confusion in the reload
# process when a removable media is being used.
# The file ./log/$P1$P2$P3Geany.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpPDFs calls. The initial archive file is named
# $P1$P2$P3Geany.0.tar.
# If the ./log folder exists under Geany a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named $P1$P2$P3Geany.snar-n, where n is the
# next level # obtained by incrementing ./log/$P1$P2$P3Geanylevel.txt. tar will be
# invoked with this new Geany.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4^^}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpPDFs <state> <county> <congno> [-u <mount-name> ] missing parameter(s) - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** IncDumpPDFs <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** IncDumpPDFs <state> <county> <congno> <terrid> [-u <mount-name>] missing <mount-name> - abandoned. **"
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
fi
if [ ! -z "$P4" ];then
 if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpPDFs abandoned at user request."
   read -p "Enter ctl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpPDFs abandoned."
    read -p "Enter ctl-c to remain in Terminal:"
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi
  fi
 else
  echo "$P5 mounted - continuing..."
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codbase=$pathbase
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpPDFs abandoned **"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpPDFs initiated from Make."
  echo "   IncDumpPDFs initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpPDFs initiated from Terminal."
  echo "   IncDumpPDFs initiated."
fi
TEMP_PATH=$folderbase/temp
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P5" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P5/$congterr
fi
cd $dump_path
pdfs=pdfs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $dump_path/log/$congterr$pdfs.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$pdfs.snar-0;then
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  echo "0" > $dump_path/log/$congterr$pdfs$level.txt
  echo "1" > $dump_path/log/$congterr$pdfs$nextlevel.txt
  archname=$congterr$pdfs.0.tar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$pdfs.snar-0 \
	  --file $dump_path/$archname \
	  -- Territory-PDFs
  ~/sysprocs/LOGMSG "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
  fi
  read -p "Enter ctl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
  oldsnar=$congterr$pdfs.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$pdfs$nextlevel.txt \
   > $dump_path/log/$congterr$pdfs$newlevel.txt
 file=$dump_path/log/$congterr$pdfs$nextlevel.txt
 echo "file = :'$file'"
 while read -e;do
  export archname=$congterr$pdfs.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file $dump_path/$archname \
	-- Territory-PDFs
  popd
done <$file
cp -p $dump_path/log/$congterr$pdfs$newlevel.txt $dump_path/log/$congterr$pdfs$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
fi
# end IncDumpPDFs
