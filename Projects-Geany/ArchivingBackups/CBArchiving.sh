# CBArchiving.sh - Chromebooks archiving functions. 2/6/23. wmk.
#
# Modification History.
# ---------------------
# 9/19/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	DumpGeany,.. updated.
# 10/4/22.	wmk.	DumpGeany mismatched if-fi fixed.
# 11/16/22.	wmk.	listprocs "sourcefile" parameter added.
# 2/6/23.	wmk.	DumpBasic moved to Sandisk.sh
#
function listprocs(){
#list procs.sh
P1=$1
 if [ -z "$P1" ];then
  src_file=CBArchiving.sh
 else
  src_file=$P1  
 fi
 grep -e "[[:alpha:]]()" $codebase/Projects-Geany/ArchivingBackups/$src_file
}
# DumpGeany - full dump Chromebooks Geany projects.
function DumpGeany(){
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# DumpGeany.sh  - CB full archive of Geany subdirectories.
# 9/24/22.	wmk.
#
# Usage. DumpGeany -u SANDISK 
#
#	-u = dump to USB
#	SANDISK =  mandatory USB drive name
#
# Entry. *congterr env var set for congregation territory
#		  (e.g. =FLSARA86777)
#
# Dependencies.
#	~/TerritoriesCB/Projects-Geany - base directory for Geany projects
#
# Exit. *U_DISK/*P3/*congterr/CBGeany.0.tar = fuill dump of CB../Projects-Geany
#    or *codebase/CBGeany.0.tar = full dump of CB ../Projects-Geany
#
# Modification History.
# ---------------------
# 1/12/23.	wmk.	bug fixes for CB/sandisk.
# Legacy mods.
# 9/19/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support added for CB; comments tidied.
#
# Notes. DumpGeany.sh performs a full archive (tar) of the
# Projects-Geany subdirectories. 
P1=${1,,}
P2=${2^^}
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P1" ];then
 P1=${1,,}
if [ "$P1" != "-u" ];then
  echo "DumpGeany -u SANDISK [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-C to remain in Terminal: "
  exit 1
 fi
 if [ "$P2" != "SANDISK" ];then
  echo "DumpGeany -u SANDISK [<state><county><congo>] unrecognized USB mount-name - abandoned."
  read -p "Enter ctrl-C to remain in Terminal: "
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive];then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpGeany abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpGeany abandoned, drive not mounted."
    exit 0
   fi
 fi		# drive not mounted
fi
# end handle flash drive section.
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
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/SystemLog.txt
  ~/sysprocs/LOGMSG "   DumpGeany initiated from Make."
  echo "   DumpGeany initiated."
else
  ~/sysprocs/LOGMSG "   DumpGeany initiated from Terminal."
  echo "   DumpGeany initiated."
fi
TEMP_PATH=$folderbase/temp
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
  dump_path=$U_DISK/USB\ Drive/$congterr
cd $codebase
geany=CBGeany
  archname=$geany.0.tar
  echo $archname
   tar --create \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  Projects-Geany
  ~/sysprocs/LOGMSG "  DumpGeany complete."
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  DumpGeany complete."
echo "  DumpGeany complete."
# end DumpGeany
}
function ReloadGeany(){
# ReloadGeany.sh  - Reload file(s) from archive of Geany subdirectories.
# 1/12/23.	wmk.
#
#	Usage. bash ReloadGeany <filelist> [-o] [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/Geany.n.tar - incremental dump of ./Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Geany/log/Geany.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Geanylevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 1/12/23.	wmk.	bug fixes for CB/sandisk.
# Legacy mods.
# 5/2/22.	wmk.	original code.
# 9/19/22.	wmk.	modified to reload to TerritoriesCB in Chromebooks; source
#			 is GitHub/TerritoriesCB folder.
#
# Notes. ReloadGeany.sh performs a *tar* reload of the
# Geany subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Geany, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Geany.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
P1=$1
P2=$2
P3=$3
P4=${4^^}
if [ -z "$P1" ];then
 echo "ReloadGeany <filespec> -u|-ou|-uo SANDISK [<state><county><congno>] missing parameter(s) - abandoned."
 return 1
fi
fullreload=0
if [ "$P1" == "!" ];then
 fullreload=1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadGeany <filespec> -u|-ou|-uo SANDISK [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  return 1
fi
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadGeany <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/USB\ Drive;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadGeany abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    return 0
   else
    if ! test -d $U_DISK/USB\ Drive;then
     echo "  $P3 still not mounted - ReloadGeany abandoned."
     read -p "Enter ctrl-c to remain in Terminal:"
     return 1
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
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "ReloadGeany parameter tests complete"
#return 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadGeany initiated."
else
  LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadGeany initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
echo "pathbase = '$pathbase'"
cd $codebase
geany=Geany
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
 if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
# cat ./log/$congterr$geany$nextlevel.txt
 awk '{$1--; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
  echo "Reloading from $U_DISK/$P3/$P4/$P4$geany.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $U_DISK/USB\ Drive/$P4/$P4$geany.$REPLY.tar."
   pushd ./ > $TEMP_PATH/scratchfile
   cd $codebase
   if [ $fullreload -eq 1 ];then
    tar --extract \
    --file=$U_DISK/USB\ Drive/$P4/$P4$geany.$REPLY.tar \
    --wildcards \
     $writeover \
     Projects-Geany
   else
    tar --extract \
    --file=$U_DISK/USB\ Drive/$P4/$P4$geany.$REPLY.tar \
    --wildcards \
     $writeover \
     Projects-Geany/$P1
   fi
   popd > $TEMP_PATH/scratchfile
  done < $file
return 0
# end ReloadGeany.sh
}
function ReloadBasic(){
# ReloadBasic.sh  - Reload file(s) from archive of Basic subdirectories.
# 7/31/22.	wmk.
#
#	Usage. bash ReloadBasic <filelist> [-o] [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/Basic.n.tar - incremental dump of ./Basic folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Basic/log/Basic.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Basiclevel.txt - current level of incremental Basic 
#	  archive files.
#
# Modification History.
# ---------------------
# 5/2/22.	wmk.	original code.
# 7/31/22.	wmk.	! support for full reload (see notes).
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadBasic.sh performs a *tar* reload of the
# Basic subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Basic, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Basic.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
isAll=0
P1=$1
P2=$2
P3=$3
P4=${4^^}
if [ -z "$P1" ];then
 echo "ReloadBasic <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 return 1
fi
if [ "$P1" == "!" ];then
 isAll=1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadBasic <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  return 1
fi
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadBasic <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
 echo "** Chromebook does not support reloading from flash drives..."
 return 1
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadBasic abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadBasic abandoned, drive not mounted."
    return 0
   fi
  fi
 fi
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
echo "P4 = : $P4"
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
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
# return 1
#fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "isAll = $isAll"
#echo "ReloadBasic parameter tests complete"
#return 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadBasic $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadBasic initiated."
else
  ~/sysprocs/LOGMSG "   ReloadBasic $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadBasic initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
basic=Basic
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if [ -z "$congterr" ];then
 if ! test -f $pathbase/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  return 1
 fi
else
 if ! test -f $pathbase/log/$congterr$basic.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  return 1
 fi
fi
# cat ./log/$congterr$basic$nextlevel.txt
 awk '{$1--; print $0}' ./log/$congterr$basic$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 if [ -z "$P3" ];then
  echo "Reloading from $P4$basic.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $basic.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract --wildcards \
     $writeover \
     --file=$P4$basic.$REPLY.tar \
     $basic/$P1
   else
    tar --extract --wildcards \
     $writeover \
     --file=$P4$basic.$REPLY.tar \
     $basic
   fi
  done < $file
 else
  echo "Reloading from $U_DISK/$P3/$P4/$P4$basic.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $U_DISK/$P3/$P4/$P4$basic.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract --wildcards \
     $writeover \
     --file=$U_DISK/$P3/$P4/$P4$basic.$REPLY.tar \
     $basic/$P1
   else
    tar --extract --wildcards \
     $writeover \
     --file=$U_DISK/$P3/$P4/$P4$basic.$REPLY.tar \
     $basic
   fi
  done < $file
 fi
return 0
# end ReloadBasic.sh
}
function DumpProcs(){
# DumpProcs.sh  - Full archive of Chromebook Procs subdirectories.
# 9/20/22.	wmk.
#
#	Usage. bash DumpProcs
#
# Dependencies.
#	~/Territories/Procs - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/CBProcs.0.tar - full dump of ./Procs folders
#
# Modification History.
# ---------------------
# 9/19/22.	wmk.	original code; adapted from IncDumpProcs.
# 9/20/22.	wmk.	modified for Chromebook system.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from DumpTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. DumpProcs.sh performs a full archive (tar) of the
# Procs subdirectories.
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
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  LOGMSG "   DumpProcs initiated from Make."
  echo "   DumpProcs initiated."
else
  LOGMSG "   DumpProcs initiated from Terminal."
  echo "   DumpProcs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
basic=Procs
  archname=CB$basic.0.tar
  echo $archname
  tar --create \
	  --file=$archname \
	  Procs-Dev
  LOGMSG "  DumpProcs complete."
  echo "  DumpProcs complete."
  echo "** copy $archname to flash drive for backup."
# end DumpProcs
}
function ReloadProcs(){
# ReloadProcs.sh  - Reload file(s) from archive of Procs-Dev subdirectory.
# 9/20/22.	wmk.
#
#	Usage. bash ReloadProcs <filelist> [-o] [-u mountname] [<statecountycongo>]
#
#		<filespec> = file to reload or pattern to reload
#		-o = (optional) overwrite existing file(s) when reloading
#		-u = (optional) reload from unloadable device (flashdrive)
#		mountname (optional) = mount name for flashdrive
#		<statecountycongo> = (optional) tar archive base name
#							 default *congterr*
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Territories/Procs.n.tar - incremental dump of ./Procs folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/Procs/log/Procs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/Procslevel.txt - current level of incremental Procs 
#	  archive files.
#
# Modification History.
# ---------------------
# 8/4/22.	wmk.	original code; adapted from ReloadInclude.sh.
# 9/20/22.	wmk.	modified for Chromebooks.
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadProcs.sh performs a *tar* reload of the
# Procs-Dev subdirectory file(s). If the folder *pathbase*/*congterr*Procs/log does
# not exist under
# Procs, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Procs.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
# function definition
isAll=0
P1=$1
P2=$2
P3=$3
P4=${4^^}
if [ -z "$P1" ];then
 echo "ReloadProcs <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 return 1
fi
if [ "$P1" == "!" ];then
 isAll=1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadProcs <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  return 1
fi
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadProcs <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  echo "** Removable device reloading disabled on Chromebooks - abandoned."
  return 1
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadProcs abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadProcs abandoned, drive not mounted."
    return 0
   fi
  fi
 fi
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
echo "P4 = : $P4"
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
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
# return 1
#fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "isAll = $isAll"
#echo "ReloadProcs parameter tests complete"
#return 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadProcs $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadProcs initiated."
else
  ~/sysprocs/LOGMSG "   ReloadProcs $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadProcs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
procs=Procs
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if [ -z "$congterr" ];then
 if ! test -f $pathbase/log/$congterr$procs.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  return 1
 fi
else
 if ! test -f $pathbase/log/$congterr$procs.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  return 1
 fi
fi
# cat ./log/$congterr$procs$nextlevel.txt
 awk '{$1--; print $0}' ./log/$congterr$procs$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 if [ -z "$P3" ];then
  echo "Reloading from $P4$procs.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $procs.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract --wildcards \
     $writeover \
     --file=$P4$procs.$REPLY.tar \
     Procs-Dev/$P1
   else
    tar --extract --wildcards \
     $writeover \
     --file=$P4$procs.$REPLY.tar \
     Procs-Dev
   fi
  done < $file
 else
  echo "Reloading from $U_DISK/$P3/$P4/$P4$procs.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $U_DISK/$P3/$P4/$P4$procs.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    tar --extract --wildcards \
     $writeover \
     --file=$U_DISK/$P3/$P4/$P4$procs.$REPLY.tar \
     Procs-Dev/$P1
   else
    tar --extract --wildcards \
     $writeover \
     --file=$U_DISK/$P3/$P4/$P4$procs.$REPLY.tar \
     Procs-Dev
   fi
  done < $file
 fi
return 0
# end ReloadProcs.sh
}
