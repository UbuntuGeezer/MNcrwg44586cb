#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# ReloadGeany.sh  - Reload file(s) from full archive of Geany.
# 9/24/22.	wmk.
#
#	Usage. bash ReloadGeany <filelist> [-o |[-ou|-uo | -u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload; may be a project name
#			e.g. ArchivingBackups, ArchivingBackups/ReloadGeany.sh
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*codebase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#
# Exit Results.
#	/TerritoriesCB/Projects-Geany - reloaded from dump of ./Geany folders
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support for CB; *U_DISK env var definition
#			 ensured; comments tidied.
# Legacy mods.
# 5/2/22.	wmk.	original code.
# 7/31/22.	wmk.	! support for full reload (see notes).
# 8/10/22.	wmk.	use *dump_path for sourcing.
# 8/12/22.	wmk.	ensure on *pathbase when tar running.
#
# Notes. 8/12/22. Whenever *tar* is run, it is run from the *codebase folder. This
# enables dumping and loading to/from the *codebase folder with the dump paths only
# containing the relevant downstream folder names.
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadGeany.sh performs a *tar* reload of the Projects-Geany subdirectory file(s).
isAll=0
P1=$1			# <filespec>
P2=$2			# [ -o | -u | -uo ]
P3=$3			# <mount-name>
P4=${4^^}		# <state><county><congno> (*congterr)
if [ -z "$P1" ];then
 echo "ReloadGeany <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" == "!" ];then
 isAll=1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadGeany <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"	# filespec
  echo "P2 = : $P2"	# -o -uo -ou -u
  echo "P3 = : $P3"	# <mount-name>
  echo "P4 = : $P4"	# <state><county><congno>
  exit 1
fi
# begin flash drive section.
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadGeany <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadGeany abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadGeany abandoned, drive not mounted."
    exit 0
   fi
  fi
 fi
fi
# end handle flash drive section.
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
echo "P4 = : $P4"
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "isAll = $isAll"
#echo "ReloadGeany parameter tests complete"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadGeany initiated."
else
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadGeany initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P3" ];then
 dump_path=$U_DISK/$P3/$P4
else
 dump_path=$codebase
fi
geany=Geany
archname=CB$geany.0.tar
echo " Processing $archname."
pushd ./
cd $codebase
if [ $isAll -eq 0 ];then
    tar --extract \
     --file=$dump_path/$archname \
     --wildcards    \
     $writeover \
    Projects-Geany/$P1
else
    tar --extract \
     --file=$dump_path/$archname \
     --wildcards    \
     $writeover \
    Projects-Geany
fi
popd
#endprocbody
echo "  ReloadGeany $P1 $P2 $P3 $P4 complete."
~/sysprocs/LOGMSG "  ReloadGeany $P1 $P2 $P3 $P4 complete."
exit 0
# end ReloadGeany.sh

