 #!/bin/bash
# ReloadFLTerr.sh  - reload Chromebook territory subdirectories.
# 12/19/22.	wmk.
#
# Usage. bash ReloadTerr <terrid> [<filespec>] [-o |[-ou-u <mount-name>]]
#
#	<terrid> = territory id for which to perform *tar reload.
#	<filespec> = (optional) file(s) spec to reload for territory
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
# 11/17/22.	wmk.	exit handling improved to allow Terminal to continue.
# 11/22/22. wmk.	*pathbase corrected.
# 12/12/22.	wmk.	list of dumps comment corrected; ListTerrDBs.sh shell
#			 documented.
# 12/15/22.	wmk.	SC and RU/Special .dbs added to reloads to ensure special
#			 dbs in place for Territory builds.
# 12/19/22.	wmk.	pushd inside loop corrected.
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
# Notes. ReloadFLTerr.sh performs reload from archive (tar) of the
# RefUSA, SCPA and TerrData subdirectories for the Territory <terrid>. This is
# because the Chromebook Territories implementation is limited to working on
# one congregation's territory at a time.
# If the <filespec> paramter is '!' a full reload of all files for the territory
# is performed. (This accommodates full reload from a -u device).
#
# /RefUSA-Downloads/Special/ListTerrDBs.sh is a shell that will list the .dbs
# that are used by any given territory id.
#   ./ListTerrDBs.sh <terrid>
# /RefUSA-Downloads/Special/ListDBTerrs.sh is a shell that will listt all the
# territories that are dependent upon any give <special-db>
#	./ListDBTerrs.sh <spec-db>
#
# The shell ReloadSpecDBTerrs.sh shell will reload all territories using any
# give <special-db>.
#	./ReloadeSpecDBTerrs.sh <spec-db>
#
isAll=0
P1=$1			# territory id
P2=$2			# filespec
P3=${3,,}		# -u -o -ou -uo
P4=$4			# mount name
P5=${5^^}		# congterr
if [ -z "$P1" ];then
 echo "ReloadFLTerr <terrid> <filespec> [-o [-ou|-uo|-u <mountname>] [<state><county><congo>] missing parameter(s) - abandoned."
 read -p "Enter ctlr-c to remain in Terminal:"
 exit 1
fi
if [ "$P2" == "!" ];then
 isAll=1
else
 isAll=0
fi
# handle flash drive section; P3 is -u, P4 is <mount-name>.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P3" ];then
 if [ "$P3" != "-u" ] && [ "$P3" != "-ou" ] && [ "$P3" != "-uo" ]&& [ "$P3" != "-o" ];then
  echo "ReloadFLTerr <terrid> <filespec> [-o [-ou|-uo|-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P3:1:1}" == "u" ] || [ "${P3:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P4;then
   echo "** $P4 not mounted - mount $P4..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadFLTerr abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadFLTerr abandoned, drive not mounted."
    read -p "Enter ctlr-c to remain in Terminal:"
    exit 0
   fi
  fi
 fi
fi
if [ "${P3:1:1}" == "o" ] || [ "${P3:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
# end flash drive section.
if [ -z "$P5" ];then
 if [ -z "$congterr" ];then
   P5=FLSARA86777
 else
   P5=$congterr
 fi
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
  ~/sysprocs/LOGMSG "   ReloadFLTerr initiated from Make."
  echo "   ReloadFLTerr initiated."
else
  ~/sysprocs/LOGMSG "   ReloadFLTerr initiated from Terminal."
  echo "   ReloadFLTerr initiated."
fi
echo "P1 = : '$P1'"	# terrid
echo "P2 = : '$P2'"	# filespec
echo "P3 = : '$P3'"	# -u
echo "P4 = : '$P4'"	# <mount-name>
echo "P5 = : '$P5'"	# <state><county><congterr>
echo "writeover = : '$writeover'"	# overwrite option
echo "  end parameter tests..."
#read -p "Enter ctlr-c to remain in Terminal:"
#exit 0
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P4" ];then
 dump_path=$U_DISK/$P4/$P5
else
 dump_path=$pathbase
fi
terr=Terr
tid=$P1
# get list of RawDataRU, RawDataSC, TerrData dumps.
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
#read -p"ReloadFLTerr paused; enter ctrl-c to remain in Terminal:"
#exit 0
# note. this is an unsorted list, but we depend on tar to keep newest
# by not using -o parameter.
#exit 0
# now loop on flinemames in *TEMP_PATH.TarList.txt
file=$TEMP_PATH/TarList.txt
while read -e;do
  archname=$REPLY
  pushd ./
  cd $pathbase
  echo " Processing $archname."
  if [ -z "$P2" ] || [ $isAll -ne 0 ];then
   cd $pathbase
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$archname \
      -- RawData/RefUSA/RefUSA-Downloads/Terr$P1
   cd $pathbase
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$archname \
      -- RawData/RefUSA/RefUSA-Downloads/Special
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Terr$P1
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Special
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1
  else		# have filespec
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RawData/RefUSA/RefUSA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1/$P2
  fi
  popd
done < $file
popd
~/sysprocs/LOGMSG "  ReloadFLTerr $P1 $P2 $P3 $P4 $P5 complete."
echo "  ReloadFLTerr $P1 $P2 $P3 $P4 $P5 complete."
# end ReloadFLTerr
