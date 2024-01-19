 #!/bin/bash
# ExtractTerr.sh  - reload Chromebook territory subdirectories from *congterr dump.
# 9/24/22.	wmk.
#
# Usage. bash ExtractTerr <terrid> -ou|-uo|u <mount-name>
#
#	<terrid> = territory id for which to perform *tar reload.
#	-o|-ou|-u = reload from USB flash drive
#				if o present, overwrite existing even if newer
#	<mount-name> = mount name for flash drive	
#
# Entry. *U_DISK/<mount-name>/*congterr/*congterrRawDataRU.*.tar = RefUSA *tar archive
#		 *U_DISK/<mount-name>/*congterr/*congterrRawDataSC.*.tar = SCPA *tar archive
#		 *U_DISK/<mount-name>/*congterr/*congterrTerrData.*.tar = TerrData *tar archive
#		 *U_DISK/<mount-name>/*congterr/log = incremental dump log
#
# Exit.  specified territory reloaded from incremental dumps listed in "Entry" section
#
# Calls. ReloadRURaw, ReloadSCRaw, ReloadTerrData shells
#
# Exit Results.
#	~/Territories/RawData/RefUSA/RefUSA-Downloads/Terrxxx reloaded
#	~/Territories/RawData/SCPA/SCPA-Downloads/Terrxxx reloaded
#	~/Territories/TerrData/Terrxxx reloaded 
#
# Modification History.
# ---------------------
# 9/24/22.	wmk.	original code; Adapted from ReloadTerr.
# Legacy mods.
# 9/19/22.	wmk.	original code; adapted from IncExtractTerr.
# 9/20/22.	wmk.	modified for Chromebook system.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from ExtractTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. ExtractTerr.sh performs a full incremental archive reload (tar) of the
# RefUSA, SCPA and TerrData subdirectories for the Territory.
P1=$1			# territory id
P2=${2,,}		# -u -o -ou -uo		
P3=$3			# mount name
P4=$4			# congterr
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ExtractTerr <terrid> -ou|-uo|-u <mountname> [<state><county><congo>] missing parameter(s) - abandoned."
 exit 1
fi
# handle flash drive section; P2 is -u, P3 is <mount-name>.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P2" ];then
 if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ];then
  echo "ExtractTerr <terrid> <filespec> -ou|-uo|-u <mountname> [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadProcs abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadProcs abandoned, drive not mounted."
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
if [ -z "$P4" ];then
 if [ -z "$congterr" ];then
   P4=FLSARA86777
 else
   P4=$congterr
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
  ~/sysprocs/LOGMSG "   ExtractTerr initiated from Make."
  echo "   ExtractTerr initiated."
else
  ~/sysprocs/LOGMSG "   ExtractTerr initiated from Terminal."
  echo "   ExtractTerr initiated."
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "  end parameter tests..."
#exit 0
TEMP_PATH="$folderbase/temp"
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ ! -z "$P4" ];then
 dump_path=$U_DISK/$P4/$P5
else
 dump_path=$pathbase
fi
terr=Terr
tid=$P1
archname=CB$terr$tid.0.tar
echo $archname
if [ -z "$P2" ];then
 if [ 1 -eq 0 ];then
  cd $pathbase/RawData/RefUSA
  tar --extract \
      --file $pathbase/$archname \
      -- RefUSA-Downloads/Terr$P1
 fi
 if [ 1 -eq 0 ];then
  cd $pathbase/RawData/SCPA
  tar --concatenate \
      --file $pathbase/$archname \
      -- SCPA-Downloads/Terr$P1
  cd $pathbase
 fi
 if [ 1 -eq 0 ];then
  tar --concatenate \
      --file $pathbase/$archname \
      -- TerrData/Terr$P1
 fi
else	# have <filespec>
 if [ 1 -eq 0 ];then
  cd $pathbase/RawData/RefUSA
  tar --extract \
      --file $pathbase/$archname \
      -- RefUSA-Downloads/Terr$P1/$P2
 fi
 if [ 1 -eq 0 ];then
  cd $pathbase/RawData/SCPA
  tar --concatenate \
      --file $pathbase/$archname \
      -- SCPA-Downloads/Terr$P1/$P2
 fi
 if [ 1 -eq 1 ];then
  cd $pathbase
  $codebase/Projects-Geany/ArchivingBackups/ReloadTerrData.sh $P1 -u $P3
   #tar --extract\
   #   --file $dump_path/$archname \
   #   -- TerrData/Terr$P1/$P2
 fi
fi
popd
~/sysprocs/LOGMSG "  ExtractTerr $P1 $P2 $P3 $P4 $P5 complete."
echo "  ExtractTerr $P1 $P2 $P3 $P4 $P5 complete."
# end ExtractTerr
