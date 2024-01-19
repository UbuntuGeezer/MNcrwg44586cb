#!/bin/bash
# ReloadAllSpecRU.sh  - Reload file(s) from archive of SCRaw subdirectories.
# 9/26/22.	wmk.
#
#	Usage. bash ReloadAllSpecRU  -u|-ou|-uo <mountname> [<statecountycongo>]
#
#		-u|-ou|-uo = reload from unloadable device (flashdrive);
#			if 'o' present overwrite existing file(s) when reloading
#		<mountname>= mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr
#
# Entry. SpecRUdblist.txt = list of Special .dbs to reload
#
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit. ReloadSpecRU.sh called for all Special dbs in SpecRUdblist.txt
#	SCPA-Downloads/Special/*.db reloaded; overwritten if -o specified.
#
# Modification History.
# ---------------------
# 9/26/22.	wmk.	original code; adapted from ReloadSpecRU.
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
# ReloadAllSpecRU.sh performs a *tar* reload of the
# SCPA-Downloads/Special subdirectory dbs. If the folder 
# *pathbase*/*congterr*/log does not exist under
# *dump_path, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file *dump_path/log/RawDataSC.snar is the listed-incremental archive
# information. The file *dump_path/*congterr/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
isList=0
P1=${1,,}		# -u|-uo|-ou
P2=$2		# flashdrive mount name
P3=${3^^}		# congpath
# P1 and P2 mandatory for CB reloads.
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "ReloadAllSpecRU -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
# to specify P3, P1, P2 must be present, and may not be empty strings.
if  [ ! -z "$P1" ] && $([ "${P1:1:1}" == "u" ] || [ "${P1:2:1}" == "u" ]) && [ -z "$P2" ];then
  echo "ReloadAllSpecRU  -u <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"		# -u|-uo|-ou
  echo "P2 = : $P2"		# mountname
  echo "P3 = : $P3"		# congterr
  exit 1
fi
if [ ! -z "$P1" ];then
 if [ "$P1" != "-u" ] && [ "$P1" != "-ou" ] && [ "$P1" != "-uo" ]];then
  echo "ReloadAllSpecRU [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P1:1:1}" == "u" ] || [ "${P1:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P2;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadAllSpecRU abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadAllSpecRU abandoned, drive not mounted."
    exit 0
   fi
  fi
 fi
fi
if [ "${P1:1:1}" == "o" ] || [ "${P1:2:1}" == "o" ] ;then
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
if [ -z "$P3" ];then
 P3=${congterr^^}
fi
echo "P3 = : $P3"
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - ReloadAllSpecRU abandoned **"
# exit 1
#fi
# debugging code...
echo "P1 = : $P1"
echo "P2 = : $P2"
echo "P3 = : $P3"
echo "ReloadAllSpecRU parameter tests complete"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadAllSpecRU $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadAllSpecRU initiated."
else
  ~/sysprocs/LOGMSG "   ReloadAllSpecRU $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadAllSpecRU initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#proc body here
# loop on SpecRUdblist.txt calling ReloadSpecRU.sh with parameters set.
projpath=$codebase/Projects-Geany/ArchivingBackups
file=$projpath/SpecRUdblist.txt
filecnt=0
while read -e;do
 dbname=$REPLY.db
 frstchar=${REPLY:0:1}
 if [ ${#dbname} -eq 0 ];then
  continue
 elif [ "$fstchar" == "#" ];then
  continue
 elif [ "$fstchar" == "$" ];then
  break
 fi
 filecnt=$((filecnt+1))
 $projpath/ReloadSpecRU.sh $dbname $P1 $P2
done < $file
echo "  ReloadAllSpecRU - $filecnt file(s) processed."
~/sysprocs/LOGMSG "  ReloadAllSpecRU $P1 $P2 complete."
echo "  ReloadAllSpecRU $P1 $P2 complete."
exit 0
# end ReloadAllSpecRU.sh
