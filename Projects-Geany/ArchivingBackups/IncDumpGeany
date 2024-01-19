#!/bin/bash
# IncDumpGeany.sh  - Incremental archive of Geany subdirectories.
# 8/15/23.	wmk.
#
#	Usage. bash IncDumpGeany <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		<mount-name> = removable media mount name
#
# Dependencies.
#	~/TerritoriesCB/Projects-Geany - base directory for Geany projects
#	~/TerritoriesCB/.log - tar log subfolder for tracking incremental
#	  dumps
#  *sysid = system ID - CB (Chromebook), HP (HP Pavilion)
#
# Exit Results. Note - if -u <mount-name> is specfied the flash drive path
#  is substituted for *TerritoriesCB* below.
#	/TerritoriesCB/Geany.n.tar - incremental dump of ./Projects-Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/TerritoriesCB/log/Geany.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/TerritoriesCB/log/Geanylevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/15/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 10/30/22.	wmk.	bug fix where *pathbase used > *codebase.
# 11/1/22.	wmk.	bug fix where level-0 dump going to archname instead of to
#			 *archname; comments corrected; error messages corrected.
# 11/1/22.	wmk.	*sysid support; *codebase support.
# 11/18/22.	wmk.	*sysid support pulled.
# 1/13/23.	wmk.	jumpto references removed.
# 3/27/23.	wmk.	verify dump prompt added.
# 5/20/23.	wmk.	"continuing" message echo corrected.
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
# Notes. IncDumpGeany.sh performs an incremental archive (tar) of the
# Projects-Geany subdirectories. If the folder ./log does not exist under
# Territories, it is created and a level-0 incremental dump is performed.
# A shell utility RestartGeany.sh is provided to reset the Geany dump
# information so that the next IncDumpGeany run will produce the level-0
# (full) dump.
# Note. 8/11/22. Starting with this date, the .tar paths are full paths which
# include the *pathbase prefix. This is to avoid confusion in the reload
# process when a removable media is being used.
# The file ./log/$P1$P2$P3Geany.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpGeany calls. The initial archive file is named
# $P1$P2$P3Geany.0.tar.
# If the ./log folder exists under Geany a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named $P1$P2$P3Geany.snar-n, where n is the
# next level # obtained by incrementing ./log/$P1$P2$P3Geanylevel.txt. tar will be
# invoked with this new Geany.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -U
P5=$5			# mount-name
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpGeany <state> <county> <congno> -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** IncDumpGeany <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P5;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpGeany abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P5;then
    echo "$P5 still not mounted - IncDumpGeany abandoned."
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
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCRWG44586
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpGeany abandoned **"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Make."
  echo "   IncDumpGeany initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Terminal."
  echo "   IncDumpGeany initiated."
fi
TEMP_PATH=$folderbase/temp
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P5/$congterr
cd $dump_path
geany=Geany
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $dump_path/log/$congterr$geany.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$congterr$geany.snar-0;then
  # initial archive
  echo "0" > $dump_path/log/$congterr$geany$level.txt
  echo "1" > $dump_path/log/$congterr$geany$nextlevel.txt
  archname=$congterr$geany.0.tar
  echo $archname
  pushd ./ > /dev/null
  cd $codebase
  tar --create \
	  --listed-incremental=$dump_path/log/$congterr$geany.snar-0 \
	  --file=$dump_path/$archname \
	  Projects-Geany
  ~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  popd > /dev/null
  echo "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "  $archname verify complete."
  fi
  exit 0
fi
# this is a level-1 tar incremental.
  oldsnar=$congterr$geany.snar-0
 awk '{$1++; print $0}' $dump_path/log/$congterr$geany$nextlevel.txt \
   > $dump_path/log/$congterr$geany$newlevel.txt
 file=$dump_path/log/$congterr$geany$nextlevel.txt
 echo "file = :'$file'"
 while read -e;do
  export archname=$congterr$geany.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./ >/dev/null
  cd $codebase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	Projects-Geany
  popd > /dev/null
done <$file
cp $dump_path/log/$congterr$geany$newlevel.txt $dump_path/log/$congterr$geany$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
 tar --list --file $dump_path/$archname
echo "  $archname verify complete."
fi
# end IncDumpGeany
