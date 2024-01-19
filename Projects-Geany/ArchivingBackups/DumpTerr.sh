#!/bin/bash
# DumpTerr.sh  - Full archive of Chromebook Procs subdirectories.
# 12/11/22.	wmk.
#
# Usage. bash DumpTerr <terrid> [-u <mount-name>] [<congterr>]
#
#	<terrid> = territory id for which to perform *tar archiving
#	-u = dump to USB flash drive
#	<mount-name> = (optional, mandatory if -u present) flash drive mount name
#	<congterr> = (optional) congregation territory <state><county<congno>
#				e.g FLSARA86777
# Exit. *pathbase/CBTerrxxx.0.tar = *tar archive of the following folders:
#			./RawData/RefUSA/RefUSA-Downloads/Terrxxx/*
#			./RawData//SCPA/SCPA-Downloads/Terrxxx
#			.TerrData/Terrxxx/*
#
# Dependencies.
#	~/Territories/RawData/RefUSA/RefUSA-Downloads - base directory for RefUSA Terrxxx folders
#	~/Territories/RawData/SCPA/SCPA-Downloads - base directory for SCPA Terrxxx folders
#	~/Territories/TerrData - base directory for TerrData Terrxxx folders
#
# Exit Results.
#	/Territories/CBTerrxxx.0.tar 
# or *U_DISK/<mount-name>/*congterr/CBTerrxxx.0.tar = full dump of RefUSA, SCPA, TerrData
#   folders for territory xxx.
#
# Modification History.
# ---------------------
# 9/25/22.	wmk.	original code; Adapted from DumpProcs; documentation
#			 improved; exit handling improved to allow Terminal to continue.
# 11/16/22.	wmk.	error message corrections.
# 11/29/22.	wmk.	/Special databases archived with territory.
# 12/5/22.	wmk.	Special/<special-db>Tidy.sql archived with territory.
# 12/6/22.	wmk.	SC-/Special/<special-db>Tidy.sql, Make.<special-db>.Terr
#			 archived with territory.
# 12/11/22.	wmk.	path corrections dumping Special dbs.
# Legacy mods.
# 9/19/22.	wmk.	original code; adapted from IncDumpTerr.
# 9/20/22.	wmk.	modified for Chromebook system.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from DumpTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. DumpTerr.sh performs a full archive (tar) of the
# RefUSA, SCPA and TerrData subdirectories for the Territory. The dump is
# performed to the ~/Territory folder (as opposed to the Territories/FL/SARA/86777
# folder on the "origin" system). This is because the Chromebook Territories
# implementation is limited to working on one congregation's territory at a time.
P1=$1			# terrid
P2=${2,,}		# -u
P3=$3			# mount name
P4=${4^^}		# congterr <state><county><congno>
if [ -z "$P1" ];then
 echo "DumpTerr <terrid> [-u <mount-name>] [<congterr>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remainm in Terminal:"
 exit 1
fi
if [ -z "$P5" ];then
 P5=FLSARA86777
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
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P2" ];then
#  if [ "$P2" != "-u" ];then
 if [ "$P2" != "-u" ];then
  echo "DumpTerr <terrid> [-u <mount-name>] [<congterr>]  unrecognized '-' option - abandoned."
 read -p "Enter ctrl-c to remainm in Terminal:"
 exit 1
 fi
 if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpTerr abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpTErr abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then	# still not mounted
    echo "  DumpTerr abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpTerr abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   fi
 fi		# drive not mounted
fi
if [ -z "$P4" ];then
  P4=FLSARA86777
fi
# end handle flash drive section.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   DumpTerr initiated from Make."
  echo "   DumpTerr initiated."
else
  ~/sysprocs/LOGMSG "   DumpTerr initiated from Terminal."
  echo "   DumpTerr initiated."
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "  end parameter tests..."
#exit 0
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
terr=Terr
if [ ! -z "$P3" ];then
 dump_path=$U_DISK/$P3/$congterr
else
 dump_path=$pathbase
fi
projpath=$codebase/Projects-Geany/ArchivingBackups
archname=CB$terr$P1.0.tar
  if test -f $dump_path/$archname;then
   mv $dump_path/$archname $dump_path/$archname.bak
  fi
  pushd ./
  cd $pathbase/RawData
  echo $archname
  tar --create \
      --file $dump_path/$archname \
      -- RefUSA/RefUSA-Downloads/Terr$P1 \
      SCPA/SCPA-Downloads/Terr$P1 \
      ../TerrData/Terr$P1
# now append any SC and RU databases needed by this territory.
# remove SpecRUDumpList.txt and SpecSCDumpList.txt
# run GetTerrRUSpecList.sh, GetTerrSCSpecList.sh to get lists
#  of /Special dbs into SpecRUDumpList, SpecSCDumpList.
  cd $projpath
  sed "s?<terrid>?$P1?g" $projpath/GetTerrRUSpecList.psq \
    > $projpath/GetTerrRUSpecList.sql
  sed "s?<terrid>?$P1?g" $projpath/GetTerrSCSpecList.psq \
    > $projpath/GetTerrSCSpecList.sql
  make -f $projpath/MakeGenRUSpecList
  $projpath/GetTerrRUSpecList.sh
  make -f $projpath/MakeGenSCSpecList
  $projpath/GetTerrSCSpecList.sh
# loop reading db names from SpecRUDumpList.txt and SpecSCDumpList.txt
  if test -f $codebase/Projects-Geany/ArchivingBackups/SpecRUDumpList.txt;then 
   tidy=Tidy
   file=$projpath/SpecRUDumpList.txt
   while read -e; do
    len=${#REPLY}
    len1=$((len-1))
    spec_db=${REPLY:0:len1}
    echo "archiving $spec_db"
    cd $pathbase/RawData
    tar -rf $dump_path/$archname \
      -- RefUSA/RefUSA-Downloads/Special/$spec_db.db \
         RefUSA/RefUSA-Downloads/Special/$spec_db$tidy.sql \
         RefUSA/RefUSA-Downloads/Special/Make.$spec_db.Terr
   done < $file
  fi
  if test -f $projpath/SpecSCDumpList.txt;then 
   file=$projpath/SpecSCDumpList.txt
   while read -e; do
    len=${#REPLY}
    len1=$((len-1))
    spec_db=${REPLY:0:len-1}
    echo "archiving $spec_db"
    cd $pathbase/RawData
    tar -rf $dump_path/$archname \
      -- SCPA/SCPA-Downloads/Special/$spec_db.db \
         SCPA/SCPA-Downloads/Special/$spec_db$tidy.sql \
         SCPA/SCPA-Downloads/Special/Make.$spec_db.Terr
   done < $file
  fi
popd
#endprocbody
~/sysprocs/LOGMSG "  DumpTerr $P1 $P2 $P3 $P4 complete."
echo "  DumpTerr $P1 $P2 $P3 $P4 complete."
if [ -z "$P3" ];then
 echo "** use *Files* app to copy $pathbase/$archname to flash drive for backup."
fi
# end DumpTerr
