#!/bin/bash
# ReloadSpecSC.sh  - Reload file(s) from archive of SCRaw subdirectories.
# 9/26/22.	wmk.
#
#	Usage. bash ReloadSpecSC <dbname> -u|-ou|-uo <mountname> [<statecountycongo>]
#
#		<dbname> = special database name (e.g. BayIndiesMHP)
#		-u|-ou|-uo = reload from unloadable device (flashdrive);
#			if 'o' present overwrite existing file(s) when reloading
#		<mountname>= mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/RawDataSC.n.tar - incremental dump of ./RawData/SCPA folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawDataSC/log/RawDataSC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/RawDataSClevel.txt - current level of incremental RawDataSC 
#	  archive files.
#
# Modification History.
# ---------------------
# 9/26/22.	wmk.	original code; adapted from ReloadSC.
# Legacy  mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/25/22.	wmk.	modified for CB use from previous original.
# Legacy mods.
# 6/12/22.	wmk.	original code; adapted from ReloadGeany.
# 7/31/22.	wmk.	! support for full reload (see notes).
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadSpecSC.sh performs a *tar* reload of the
# SCPA-Downloads subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# *dump_path, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file *dump_path/log/RawDataSC.snar is the listed-incremental archive
# information. The file *dump_path/*congterr/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
P1=$1		# filespec
P2=$2		# -o overwrite
P3=$3		# flashdrive mount name
P4=${4^^}	# state*county*congno
if [ -z "$P1" ];then
 echo "ReloadSpecSC <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
# P2 and P3 mandatory for CB reloads.
if [ -z "$P2" ] || [ -z "$P3" ];then
  echo "ReloadSpecSC <filespec> -u <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
  exit 1
fi
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadSpecSC <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadSpecSC <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadSpecSC abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadSpecSC abandoned, drive not mounted."
    exit 0
   fi
  fi
 fi
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
echo "P4 = : $P4"
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - ReloadSpecSC abandoned **"
# exit 1
#fi
# debugging code...
echo "P1 = : $P1"
echo "P2 = : $P2"
echo "P3 = : $P3"
echo "isList = $isList"
echo "P4 = : $P4"
echo "ReloadSpecSC parameter tests complete"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadSpecSC $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadSpecSC initiated."
else
  ~/sysprocs/LOGMSG "   ReloadSpecSC $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadSpecSC initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P3" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P3/$P4
fi
arch_path=${pathbase:1:50}
cd $dump_path
rawdatasc=RawDataSC
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$P4$rawdatasc.snar-0;then
  echo "** cannot locate $P4$rawdatasc.snar-0.. abandoned."
  exit 1
fi
# cat ./log/$P4$rawdatasc$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$P4$rawdatasc$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
echo "Reloading from $P4$rawdatasc.*.tar incremental dumps..."
pushd ./
cd $pathbase
 while read -e;do
   echo " Processing $rawdatasc.$REPLY.tar."
    tar --extract \
    --file=$dump_path/$P4$rawdatasc.$REPLY.tar \
    --wildcards  \
    $writeover \
    RawData/SCPA/SCPA-Downloads/Special/$P1
 done < $file
popd
exit 0
# end ReloadSpecSC.sh
