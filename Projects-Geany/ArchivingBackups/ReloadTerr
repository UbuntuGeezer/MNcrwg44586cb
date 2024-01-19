 #!/bin/bash
# ReloadTerr.sh  - reload Chromebook territory subdirectories.
# 11/29/22.	wmk.
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
# 11/17/22.	wmk.	exit handling improved allowing Terminal to continue.
# 11/29/22.	wmk.	bug fix reloading with Specials.
# Legacy mods.
# 9/24/22.	wmk.	original code; Adapted from ReloadProcs.
# 10/6/22.	wmk.	bug fixes; concatenate,s changed to 'extract' in tar reloads;
#			 *dump_path replaces *pathbase in tar sourcefile paths; *writeover
#			 included in tar parameter lists.
# 10/13/22.	wmk.	bug fix 'CB' qualifier added to tar dump list extraction.
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
# Notes. ReloadTerr.sh performs reload from archive (tar) of the
# RefUSA, SCPA and TerrData subdirectories for the Territory <terrid>. This is
# because the Chromebook Territories implementation is limited to working on
# one congregation's territory at a time.
# If the <filespec> paramter is '!' a full reload of all files for the territory
# is performed. (This accommodates full reload from a -u device).
isAll=0
P1=$1			# territory id
P2=$2			# filespec
P3=${3,,}		# -u -o -ou -uo
P4=$4			# mount name
P5=${5^^}		# congterr
if [ -z "$P1" ];then
 echo "ReloadTerr <terrid> <filespec> [-o [-ou|-uo|-u <mountname>] [<state><county><congo>] missing parameter(s) - abandoned."
 read -p "Press ctrl-c to remain in Terminal:"
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
  echo "ReloadTerr <terrid> <filespec> [-o [-ou|-uo|-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P3:1:1}" == "u" ] || [ "${P3:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P4;then
   echo "** $P4 not mounted - mount $P4..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadProcs abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadProcs abandoned, drive not mounted."
    read -p "Press ctrl-c to remain in Terminal:"
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
 pathbase=$folderbase/Territories
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadTerr initiated from Make."
  echo "   ReloadTerr initiated."
else
  ~/sysprocs/LOGMSG "   ReloadTerr initiated from Terminal."
  echo "   ReloadTerr initiated."
fi
echo "P1 = : '$P1'"	# terrid
echo "P2 = : '$P2'"	# filespec
echo "P3 = : '$P3'"	# -u
echo "P4 = : '$P4'"	# <mount-name>
echo "P5 = : '$P5'"	# <state><county><congterr>
echo "writeover = : '$writeover'"	# overwrite option
echo "  end parameter tests..."
# read -p "Press ctrl-c to remain in Terminal:"
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
# get list of CBTerr dumps.
# FLSARA86777Terr.*.tar from dump_path.
ls -lh $dump_path/CB$terr$tid.*.tar > $TEMP_PATH/TarList.lst
mawk -F / '{print $7}' $TEMP_PATH/TarList.lst > $TEMP_PATH/TarList.txt
echo "Terr tar list on *TEMP_PATH/TarList.txt"
# note. this is an unsorted list, but we depend on tar to keep newest
# by not using -o parameter.
#exit 0
archname=CBTerr$P1.0.tar
pushd
cd $pathbase/RawData
  if [ -z "$P2" ] || [ $isAll -ne 0 ];then
   cd $pathbase/RawData
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$archname \
      -- RefUSA/RefUSA-Downloads/Terr$P1
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- SCPA/SCPA-Downloads/Terr$P1
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1
  else		# have filespec
   cd $pathbase/RawData
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RefUSA/RefUSA-Downloads/Terr$P1/$P2
   cd $pathbase/RawData/SCPA
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- SCPA/SCPA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1/$P2
  fi
popd
#############################################################
if [ 1 -eq 0 ];then
# now loop on flinemames in *TEMP_PATH.TarList.txt
file=$TEMP_PATH/TarList.txt
while read -e;do
  archname=$REPLY
  pushd
  cd $pathbase
  echo " Processing $archname."
  if [ -z "$P2" ] || [ $isAll -ne 0 ];then
   cd $pathbase/RawData/RefUSA
    tar --extract --wildcards \
     $writeover \
     --file=$dump_path/$archname \
      -- RefUSA-Downloads/Terr$P1
   cd $pathbase/RawData/SCPA
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- SCPA-Downloads/Terr$P1
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1
  else		# have filespec
   cd $pathbase/RawData/RefUSA
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- RefUSA-Downloads/Terr$P1/$P2
   cd $pathbase/RawData/SCPA
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- SCPA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $dump_path/$archname \
      $writeover \
      -- TerrData/Terr$P1/$P2
  fi
  popd
done < $file
fi
#############################################################
popd
~/sysprocs/LOGMSG "  ReloadTerr $P1 $P2 $P3 $P4 $P5 complete."
echo "  ReloadTerr $P1 $P2 $P3 $P4 $P5 complete."
# end ReloadTerr
