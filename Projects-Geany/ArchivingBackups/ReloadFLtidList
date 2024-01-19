 #!/bin/bash
# ReloadFLtidList..sh  - reload Chromebook territory subdirectories from list.
# 11/22/22.	wmk.
#
# Usage. bash ReloadFLtidList <tidlist> [-o |[-ou-u <mount-name>]]
#
#	<tidlist> = file containing list of territory IDs to reload.
#	-o|-ou|-u = [optional] if u pesent, reload from USB flash drive
#				if o present, overwrite existing even if newer
#	<mount-name> = [optional, mandatory if -u present] mount name for flash drive	
#
# Entry. *pathbase/CBTerrxxx.0.tar = *tar archive of the following folders:
#			./RawData/RefUSA/RefUSA-Downloads/Terrxxx/*
#			./RawData//SCPA/SCPA-Downloads/Terrxxx
#			.TerrData/Terrxxx/*
#
# Exit.  [<filespec>] or ALL territory files reloaded from *pathbase/CBTerrxxx.0.tar
#			or *U_DISK/*P4/
#
# Dependencies.
#	~/Territories/RawData/RefUSA/RefUSA-Downloads - base directory for RefUSA Terrxxx data
#	~/Territories/RawData/SCPA/SCPA-Downloads - base directory for SCPA Terrxxx data
#	~/Territories/TerrData - base directory for publisher territory data
#
# Exit Results.
#	~/Territories/RawData/RefUSA/RefUSA-Downloads/Terrxxx reloaded
#	~/Territories/RawData/SCPA/SCPA-Downloads/Terrxxx reloaded
#	~/Territories/TerrData/Terrxxx reloaded 
#
# Modification History.
# ---------------------
# 11/22/22.	wmk.	original code; adpaped from ReloadFLTerr.
# Legacy mods.
# 11/17/22.	wmk.	exit handling improved to allow Terminal to continue.
# 11/22/22. wmk.	*pathbase corrected.
# Legacy mods.
# 9/24/22.	wmk.	original code; Adapted from ReloadProcs.
# 10/6/22.	wmk.	bug fixes; concatenate,s changed to 'extract' in tar reloads;
#			 *dump_path replaces *pathbase in tar sourcefile paths; *writeover
#			 included in tar parameter lists.
# Legacy mods.
# 9/19/22.	wmk.	original code; adapted from IncReloadTerr.
# 9/20/22.	wmk.	modified for Chromebook system.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from ReloadTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. ReloadFLtidList..sh performs reload from archive (tar) of the
# RefUSA, SCPA and TerrData subdirectories for the territories listed in
# <tidlist>. This is accommodates reloading Chromebook Territories batched
# as opposed to one at a time. If a line begins with '#' it is treated as
# a comment. The list terminates either with a line beginning with '$' or
# end-of-file.
# A full reload of all files for each territory listed
# is performed. (This accommodates full reload from a -u device).
isAll=0
P1=$1			# tidlist
P2=${2,,}		# -u -o -ou -uo
P3=$3			# mount name
if [ -z "$P1" ];then
 echo "ReloadFLtidList  <tidlist>  [-o [-ou|-uo|-u <mountname>]] missing parameter(s) - abandoned."
 read -p "Enter ctlr-c to remain in Terminal:"
 exit 1
fi
isAll=1
# handle flash drive section; P3 is -u, P4 is <mount-name>.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P2" ];then
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadFLtidList. <tidlist> [-o [-ou|-uo|-u <mountname>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P4 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadFLtidList. abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadFLtidList. abandoned, drive not mounted."
    read -p "Enter ctlr-c to remain in Terminal:"
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
# end flash drive section.
if [ -z "$congterr" ];then
   P5=FLSARA86777
else
   P5=$congterr
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
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadFLtidList. initiated from Make."
  echo "   ReloadFLtidList. initiated."
else
  ~/sysprocs/LOGMSG "   ReloadFLtidList. initiated from Terminal."
  echo "   ReloadFLtidList. initiated."
fi
echo "P1 = : '$P1'"	# tidlist
echo "P3 = : '$P2'"	# -u
echo "P4 = : '$P3'"	# <mount-name>
echo "P5 = : '$P5'"	# <state><county><congterr>
echo "writeover = : '$writeover'"	# overwrite option
echo "  end parameter tests..."
#read -p "Enter ctlr-c to remain in Terminal:"
#exit 0
TEMP_PATH="$folderbase/temp"
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P3" ];then
 dump_path=$U_DISK/$P3/$P5
else
 dump_path=$codebase
fi
terr=Terr
tid=$P1
# get list of CBTerr dumps.
# FLSARA86777Terr.*.tar from dump_path.
#ls -lh $dump_path/$congterr$terr.*.tar > $TEMP_PATH/TarList.lst
RUdata=RawDataRU
SCdata=RawDataSC
Terrdata=TerrData
ls -lh $dump_path/$congterr$RUdata.*.tar > $TEMP_PATH/TarList.lst
ls -lh $dump_path/$congterr$SCdata.*.tar >> $TEMP_PATH/TarList.lst
ls -lh $dump_path/$congterr$Terrdata.*.tar >> $TEMP_PATH/TarList.lst
mawk -F / '{print $7}' $TEMP_PATH/TarList.lst > $TEMP_PATH/TarList.txt
echo "Terr tar list on *TEMP_PATH/TarList.txt"
#read -p"ReloadFLtidList. paused; enter ctrl-c to remain in Terminal:"
#exit 0
# note. this is an unsorted list, but we depend on tar to keep newest
# by not using -o parameter.
#exit 0
#
# loop on territory IDs in <terrlist>
tidfile=$P1
file=$TEMP_PATH/TarList.txt
while read -e;do
 TID=$REPLY
 P1=$TID
 firstchar=${TID:0:1}
 tidlen=${#TID}
 if [ "$firstchar" != "#" ] && [ "$firstchar" != "$" ] && [ $tidlen -gt 0 ];then
# now loop on flinemames in *TEMP_PATH.TarList.txt
  while read -e;do
   archname=$REPLY
   pushd ./
   cd $pathbase
   echo " Processing $archname."
   # always a full reload..
    cd $pathbase
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$archname \
      -- RawData/RefUSA/RefUSA-Downloads/Terr$P1
    cd $pathbase
    tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Terr$P1
    cd $pathbase
    tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1
    popd
  done < $file		# loop on dump files
 elif [ "$firstchar" == "$" ];then		# either '#' or '$'
  break
 fi		# continue
done < $tidfile		# loop on territory IDs
popd
~/sysprocs/LOGMSG "  ReloadFLtidList. $P1 $P2 $P3 complete."
echo "  ReloadFLtidList. $P1 $P2 $P3 complete."
# end ReloadFLtidList.
