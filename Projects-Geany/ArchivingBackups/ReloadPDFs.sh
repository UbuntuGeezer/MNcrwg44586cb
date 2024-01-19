#!/bin/bash
# ReloadPDFs.sh  - Reload file(s) from archive of Geany subdirectories.
# 10/10/22.	wmk.
#
#	Usage. bash ReloadPDFs <filelist> [-o |[-ou|-uo | -u mountname] [<statecountycongo>]
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
#	/Territories/*congterr*pdfs.n.tar - incremental dump of ./Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/log/*pdfs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/*congterr*pdfslevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 10/10/22. wmk.	original code; adapted from ReloadGeany.
# Legacy mods.
# 5/2/22.	wmk.	original code.
# 7/31/22.	wmk.	! support for full reload (see notes).
# 8/10/22.	wmk.	use *dump_path for sourcing.
# 8/12/22.	wmk.	ensure on *pathbase when tar running.
#
# Notes. 8/12/22. Whenever *tar* is run, it is run from the *pathbase folder. This
# enables dumping and loading to/from the *pathbase folder with the dump paths only
# containing the relevant downstream folder names.
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadPDFs.sh performs a *tar* reload of the
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
# function definition
isAll=0
P1=$1			# <filespec>
P2=$2			# [ -o | -u | -uo ]
P3=$3			# <mount-name>
P4=${4^^}		# <state><county><congno> (*congterr)
if [ -z "$P1" ];then
 echo "ReloadPDFs <filespec> [-u|-ou|-uo <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" == "!" ];then
 isAll=1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadPDFs <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"	# filespec
  echo "P2 = : $P2"	# -o -uo -ou -u
  echo "P3 = : $P3"	# <mount-name>
  echo "P4 = : $P4"	# <state><county><congno>
  exit 1
fi
if [ ! -z "$P2" ];then
 P2=${2,,}
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadPDFs <filespec> [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadPDFs abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadPDFs abandoned, drive not mounted."
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
echo "P4 = : $P4"
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
if [ -z "$P4" ];then
 P4=${congterr^^}
fi
#if [ "$P4" != "$congterr" ];then
# echo "*congterr* = :$congterr"
# echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
# exit 1
#fi
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "isAll = $isAll"
#echo "ReloadPDFs parameter tests complete"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadPDFs $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadPDFs initiated."
else
  ~/sysprocs/LOGMSG "   ReloadPDFs $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadPDFs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P3" ];then
 dump_path=$pathbase
else
 dump_path=$U_DISK/$P3/$P4
fi
arch_path=${pathbase:1:50}
pdfs=pdfs
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
 if ! test -f $dump_path/log/$congterr$pdfs.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
 fi
# cat ./log/$congterr$pdfs$nextlevel.txt
 awk '{$1--; print $0}' $dump_path/log/$congterr$pdfs$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
 file=$TEMP_PATH/LastTarLevel.txt
 while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
  echo "Reloading from $P4$pdfs.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $pdfs.$REPLY.tar."
    pushd ./
    cd $pathbase
   if [ $isAll -eq 0 ];then
    tar --extract \
     --file=$dump_path/$P4$pdfs.$REPLY.tar \
     --wildcards    \
     $writeover \
    -- Territory-PDFs/$P1
   else
    tar --extract \
     --file=$dump_path/$P4$pdfs.$REPLY.tar \
     --wildcards    \
     $writeover \
    -- Territory-PDFs
   fi
   popd
  done < $file
echo "  ReloadPDFs $P1 $P2 $P3 $P4 complete."
~/sysprocs/LOGMSG "  ReloadPDFs $P1 $P2 $P3 $P4 complete."
exit 0
# end ReloadPDFs.sh

