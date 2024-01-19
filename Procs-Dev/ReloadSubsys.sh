#!/bin/bash
echo " ** ReloadSubsys.sh out-of-date **";exit 1
# ReloadSubsys.sh  - Reload tar file(s) from archive of subsytem.
# 7/31/22.	wmk.
#
#	Usage. bash ReloadSubsys <subsystem>  <mountname> [-t]
#
#		<subsystem> = name of subsystem to reload (see also -t option)
#		mountname = mount name for flashdrive
#		-t (optional)= *territories flag; if included, the root directory is
#			assumed to be Territories/<state>/<county>/<congno>, derived
#			from the subsystem name (e.g. FLSARA86777 with -t will reload
#			to root directory /home/Territories/FL/SARA/86777
#			Also if -t is specified, <susbystem> will be automatically
#			 shifted to uppercase.
#
# Note: This shell should be resident the subsystem's root directory
# on any flash drive where the subsystem has .tar files. Either have
# IncDump .0. level copy the file automatically, or provide a shell
# that copies it...
#
# Dependencies.
#   *U_DISK - system path to removable (flash) drives.
#
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	~/<subsytem-root> has all .tar files reloaded from <mountname>
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TerrDatalevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 7/31/22.	wmk.	original code; adapted from ReloadGeany.
#
# Notes. ReloadSubsys.sh performs a *tar* reload of the
# TerrData subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# TerrData, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/TerrData.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
# function definition
# Note. some problems have occurred using jumpto with Chromeos...
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1		# subsystem
P2=$2		# flashdrive mount name
P3=$3		# optional -t
if [ -z "$P1" ] || [ -z "$P2" ];then
  echo "ReloadSubsys <subsys> <mountname> [-t] missing parameter(s) - abandoned."
 exit 1
fi
# if P3 is present must be -t
isTerr=0
if [ ! -z "$P3" ];then
 P3=${3,,}
 if [ "$P3" != "-t" ];then
  echo "ReloadSubsys <subsys> <mountname> [-t] unrecognized option - abandoned."
  exit 1
 fi
 ss=${1^^}
 P1=$ss
 isTerr=1
fi 
if ! test -d $U_DISK/$P2;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadSubsys abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  ReloadSubsys abandoned, drive not mounted."
    exit 0
   fi
fi
# always write over existing files.
# it is left to the user to decide if wants to clear root directory
#  before proceeding..
writeover=--overwrite
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$u_disk" ];then
 export u_disk=$U_DISK
fi
src_path=$u_disk/$P2/$P1/*
if [ $isTerr -eq 0 ];then
 targ_path=$HOME/$P1
else
 state=${P1:0:2}
 county=${P1:2:4}
 congno=${P1:6:20}
 targ_path=$HOME/Territories/$state/$county/$congno
fi
if [ $targ_path != $PWD ];then
 echo "ReloadSubsys MUST be run from $targ_path..."
 echo "  ReloadSubsys abandoned."
 exit 1
fi
# debugging code...
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "src_path = : '$src_path'"
echo "targ_path = : '$targ_path'"
echo "ReloadSubsys parameter tests complete"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadSubsys $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadSubsys initiated."
else
  ~/sysprocs/LOGMSG "   ReloadSubsys $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadSubsys initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
# we are running ReloadSubsys.sh from the target path...
# *src_path is the flash drive source folder
# *targ_path is the present working directory
# reload all folders & files resident on *src_path
echo "ReloadSubsys will overwrite all files on path"
echo " $targ_path..."
read -p "  Do you wish to continue (y/n)? "
yn=${REPLY^^}
if [ "$yn" != "Y" ];then
 echo "ReloadSubsys abandoned at user request."
 ~/sysprocs/LOGMSG "  ReloadSubsys abandoned at user request."
 exit
fi
cp -rpv $src_path $targ_path
echo "  ReloadSubsys complete."
~/sysprocs/LOGMSG "  ReloadSubsys complete."
# end ReloadSubsys.sh

