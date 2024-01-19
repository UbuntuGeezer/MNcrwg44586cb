#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# ReloadInclude.sh  - Reload file(s) from MNCRWG44586 archive of Procs subdirectories.
# 8/16/23.	wmk.
#
#	Usage. bash ReloadInclude <filelist> [-o] [-u mountname] [<statecountycongo>]
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
#	*codebase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#
# Exit Results.
#	/TerritoriesCB/Procs-Dev - reloaded from dump of ./Procs folders
#    resident in *congterr/FLSARA86777Procs.*.tar files
#   Note. the files are reloaded from the FLSARA86777 dump to support the case
#    where essential .sh files were missing for builds on the Chromebook.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted from ReloadFLProcs.
# Legacy mods.
# 10/4/22.	wmk.	original code; adapted from ReloadProcs.
# 10/10/22.	wmk.	bug fix; *codepath corrected to *codebase.
# 5/13/23.	wmk.	bug fix; *isAll was not tested in tar reloads; *pathbase
#			 corrected to FL/SARA/86777.
# Legacy mods.
# 9/20/22.	wmk.	modified for Chromebook.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support for CB; *U_DISK env var definition
#			 ensured; comments tidied.
# 10/4/22.	wmk.	documentation corrected for Procs-Dev from Projects-Geany;
#			 LOGMSG path corrected; tar reload path Procs-Dev corrected.
# Legacy mods.
# 5/2/22.	wmk.	original code.
# 7/31/22.	wmk.	! support for full reload (see notes).
# 9/20/22.	wmk.	-u, <mountname> support.
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadInclude.sh performs a *tar* reload of the
# Procs subdirectory file(s).
P1=$1
P2=${2,,}
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadInclude <filespec> -u|-ou|-uo <mountname> [<state><county><congno>] missing parameter(s) - abandoned."
 exit 1
fi
isAll=0
if [ "$P1" == "!" ];then
 isAll=1
fi
# if P2 is present, P3 must also.
# to specify P, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadInclude <filespec> [-u <mountname>] [<state><county><congno>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  exit 1
fi
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadInclude <filespec> -u <mountname> [<state><county><congo>] unrecognized '-' option - abandoned."
fi
if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadInclude abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  ReloadInclude abandoned, drive not mounted."
    exit 0
    if ! test -d $U_DISK/$P3;then
     echo "$P3 still  not mounted. - ReloadInclude abandoned."
     exit 1
    fi
    echo "  continuing with $P3 mounted.."
   fi
  else
   echo "  continuing with $P3 mounted.."
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
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$congterr" ];then
 export congterr=MNCR2G44586
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
#echo "ReloadInclude parameter tests complete"
#exit 0
# end debugging code.
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadInclude $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadInclude initiated."
else
  ~/sysprocs/LOGMSG "   ReloadInclude $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadInclude initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ >  /dev/null
dump_path=$U_DISK/$P3/$P4
incl=Include
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$congterr$incl.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
fi
# cat ./log/$congterr$basic$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$congterr$incl$nextlevel.txt \
  > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
file=$TEMP_PATH/TarLevelList.txt
echo "Reloading from $P4$incl.*.tar incremental dumps..."
while read -e;do
   pushd ./ > /dev/null
   cd $codebase
   if [ $isAll -eq 0 ];then
    echo " Processing $incl.$REPLY.tar."
    tar --extract --wildcards \
     $writeover \
    --file=$dump_path/$P4$incl.$REPLY.tar \
    include/$P1
   else
    tar --extract --wildcards \
     $writeover \
    --file=$dump_path/$P4$incl.$REPLY.tar \
     include
   fi
   popd	> /dev/null
done < $file
exit 0
# end ReloadInclude.sh
