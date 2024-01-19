# Sandisk.sh - Territories archiving to SANDISK USB drive.
#	12/11/22.	wmk.
#
# Sandisk.sh contains the usual ArchivingBackups shells as functions to
# support the specialized support for SANDISK drives with mount names containing
# spaces (e.g. USB\ Drive).
function DumpGeany(){
# DumpGeany.sh  - CB full archive of Geany subdirectories.
# 11/16/22.	wmk.
#
# Usage. bash  DumpGeany [-u <mount-name>] [<congterr>] 
#
#	-u = (optional) dump to USB
#	<mount-name> = (optional, mandatory if -u present) USB drive name
#	<congterr> = (optional) congregation territory dump folder
#					default FLSARA86777
#					(e.g. FLSARA86777)
#
# Entry. *congterr env var set for congregation territory
#		  (e.g. =FLSARA86777)
#
# Dependencies.
#	~/TerritoriesCB/Projects-Geany - base directory for Geany projects
#	SANDISK USB mount name must be USB\ Drive
#
# Exit. *U_DISK/USB\ Drive/*congterr/CBGeany.0.tar = fuill dump of CB../Projects-Geany
#    or *codebase/CBGeany.0.tar = full dump of CB ../Projects-Geany
#
# Modification History.
# ---------------------
# 11/16/22.	wmk.	modified to hardwire SANDISK mount names containing spaces.
# 12/6/22.	wmk.	add <spec-db>Tidy.sql to DumpTerr lists.
# 12/8/22.	wmk.	RestartIncRURaw, IncDumpRURaw functions added.
# 12/11/22.	wmk.	DumpTerr corrections.
# Legacy mods.
# 9/19/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support added for CB; *U_DISK definition ensured; comments tidied.
# 11/16/22.	wmk.	Sandisk.sh support documented.
# Notes. DumpGeany.sh performs a full archive (tar) of the
# Projects-Geany subdirectories. 
P1=${1,,}		# -u option
P2=${2^^}		# mount name (SANDISK)
P3=${3^^}		# congterr
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
if [ -z "$P3" ];then
 P3=FLSARA86777
fi
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ -z "$P1" ] || [ -z "$P2" ];then
  echo "DumpGeany -u SANDISK [<state><county><congo>] missing parameter(s) - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
 if [ "$P1" != "-u" ];then
  echo "DumpGeany -u SANDISK [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P2" != "SANDISK" ];then
  echo "DumpGeany [-u SANDISK] [<state><county><congo>] mount name not 'sandisk' - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
   echo "** SANDISK not mounted - mount SANDISK..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpGeany abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  DumpGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/USB\ Drive;then
    echo "  DumpGeany abandoned, SANDISK still not mounted."
    ~/sysprocs/LOGMSG "  DumpGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   fi
 fi		# drive not mounted
if [ -z "$P3" ];then
  P3=FLSARA86777
fi
# end handle flash drive section.
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$congterr
cd $codebase
geany=CBGeany
archname=$geany.0.tar
  if test -f $U_DISK/USB\ Drive/$congterr/$archname;then
   echo "$U_DISK/USB\ Drive/$congterr/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $U_DISK/USB\ Drive/$congterr/$archname \
      $U_DISK/USB\ Drive/$congterr/$geany.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file $U_DISK/USB\ Drive/$congterr/$archname \
	  Projects-Geany
  ~/sysprocs/LOGMSG "  DumpGeany complete."
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  DumpGeany complete."
echo "  DumpGeany complete."
if [ -z "$P2" ];then
 echo "** Use *Files app to copy $archname to flash drive."
fi
# end DumpGeany
}
function DumpProcs(){
# DumpProcs.sh  - Full archive to SANDISK USB drive of Chromebook Procs subdirectories.
# 11/16/22.	wmk.
#
#	Usage. bash DumpProcs [-u <mount-name>] [<congterr>]
#
#	-u = (optional) dump to USB
#	<mount-name> = (optional, mandatory if -u present) USB drive name
##	<congterr> = (optional) congregation territory dump folder
#					default FLSARA86777
#					(e.g. FLSARA86777)

# Entry. *congterr env var set for congregation territory
#		  (e.g. =FLSARA86777)
#
# Dependencies.
#	~/TerritoriesCB/Procs-Dev - base directory for CB shell files
#
# Exit. *U_DISK/*P3/*congterr/CBProcs.0.tar = fuill dump of CB../Procs-Dev
#    or *codebase/CBProcs.0.tar = full dump of CB ../Procs-Dev
#
# Modification History.
# ---------------------
# 11/16/22.	wmk.	SANDISK modifications.
# Legacy mods.
# 9/19/22.	wmk.	original code; adapted from IncDumpProcs.
# 9/20/22.	wmk.	modified for Chromebook system.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support added for CB; *U_DISK definition ensured;
#			 comments tidied.
# 11/16/22.	wmk.	documentation improved; exit improved to preserve Teminal
#			 session.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from DumpTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. DumpProcs.sh performs a full archive (tar) of the Procs subdirectories.
P1=${1,,}		# -u
P2=${2^^}		# mount name
P3=${3^^}		# congterr
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
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P1" ];then
if [ "$P1" != "-u" ];then
  echo "DumpProcs [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P2" != "SANDISK" ];then
  echo "DumpProcs -u SANDISK [<state><county><congo>] unrecognized USB drive -abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpProcs abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  DumpProcs abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/USB\ Drive;then	# still not mounted
    echo "  DumpProcs abandoned, drive $P2 still not mounted."
    ~/sysprocs/LOGMSG "  DumpProcs abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   fi
 fi		# drive not mounted
fi
if [ -z "$P3" ];then
  P3=FLSARA86777
fi
# end handle flash drive section.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   DumpProcs initiated from Make."
  echo "   DumpProcs initiated."
else
  ~/sysprocs/LOGMSG "   DumpProcs initiated from Terminal."
  echo "   DumpProcs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P1" ];then
 dump_path=$codebase
else
 if [ -z "$congterr" ];then
  dump_path=$U_DISK/USB\ Drive
 else
  dump_path=$U_DISK/USB\ Drive/$congterr
 fi
fi
cd $codebase
procs=Procs
  archname=CB$procs.0.tar
  if test -f $U_DISK/USB\ Drive/$congterr/$archname;then
   echo "$U_DISK/USB\ Drive/$congterr/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $U_DISK/USB\ Drive/$congterr/$archname \
        $U_DISK/USB\ Drive/$congterr/CB$procs.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  Procs-Dev
  ~/sysprocs/LOGMSG "  DumpProcs complete."
  echo "  DumpProcs complete."
# end DumpProcs
}
##################################################
function DumpBasic(){
# DumpBasic.sh  - Full archive of Chromebook Basic subdirectories.
# 2/6/23.	wmk.
#
#	Usage. bash DumpBasic [-u <mount-name>] [<congterr>]
#
#	-u = (optional) dump to USB
#	<mount-name> = (optional, mandatory if -u present) USB drive name
#	<congterr> = (optional) congregation territory dump folder
#					default FLSARA86777
#					(e.g. FLSARA86777)
#
# Entry. *congterr env var set for congregation territory
#		  (e.g. =FLSARA86777)
#
# Dependencies.
#	~/TerritoriesCB/Basic - base directory CB Basic code
#
# Exit. *U_DISK/*P3/*congterr/CBBasic.0.tar = fuill dump of CB../Basic
#    or *codebase/CBBasic.0.tar = full dump of CB ../Basic
#
# Modification History.
# ---------------------
# 9/19/22.	wmk.	original code; adapted from IncDumpBasic.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support added for CB; *U_DISK definition
#			 ensured; comments tidied.
# 11/16/22.	wmk.	bug fix where *dump_path not used to create tar file; comments
#            improved; exit improved to allow Terminal session to remain active.
# 2/6/23	wmk.	bug fix *P2 not shifted to uppercase.
# Legacy mods.
# 4/23/22.	wmk.	original code;adapted from DumpTerrData;*congterr* env
#			 var used througout.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	bug fix P1 P2 P3 not being set;bug fix 's removed from
#		  file=';bug fix level missing $.
#
# Notes. DumpBasic.sh performs a full archive (tar) of the
# Basic subdirectories.
P1=${1,,}		# -u
P2=${2^^}		# SANDISK
P3=${3^^}		# congterr
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
  ~/sysprocs/LOGMSG "   DumpBasic initiated from Make."
  echo "   DumpBasic initiated."
else
  LOGMSG "   DumpBasic initiated from Terminal."
  echo "   DumpBasic initiated."
fi
TEMP_PATH="$folderbase/temp"
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ "$P1" != "-u" ];then
  echo "DumpBasic [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
 if [ "$P2" != "SANDISK" ];then
  echo "DumpBasic -u SANDISK [<state><county><congo>] unrecognized USB drive -abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpBasic abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpBasic abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/USB\ Drive;then	# if still not mounted
    echo "  DumpBasic abandoned, drive $P2 still not mounted."
    sysprocs/LOGMSG "  DumpBasic abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   fi
 fi		# drive not mounted
if [ -z "$P3" ];then
  P3=FLSARA86777
fi
# end handle flash drive section.
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P1" ];then
 dump_path=$codebase
else
 if [ -z "$congterr" ];then
  dump_path=$U_DISK/USB\ Drive
 else
  dump_path=$U_DISK/USB\ Drive/$congterr
 fi
fi
cd $codebase
basic=Basic
  archname=CB$basic.0.tar
  if test -f $U_DISK/USB\ Drive/$congterr/$archname;then
   echo "$U_DISK/USB\ Drive/$congterr/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $U_DISK/USB\ Drive/$congterr/$archname $dump_path/CB$basic.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  Basic
  ~/sysprocs/LOGMSG "  DumpBasic complete."
  echo "  DumpBasic complete."
if [ -z "$P2" ];then
  echo "** use *Files app to copy $archname to flash drive for backup."
fi
#endprocbody
# end DumpBasic
}
################################################################
function DumpTerr(){
# DumpTerr.sh  - Full archive of Chromebook Procs subdirectories.
# 12/11/22.	wmk.
#
# Usage. bash DumpTerr <terrid> -u SANDISK [<congterr>]
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
P3=${3^^}		# SANDISK
P4=${4^^}		# congterr <state><county><congno>
if [ -z "$P1" ] ||[ -z "$P2" ] || [ -z "$P3" ];then
 echo "DumpTerr <terrid> -u SANDISK [<congterr>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remainm in Terminal:"
 exit 1
fi
if [ -z "$P4" ];then
 P4=FLSARA86777
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
  echo "DumpTerr <terrid> -u SANDISK [<congterr>]  unrecognized '-' option - abandoned."
 read -p "Enter ctrl-c to remainm in Terminal:"
 exit 1
 fi
if [ "$P3" != "SANDISK" ];then
  echo "DumpTerr <terrid> -u SANDISK [<congterr>]  <mont-name> not SANDISK - abandoned."
 read -p "Enter ctrl-c to remainm in Terminal:"
 exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpTerr abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpTErr abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/$USB\ Drive;then	# still not mounted
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
 dump_path=$U_DISK/USB\ Drive/$congterr
projpath=$codebase/Projects-Geany/ArchivingBackups
archname=CB$terr$P1.0.tar
  if test -f $U_DISK/USB\ Drive/$congterr/$archname;then
   mv $U_DISK/USB\ Drive/$congterr/$archname \
     $U_DISK/USB\ Drive/$congterr/$archname.bak
  fi
  pushd ./
  cd $pathbase/RawData
  echo $archname
  tar --create \
      --file $U_DISK/USB\ Drive/$congterr/$archname \
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
    tar -rf $U_DISK/USB\ Drive/$congterr/$archname \
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
    tar -rf $U_DISK/USB\ Drive/$congterr/$archname \
      -- SCPA/SCPA-Downloads/Special/$spec_db.db \
         SCPA/SCPA-Downloads/Special/$spec_db$tidy.sql \
         SCPA/SCPA-Downloads/Special/Make.$spec_db.Terr
   done < $file
  fi
popd
#endprocbody
~/sysprocs/LOGMSG "  DumpTerr $P1 $P2 $P3 $P4 complete."
echo "  DumpTerr $P1 $P2 $P3 $P4 complete."
# end DumpTerr
}
########################################
function RestartIncSCRaw(){
# RestartSCRaw.sh  - Set up for fresh incremental archiving of SCRaw.
# 	11/24/22.	wmk.
#
#	Usage. bash RestartSCRaw.sh  <state> <county> <congno> -u SANDISK
#
#		<state> = 2 char state
#		<county> = 4 char county
#		<congno> = congregation number
#		-u = (optional) use USB flash drive
#		<mount-name> (mandatory with -u) USB mount name
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/SCRaw.nnn.tar files all deleted after warning;
#	/Territories/log/SCRaw.snar-0 deleted after warning;
#	/Territories/log/SCRawlevel.txt deleted; this sets up next run of
#	IncDumpSCRaw to start at level 0;
#
# Modification History.
# ---------------------
# 11/24/22.	wmk.	adpated for SANDISK and mount names containing spaces.
# Legacy mods.
# 11/24/22.	wmk.	exit handling improved to allow reamining in Terminal;
#			 jumpto function removed; -u, <mount-name> support.
# Legacy mods.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 4/30/22.	wmk.	explicitly use *pathbase* in paths; bug where
#			 .newlevel var initialization inside if block.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
#
P1=${1^^}
P2=${2^^}
P3=$3
P4=${4^^}	# -u
P5=${5^^}	# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncSCRaw <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncSCRaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - RestartIncSCRaw abandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncSCRaw initiated from Make."
  echo "   RestartSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncSCRaw initiated from Terminal."
  echo "   RestartSCRaw initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior SCRaw incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncSCRaw."
  echo " Stopping RestartIncSCRaw - secure SCRaw incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
scraw=RawDataSC
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$scraw$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$scraw$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$scraw$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$scraw.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$scraw.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$scraw.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$scraw*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncSCRaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncSCRaw $P1 $P2 $P3 $P4 $P5  complete."
# end RestartIncSCRaw
}
#########################################################
function IncDumpSCRaw(){
# IncDumpSCRaw.sh  - Incremental archive of RawData subdirectories.
# 11/24/22.	wmk.
#
#	Usage. bash IncDumpSCRaw.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData/SCPA - base directory for Terrxxx folders with
#	  SCPA raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataSC.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataSC.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 11/24/22.	wmk.	adapted for SANDISK to include with Sandisk.sh; jumpto
#			 function eliminated; exit handling to allow ramining in Terminal.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/30/22.	wmk.	superfluous P1 removed from file = (tar).
# 9/2/22.	wmk.	-u, <mount-name> support.
# Legacy mods.
# 9/8/21.	wmk.	original shell; adapted from IncDumpRawDataSC.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpSCRaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/RawDataSC.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataSC.sh is provided to
# reset the RawData dump information so that the next IncDumpSCRaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/RawDataSC.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawSClevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpSCRaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataSC.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataSC.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
#
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=${5^^}	# SAMDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "IncDumpSCRaw <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ "$P5" != "SANDISK" ];then
  echo "IncDumpSCRaw <state> <county> <congno> -u SANDISK mount name not 'sandisk' - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if [ "$P4" != "-U" ];then
  echo "IncDumpSCRaw <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpSCRaw abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpSCRaw abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
fi  #end drive not mounted
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#read -p "Enter ctrl-c to remain in Terminal:"
#exit
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Make."
  echo "   IncDumpSCRaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpSCRaw initiated from Terminal."
  echo "   IncDumpSCRaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
level=level
nextlevel=nextlevel
newlevel=newlevel
rawsc=RawDataSC
#  if $dump_path/log does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$level.txt;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  archname=$congterr$rawsc.0.tar
  echo $archname
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$nextlevel.txt
  archname=$congterr$rawsc.0.tar
  echo $archive
  pushd ./
  cd $pathbase
   tar --create \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc.snar-0 \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  RawData/SCPA
  popd
  ~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=RawDataSC.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawsc.snar-0
 mawk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$nextlevel.txt \
  > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawsc.$REPLY.tar
  export snarname=$oldsnar
  echo "$archname"
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	RawData/SCPA
 popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$nextlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$newlevel.txt \
  $U_DISK/USB\ Drive/$congterr/log/$congterr$rawsc$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpSCRaw $P1 $P2 $P3 $P4 $P5 complete"
# end IncDumpSCRaw
}
########################################################
function FindFileInTars(){
# FindFileInTars.sh - Search for file in subsytem .tar files.
# 1/15/23.	wmk.
#
#	Usage. bash FindFileInTars <filespec> -u SANDISK [<congterr>]
#
#		<filespec> = file to or pattern to search for
#						(e.g. Projects-Geany/ArchivingBackups/ReloadSubsys.sh)
#		-u = (optional) reload from unloadable device (flashdrive)
#		SANDISK = (mandatory with -u) mount name for flashdrive
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to search for.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results. *TEMP_PATH/foundlist.txt lists incremental dumps containing <filespec>.
#
# Modification History.
# ---------------------
# 1/12/23.	wmk.	bug fix checking for P3 present.
# 1/15/23.	wmk.	"ArchList.txt" message corrected.
# Legacy mods.
# 11/17/22.	wmk.	exit handling improved allowing Terminal to continue.
# 11/22/22.	wmk.	mod to support system-resident .tar files; jumpto definition
# 11/24/22.	wmk.	adapted for SANDISK and mount names with embedded spaces.
#			 removed.
# Legacy mods.
# 9/20/22.	wmk.	modified for Chromebooks.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/10/22.	wmk.	updated to limit search output to successes.
# Legacy mods.
# 5/26/22.	wmk.	original code.
# 7/31/22.	wmk.	documentation improved.
#
P1=$1		# filespec
P2=$2		# -u
P3=${3^^}	# SANDISK
P4=${4^^}	# congterr
if [ -z "$P4" ];then
 P4=${congterr^^}
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "FindFileInTars <filespec> -u SANDISK [<state><county><congno>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to keep Terminal active:"
 exit 1
fi
# 
if [ "$P3" != "SANDISK" ];then
 echo "FindFileInTars <filespec> -u SANDISK [<state><county><congno>] flash drive msust be SANDISK - abandoned."
 read -p "Enter ctrl-c to keep Terminal active:"
 exit 1
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P2" ] && [ -z "$P3" ];then
echo "  FindFileInTars <filespec> -u SANDISK [<state><county><congno>] missing paramerter(s) - abandoned."
  echo "P1 = : $P1"		# filespec
  echo "P2 = : $P2"		# -u
  echo "P3 = : $P3"		# SANDISK
  echo "P4 = : $P4"		# congterr
  read -p "Enter ctrl-c to keep Terminal active:"
  exit 1
fi
if [ -z "$P2" ] || [ -z "$P3" ];then		# if no flash drive specified
 echo "  FindFileInTars <filespec> -u SANDISK [<state><county><congno>] missing paramerter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
 P2=${2,,}
if [ "$P2" != "-u" ];then
  echo "FindFileInTars <filespec> -u SANDISK [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "** $P3 not mounted - mount $P3..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   echo "  FindFileInTars abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindFileInTars abandoned, drive not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 0
  fi
  if ! test -d $U_DISK/USB\ Drive;then
   echo "  FindFileInTars abandoned, $P3 drive still not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 1
  fi
  dump_path=$U_DISK/USB\ Drive/$P4
fi	# end drive not mounted conditional
echo "P4 = : $P4"
# debugging code...
#echo "P1 = : $P1"	# filespec
#echo "P2 = : $P2"	# -u
#echo "P3 = : $P3"	# SANDISK
#echo "P4 = : $P4"	# congter
#echo "FindFileInTars parameter tests complete"
#read -p "Enter ctrl-c to keep Terminal active:"
#exit 0
# end debugging code.
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   FindFileInTars $P1 $P2 $P3 $P4 initiated from Make."
  echo "   FindFileInTars initiated."
else
  ~/sysprocs/LOGMSG "   FindFileInTars $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   FindFileInTars initiated."
fi
TEMP_PATH="$HOME/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$P4
cd $U_DISK/USB\ Drive/$P4
projpath=$codebase/Projects-Geany/ArchivingBackups
 # list all .tar files to temp/ArchList.txt.
if test -f $TEMP_PATH/taroutput.txt;then
 rm $TEMP_PATH/taroutput.txt
fi
 echo "dump_path = \$U_DISK/USB\ Drive/$P4"
  cd $U_DISK/USB\ Drive/$P4
  ls *.tar > $TEMP_PATH/ArchList.txt
 echo "ArchList.txt follows..."
 cat $TEMP_PATH/ArchList.txt
  file=$TEMP_PATH/ArchList.txt
  cb=CB
  echo $P1 | sed 's?!?*?g'	#if ! substitute * 
   echo "Finding from *.tar dumps..."
   if [ -f $TEMP_PATH/taroutput.txt ];then
    rm $TEMP_PATH/taroutput.txt
   fi
   while read -e;do
    archname=$REPLY
    echo " Scanning $archname."
    echo "  $archname" >> $TEMP_PATH/taroutput.txt
    tar --list --wildcards \
    --file $U_DISK/USB\ Drive/$P4/$archname \
    -- */$P1  1>>$TEMP_PATH/taroutput.txt 2>>$TEMP_PATH/taroutput.txt
   done < $file
backslash='//"'
# at this point taroutput.txt contains 2-line outputs, 1) archive name,
# 2) if found, line has $P1 or if not found, 2 lines beginning with 'tar:'
#mawk  '{if(substr($1,1,4) != "tar:") print;}' $TEMP_PATH/taroutput.txt
mawk -v srch_name="$P1" 'BEGIN {prevline = ""}{currline = $0;if(substr($1,1,4) != "tar:" && index($0,srch_name)>0){print prevline "\n" currline;prevline=currline}prevline=currline}' $TEMP_PATH/taroutput.txt
wc $TEMP_PATH/taroutput.txt > $TEMP_PATH/scratchfile.txt
if [ $? -ne 0 ];then
 echo "  File $P1 not found in tar dumps..."
fi
read -p "Enter ctrl-c to keep Terminal active:"
exit 0
# end FindFileInTars.sh
}
##################################################
function TarFileDate(){
# TarFileDate.sh - List file modified date from tar archive.
# 11/24/22.	wmk.
#
# Usage. bash  TarFileDate.sh <tarchive> <filespec> SANDISK
#
#	<tarchive> = tar archive name (e.g. *congterr/tarfile)
#	<filespec> = filespec to list dates for
#	SANDISK = USB drive mount name
#
# Modification History.
# ---------------------
# 11/24/22.	wmk.	adapted for SANDISK and mount names having embedded spaces.
# Legacy mods.
# 11/22/22.	wmk.	mod to support system-resident .tar files.
# 11/24/22.	wmk.	missing paramter(s) handled with improved message.
# Legacy mods.
# 10/12/22.	wmk.	original code.
# 10/13/22.	wmk.	parameter checking; join templist.txt lines.
# 10/30/22.	wmk.	bug fix forgot -i in *sed* joining lines.
# 11/14/22.	wmk.	optional <mount-name> parameter support; Lexar default.
#tar -x -f /mnt/chromeos/removable/Lexar/FLSARA86777/CBTerr111.0.tar --to-command='date -d @$TAR_MTIME > #tdate; echo "$TAR_FILENAME" > tfile; cat tfile  tdate'  -- TerrData/Terr111/Terr111_PubTerr.pdf
P1=$1		# tarchive
P2=$2		# filespec
P3=$3		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ]|| [ -z "$P3" ];then
 echo "TarFileDate <tarchive> <filespec> SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$folderbase" ];then
 export folderbase=$HOME
fi
if [ -z "$pathbase" ];then
 export folderbase=$HOME/Terrritories/FL/SRA/86777
fi
if [ -z "$codebase" ]; then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
dump_path=$U_DISK/USB\ Drive
tar -x -f $U_DISK/USB\ Drive/$P1 --to-command='date -d @$TAR_MTIME > tdate; echo "$TAR_FILENAME  " > tfile;cat tfile  tdate'  -- $P2 > templist.txt
sed -i '1{N;s/\n//;}' templist.txt
cat templist.txt
# end TarFileDate.sh
}
############################################
function RestartIncMainDBs(){
# RestartIncMainDBs.sh  - Set up for fresh incremental archiving of MainDBs.
# 	12/19/22.	wmk.
#
#	Usage. bash RestartMainDBs.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/MainDBs.nnn.tar files all deleted after warning;
#	/Territories/log/MainDBs.snar-0 deleted after warning;
#	/Territories/log/MainDBslevel.txt deleted; this sets up next run of
#	IncDumpMainDBs to start at level 0;
#
# Modification History.
# ---------------------
# 11/27/22.	wmk.	SANDISK (flash drive mount name with spaces) support.
# 11/27/22.	wmk.	jumpto references eliminated; error message corrections; exit
#			 processing to allow Terminal to continue; *codebase support; CB code
#			 check.
# 12/19/22.	wmk.	bug fix missing test for drive mounted; minor corrections.
# Legacy mods.
# 8/11/22.	wmk.	-u, <mount-name> support.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* env var used throughout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -U
P5=${5^^}		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]|| [ -z "$P4" ]|| [ -z "$P5" ];then
 echo "RestartIncMainDBs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z $P4 ];then
 if [ "$P4" != "-U" ];then
  echo "RestartIncMainDBs <state> <county> <congno> -u SANDISK unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
fi  # end -u specified
if [ "$P5" != "SANDISK" ];then
 echo "RestartIncMainDBs <state> <county> <congno> -u SANDISK unrecognized mount-name - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "** $P5 not mounted - mount $P5..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   echo "  RestartIncMainDBs abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindFileInTars abandoned, drive not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 0
  fi
  if ! test -d $U_DISK/USB\ Drive;then
   echo "  RestartIncMainDBs abandoned, $P5 drive still not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 1
  fi
fi	# end drive not mounted conditional
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RestartIncMainDBs initiated from Make."
  echo "   RestartMainDBs initiated."
else
  ~/sysprocs/LOGMSG "   RestartIncMainDBs initiated from Terminal."
  echo "   RestartMainDBs initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior MainDBs incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncMainDBs."
  echo " Stopping RestartIncMainDBs - secure MainDBs incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
 if ! test -d $U_DISK/USB\ Drive/$congterr;then
  pushd ./
  cd $U_DISK/USB\ Drive
  mkdir $congterr
  popd
 fi
cd $U_DISK/USB\ Drive/$congterr
MainDBs=MainDBs
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$MainDBs$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$MainDBs$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$MainDBs$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$MainDBs.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$MainDBs.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$MainDBs.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$MainDBs*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncMainDBs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncMainDBs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncMainDBs
}
########################################
function IncDumpMainDBs(){
# IncDumpMainDBs.sh  - Incremental archive of DB-Dev databases.
#	1/14/23.	wmk.
#
#	Usage. bash IncDumpMainDBs.sh [drive-spec]
#
# Dependencies.
#	~/Territories/DB-Dev - base directory main Territory databases.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/MainDBs.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/MainDBs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 11/27/22.	wmk.	exit handling allowing Terminal to continue; error message
#			 corrections; SANDISK support; CB support.
# 1/14/23.	wmk.	bug fix testing SANDISK mounted; target paths corrected for
#			 IncDumpMainDBs.
# Legacy mods.
# 8/11/22.	wmk.	-u <mount-name> support.
# 10/10/22.	wmk.	*codebase support.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/30/22.	wmk.	bug fixes where old code was not removed.
# Legacy mods.
# 9/17/21.	wmk.	original shell; adapted from IncDumpRawRU; jumpto
#					function eliminated.
# 9/18/21.	wmk.	bug fix in level-1 MainDBDsnextlevel corrected to
#					MainDBsnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	notify-send conditional fixed;HOME changed to USER.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpMainDBs.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file $pathbase/log/MainDBs.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartMainDBs.sh is provided to
# reset the MainDBs dump information so that the next IncDumpMainDBs
# run will produce the level-0 (full) dump.
# The file $pathbase/log/MainDBs.snar is created as the listed-incremental archive
# information. The file $pathbase/log/MainDBslevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpMainDBs calls. The initial archive file is named
# MainDBs.0.tar.
# If the $pathbase/log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named MainDBs.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named MainDBs.n.tar.
P1=${1^^}	# <state>
P2=${2^^}	# <county>
P3=$3		# <congno>
P4=${4^^}	# -U
P5=${5^^}	# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]|| [ -z "$P4" ]|| [ -z "$P5" ];then
 echo "IncDumpMainDBs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** IncDumpTerr <state> <county> <congno> <terrid> -u SANDISK unrecognized option $P4 - abandoned. **"
  exit 1
fi
if [ "$P5" != "SANDISK" ];then
  echo "** IncDumpMainDBs <state> <county> <congno> <terrid> -u SANDISK missing 'SANDISK' - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ ! "$yn" != "Y" ];then
   echo "IncDumpMainDBs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDump MainDBs agandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   IncDumpMainDBs initiated from Make."
  echo "   IncDumpMainDBs initiated."
else
  ~/sysprocs/LOGMSG "   IncDumpMainDBs initiated from Terminal."
  echo "   IncDumpMainDBs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
arch_path=${pathbase:14:50}
maindbs=MainDBs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $U_DISK/USB\ Drive/log/$congterr$maindbs.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs.snar-0;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$nextlevel.txt
  archname=$congterr$maindbs.0.tar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
      --wildcards \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs.snar-0 \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  -- DB-Dev
  popd
  ~/sysprocs/LOGMSG "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpMainDBs $P1 $P2 $P3 $P4 $p5 complete"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.$congterr
  oldsnar=$congterr$maindbs.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/log/$congterr$maindbs$nextlevel.txt \
    > $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$nextlevel.txt
 while read -e;do
  export archname=$congterr$maindbs.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	-- DB-Dev
  popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$nextlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$newlevel.txt \
  $U_DISK/USB\ Drive/$congterr/log/$congterr$maindbs$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpMainDBs $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpMainDBs
}
###############################################
function RestartIncProcs(){
# RestartProcs.sh  - Set up for fresh incremental archiving of Procs.
#	11/27/22.	wmk.
#
#	Usage. bash RestartProcs.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Procs.nnn.tar files all deleted after warning;
#	/Territories/log/Procs.snar-0 deleted after warning;
#	/Territories/log/Procslevel.txt deleted; this sets up next run of
#	IncDumpProcs to start at level 0;
#
# Modification History.
# ---------------------
# 11/27/22.	wmk.	SANDISK support.
# Legacy mods.
# 11/2/22.	wmk.	!! *sysid environment var support for all archiving
#			 operations; this will keep code segment dumps separated in the
#			 archiving system to avoid unwanted overwriting of macros/modules
#			 with the same name; *codebase support; -u, <mount-name> support.
# 11/27/22.	wmk.	rescind *sysid environment var support; improve error handling
#			 to allow Terminal to continue; jumpto references removed.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# 5/5/22.	wmk.	mod eliminating .0.tar check before removing old
#			 dump files.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=${5^^}	# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncProcs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "** RestartIncProcs <state> <county> <congno> <terrid> -u SANDISK unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if [ "$P5" != "SANDISK" ];then
  echo "** RestartIncProcs <state> <county> <congno> <terrid> -u SANDISK <mount-name> NOT SANDISK - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncProcs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - RestartIncProcs abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncProcs initiated from Make."
  echo "   RestartProcs initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncProcs initiated from Terminal."
  echo "   RestartIncProcs initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior Procs incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncProcs."
  echo " Stopping RestartIncProcs - secure Procs incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 cd $U_DISK/USB\ Drive
 if ! test -d ./$congterr;then
  mkdir $congterr
 fi
dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
 mkdir log
fi
geany=Procs
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt
fi
rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0
fi
rm $U_DISK/USB\ Drive/$congterr/$congterr$geany*.tar
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncProcs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncProcs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncProcs
}
####################################################
function IncDumpProcs(){
# IncDumpProcs.sh  - Incremental archive of Procs-SQL folders.
#	2/6/23.	wmk.
#
#	Usage. bash IncDumpProcs.sh  <state> <county> <congno> [-u <mount-name>]
#
#		<state>
#		<county>
#		<congno>
#		-u	= (optional) dump to removable device
#		<mount-name> = removable device name
#
# Dependencies.
#	~/Territories/DB-Dev - base directory main Territory databases.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Procs.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/Procs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 11/27/22.	wmk.	SANDISK support.
# 2/6/23.	wmk.	tar level-0 path bug fix.
# Legacy mods.
# 8/15/22.	wmk.	removable device support.
# 11/2/22.	wmk.	*sysid support; *codebase support; -u <mount-name> support.
# 11/27/22.	wmk.	remove *sysid support; exit handling to allow Terminal to
#			 continue; comments tidied.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file=
# 6/27/22.	wmk.	Procs-Build added to archiving list.
# Legacy mods.
# 9/17/21.	wmk.	original shell; adapted from IncDumpRawRU; jumpto
#					function eliminated.
# 9/18/21.	wmk.	bug fix in level-1 MainDBDsnextlevel corrected to
#					Procsnextlevel.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	notify-send conditional fixed;HOME changed to USER.
# 3/14/22.	wmk.	terrbase environment var for <state> <county> <terrno>
#			 support; HOME changed to USER in host test; optional
#			 drive-spec parameter eliminated.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpProcs.sh performs an incremental archive (tar) of the
# DB-Dev databases. If the file $pathbase/log/Procs.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartProcs.sh is provided to
# reset the Procs dump information so that the next IncDumpProcs
# run will produce the level-0 (full) dump.
# The file $pathbase/log/Procs.snar is created as the listed-incremental archive
# information. The file $pathbase/log/Procslevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpProcs calls. The initial archive file is named
# Procs.0.tar.
# If the $pathbase/log folder exists under Territories a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Procs.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named Procs.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -u
P5=$5			# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpProcs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 exit 1
fi
 if [ "$P4" != "-U" ];then
  echo "** IncDumpProcs <state> <county> <congno> <terrid> -u SANDISK unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** IncDumpProcs <state> <county> <congno> <terrid> -u SANDISK missing <mount-name> - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpProcs abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpProcs agandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
echo "P1=:$P1" ;echo "P2=:$P2";echo "P3=:$P3"
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpProcs abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#P1=$1
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   IncDumpProcs initiated from Make."
  echo "   IncDumpProcs initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpProcs initiated from Terminal."
  echo "   IncDumpProcs initiated."
fi
TEMP_PATH="$folderbase/temp"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
procs=Procs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $U_DISK/USB\ Drive/$congterr/log does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$level.txt;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  archname=$congterr$procs.0.tar
  echo $archname
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$nextlevel.txt
  pushd ./
  cd $codebase
  tar --create \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$procs.snar-0 \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  -- Procs-Dev
  ~/sysprocs/LOGMSG "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=$congterr$procs.snar-$REPLY
# done < $file
  oldsnar=$U_DISK/USB\ Drive/$congterr/$congterr$procs.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$nextlevel.txt \
   > $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$procs$nextlevel.txt
while read -e;do
  export archname=$congterr$procs.$REPLY.tar
  export snarname=$oldsnar
  echo "$archname"
  pushd ./
  cd $codebase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$procs.snar-0 \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	Procs-Dev
  popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$nextlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$newlevel.txt \
  $U_DISK/USB\ Drive/$congterr/log/$congterr$procs$nextlevel.txt
#endprocbody
~/sysprocs/LOGMSG "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpProcs $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpProcs
}
################################################
function RestartIncRURaw(){
# RestartIncRURaw.sh  - Set up for fresh incremental archiving of IncRURaw.
# 	12/8/22.	wmk.
#
#	Usage. bash RestartIncRURaw.sh  <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state
#		<county> = 4 char county
#		<congno> = congregation number
#		-u = (optional) use USB drive
#		<mount-name> = (mandatory with -u) USB mount name
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/IncRURaw.nnn.tar files all deleted after warning;
#	/Territories/log/IncRURaw.snar-0 deleted after warning;
#	/Territories/log/IncRURawlevel.txt deleted; this sets up next run of
#	IncDumpIncRURaw to start at level 0;
#
# Modification History.
# ---------------------
# 12/8/22.	wmk.	exit handling allowing Terminal to continue; notify-send
#			 removed; -u, <mount-name> support; jumpto references removed;
#			 *codebase support; comments tidied.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	corrections; *congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used throughout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional; name change
#			 from IncRURaw to RawDataRU.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4^^}		# -U
P5=${5^^}		# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ] ;then
 echo "RestartIncIncRURaw <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "RestartIncIncRURaw <state> <county> <congno> -u SANDISK $4 unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P5" != "SANDISK" ];then
  echo "RestartIncIncRURaw <state> <county> <congno> -u SANDISK missing <mount-name> - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncSCRaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - RestartIncSCRaw abandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncIncRURaw initiated from Make."
  echo "   RestartIncRURaw initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncIncRURaw initiated from Terminal."
  echo "   RestartIncRURaw initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior IncRURaw incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncIncRURaw."
  echo " Stopping RestartIncIncRURaw - secure IncRURaw incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
geany=RawDataRU
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$geany.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$geany*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncIncRURaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncIncRURaw $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncRURaw
}
#######################################################
function IncDumpRURaw(){
# IncDumpRURaw.sh  - Incremental archive of RawData/RefUSA subdirectories.
# 9/4/22.	wmk.
#
#	Usage. bash IncDumpRURaw.sh <state> <county> <congno> [-u <mount-name>]
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/RawDataRU.n.tar - incremental dump of ./RawData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/RawData/log/RawDataRU.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 9/4/22.	wmk.	bug fix unquoted echo in drive mount tests.
# 9/2/22.	wmk.	-u, <mount-name> support.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 4/26/22.	wmk.	P1 prefix in archname (level-1) removed.
# 5/5/22.	wmk.	residual P1 cleared from dump path.
# 5/6/22.	wmk.	newlevel *congterr* fixed in level-1.
# Legacy mods.
# 9/8/21.	wmk.	original shell; adapted from IncDumpRawDataRU.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpRURaw.sh performs an incremental archive (tar) of the
# RawData subdirectories. If the file $pathbase/log/RawDataRU.snar-0 does not exist
# under the Territories folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartRawDataRU.sh is provided to
# reset the RawData dump information so that the next IncDumpRURaw
# run will produce the level-0 (full) dump.
# The file $pathbase/log/RawDataRU.snar is created as the listed-incremental archive
# information. The file $pathbase/log/RawRUlevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpRURaw calls. The initial archive file is named
# archive.0.tar.
# If the $pathbase/log folder exists under RawData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named RawDataRU.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=${5^^}	# <mount-name>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpRURaw <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ "$P4" != "-U" ];then
  echo "IncDumpRURaw <state> <county> <congno> [-u <mount-name>] $P4 unrecognized - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpRURaw abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpRURaw abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    echo "continuing with $P5 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
fi  #end drive not mounted
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#read -p "Enter ctrl-c to remain in Terminal:"
#exit
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpRURaw initiated from Make."
  echo "   IncDumpRURaw initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpRURaw initiated from Terminal."
  echo "   IncDumpRURaw initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
level=level
nextlevel=nextlevel
newlevel=newlevel
rawdataru=RawDataRU
# if $dump_path/log does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$level.txt;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  archname=$congterr$rawdataru.0.tar
  echo $archname
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$nextlevel.txt
  pushd ./
  cd $pathbase
   tar --create \
	 --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru.snar-0 \
	 --file=$U_DISK/USB\ Drive/$congterr/$archname \
	 -- RawData/RefUSA
  popd
  ~/sysprocs/LOGMSG "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
# while read -e; do
#  oldsnar=$congterr$rawdataru.snar-$REPLY
# done < $file
  oldsnar=$congterr$rawdataru.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$nextlevel.txt \
   > $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$nextlevel.txt
 while read -e;do
  export archname=$congterr$rawdataru.$REPLY.tar
  export snarname=$oldsnar
# snarname=RawDataRU.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	RawData/RefUSA
  popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$nextlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$newlevel.txt \
   $U_DISK/USB\ Drive/$congterr/log/$congterr$rawdataru$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpRURaw $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpRURaw
}
##########################################################
function RestartIncGeany(){
# RestartIncGeany.sh  - Set up for fresh incremental archiving of Geany.
# 	1/13/23.	wmk.
#
#	Usage. bash RestartGeany.sh  <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state
#		<county> = 4 char county
#		<congno> = congregation number
#		-u = dump to removable device
#		<mount-name> = mount name for removable device
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/Geany.nnn.tar files all deleted after warning;
#	/Territories/log/Geany.snar-0 deleted after warning;
#	/Territories/log/Geanylevel.txt deleted; this sets up next run of
#	IncDumpGeany to start at level 0;
#
# Modification History.
# ---------------------
# 1/13/23.	wmk.	adapted for SANDISK; jumpto references removed; *sysid support
#			 removed; exit handling to remain in Terminal.
# Legacy mods.
# 11/1/22.	wmk.	!! *sysid environment var support for all archiving
#			 operations; this will keep code segment dumps separated in the
#			 archiving system to avoid unwanted overwriting of macros/modules
#			 with the same name; *codebase support.
# Legacy mods.
# 8/11/22.	wmk.	-u, <mount-name> support.
# 9/5/22.	wmk.	comments tidied; P1..P5 documented.
# 11/1/22.	wmk.	bug fixes where -u, <mount-name> not being honored.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/25/22.	wmk.	*congterr* used throughout.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
# function definition
P1=${1^^}	# state
P2=${2^^}	# county
P3=$3		# congno
P4=${4^^}	# -u
P5=${5^^}	# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "RestartIncGeany <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** RestartIncGeany <state> <county> <congno> <terrid> -u SANDISK unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** RestartIncGeany <state> <county> <congno> <terrid> -u SANDISK missing SANDISK - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P5" != "SANDISK" ];then
  echo "** RestartIncGeany attempted on non-SANDISK, use './RestartIncGeany' - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
fi
if [ ! -z "$P4" ];then
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncGeany abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - RestartIncGeany abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncGeany abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncGeany initiated from Make."
  echo "   RestartIncGeany initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncGeany initiated from Terminal."
  echo "   RestartIncGeany initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior Geany incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncGeany."
  echo " Stopping RestartIncGeany - secure Geany incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $U_DISK/USB\ Drive/
 if ! test -d ./$congterr;then
  pushd
  mkdir $congterr
  cd ./$congterr
  popd
 fi
dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
if ! test -d ./log;then
 mkdir log
fi
geany=Geany
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$geany.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$geany*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncGeany $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncGeany $P1 $P2 $P3 $P4 $P5 complete."
# end RestartGeany
}
##########################################################
function IncDumpGeany(){
# IncDumpGeany.sh  - Incremental archive of Geany subdirectories.
#	1/13/23.	wmk.
#
#	Usage. bash IncDumpGeany <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		<mount-name> = removable media mount name
#
# Dependencies.
#	~/TerritoriesCB/Projects-Geany - base directory for Geany projects
#	~/TerritoriesCB/.log - tar log subfolder for tracking incremental
#	  dumps
#  *sysid = system ID - CB (Chromebook), HP (HP Pavilion)
#
# Exit Results. Note - if -u <mount-name> is specfied the flash drive path
#  is substituted for *TerritoriesCB* below.
#	/TerritoriesCB/Geany.n.tar - incremental dump of ./Projects-Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/TerritoriesCB/log/Geany.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/TerritoriesCB/log/Geanylevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 1/13/23.	wmk.	adapted for SANDISK; exit handling to allow remain in Terminal.
# Legacy mods.
# 10/30/22.	wmk.	bug fix where *pathbase used > *codebase.
# 11/1/22.	wmk.	bug fix where level-0 dump going to archname instead of to
#			 *archname; comments corrected; error messages corrected.
# 11/1/22.	wmk.	*sysid support; *codebase support.
# 11/18/22.	wmk.	*sysid support pulled.
# 1/13/23.	wmk.	jumpto references removed.
# Legacy mods.
# 8/11/22.	wmk.	-u and <mount-name> support as dump target.
# 9/2/22.	wmk.	error messages cleaned up.
# 9/5/22.	wmk.	correct oldsnar eliminating *dump_path.
# 9/11/22.	wmk.	bug fix checking P4 for mount.	
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	corrected awk to use *pathbase* in all file refs;
#			 *congterr* env var support.
# 4/24/22.	wmk.	*congterr* used througout.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from IncDumpRURaw.
# 11/24/21.	wmk.	notify-send condtional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 3/31/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpGeany.sh performs an incremental archive (tar) of the
# Projects-Geany subdirectories. If the folder ./log does not exist under
# Territories, it is created and a level-0 incremental dump is performed.
# A shell utility RestartGeany.sh is provided to reset the Geany dump
# information so that the next IncDumpGeany run will produce the level-0
# (full) dump.
# Note. 8/11/22. Starting with this date, the .tar paths are full paths which
# include the *pathbase prefix. This is to avoid confusion in the reload
# process when a removable media is being used.
# The file ./log/$P1$P2$P3Geany.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpGeany calls. The initial archive file is named
# $P1$P2$P3Geany.0.tar.
# If the ./log folder exists under Geany a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named $P1$P2$P3Geany.snar-n, where n is the
# next level # obtained by incrementing ./log/$P1$P2$P3Geanylevel.txt. tar will be
# invoked with this new Geany.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -U
P5=${5^^}		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpGeany <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
 if [ "$P4" != "-U" ];then
  echo "** IncDumpGeany <state> <county> <congno> -u SANDISK unrecognized option $P4 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ -z "$P5" ];then
  echo "** IncDumpGeany <state> <county> <congno> -u SANDISK missing <mount-name> - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P5" != "SANDISK" ];then
  echo "** IncDumpGeany attempted on non-SANDISK, use './IncDumpGeany' - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpGeany abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$USB\ Drive;then
    echo "$P5 still not mounted - IncDumpGeany abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpGeany abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Make."
  echo "   IncDumpGeany initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Terminal."
  echo "   IncDumpGeany initiated."
fi
TEMP_PATH=$folderbase/temp
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
dump_path=$U_DISK/USB\ Drive/$congterr
#
cd $U_DISK/USB\ Drive/$congterr
geany=Geany
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
  archname=$congterr$geany.0.tar
  echo $archname
  pushd ./
  cd $codebase
  tar --create \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0 \
	  --file=$U_DISK/USB\ Drive/$congterr/$archname \
	  Projects-Geany
  ~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
  oldsnar=$congterr$geany.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt \
   > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
 echo "file = :'$file'"
 while read -e;do
  export archname=$congterr$geany.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./
  cd $codebase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	Projects-Geany
  popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$newlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$newlevel.txt \
  $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpGeany echo "IncDumpGeany not implemented."
}
##########################################################
function RestartIncTerrData(){
# RestartIncTerrData.sh  - Set up for fresh incremental archiving of TerrData.
# 	1/24/23.	wmk.
#
#	Usage. bash RestartIncTerrData.sh
#
# Dependencies.
#	~/Territories/RawData - base directory for Terrxxx folders with
#	  raw data territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.nnn.tar files all deleted after warning;
#	/Territories/log/TerrData.snar-0 deleted after warning;
#	/Territories/log/TerrDatalevel.txt deleted; this sets up next run of
#	IncDumpTerrData to start at level 0;
#
# Modification History.
# ---------------------
# 1/24/23.	wmk.	modified for SANDISK; exit processing to allow remain in 
#			 Terminal; jumpto references removed.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4^^}		# -U
P5=${5^^}		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncTerrData <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if ! test -d $U_DISK/USB\ Drive;then
 echo "$P5 not mounted... Mount flash drive $P5"
 read -p "  Drive mounted and continue (y/n)? "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
   echo "IncDumpTerrData abandoned at user request."
   exit 1
 else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpTerrData abandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
 fi
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - RestartIncTerrData abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncTerrData initiated from Make."
  echo "   RestartTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncTerrData initiated from Terminal."
  echo "   RestartTerrData initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
 echo " **WARNING - proceeding will remove all prior TerrData incremental dump files!**"
 read -p "OK to proceed (Y/N)? "
 ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncTerrData."
  echo " Stopping RestartIncTerrData - secure TerrData incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase
geany=TerrData
level=level
nextlevel=nextlevel
dump_path=$U_DISK/USB\ Drive/$congterr
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$geany$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$geany.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$geany.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$geany*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncTerrData $P1 $P2 $P3 complete."
echo "  RestartIncTerrData $P1 $P1 $P2 complete"
# end RestartTerrDataData
}
##########################################################
function IncDumpTerrData(){
# IncDumpTerrData.sh  - Incremental archive of TerrData subdirectories.
# 1/24/23.	wmk.
#
#	Usage. bash IncDumpTerrData <state> <county> <congno> -u SANDISK
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		SANDISK = pseudo mount name for SANDISK flash drives
#
# Dependencies.
#	~/Territories/TerrData - base directory for Terrxxx folders with
#	  publisher territory information
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.n.tar - incremental dump of ./TerrData folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/TerrData/log/TerrData.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/log/TDlevel.txt - current level of incremental TerrData 
#	  archive files.
#
# Modification History.
# ---------------------
# 1/24/23.	wmk.	modified for SANDISK support; exit handling to allow
#			 remain in Terminal;jumpto references removed.
# Legacy mods.
# 9/13/22.	wmk.	-u, <mount-name> support.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL SARA 86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	superfluous if P1 block removed;archname echoed.
# 4/25/22.	wmk.	fix P1 P2 P3 not being set;'s removed from file='.
# 5/2/22.	wmk.	path fixes incorporating *congterr* var.
# 6/12/22.	wmk.	bug fix with superfluous '.' in log path check.
# Legacy mods.
# 6/29/21.	wmk.	original shell.
# 9/8/21.	wmk.	documentation review and minor corrections.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 4/1/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpTerrData.sh performs an incremental archive (tar) of the
# TerrData subdirectories. If the folder $pathbase/log does not exist under
# TerrData, it is created and a level-0 incremental dump is performed.
# A shell utility RestartTerrData.sh is provided to reset the TerrData dump
# information so that the next IncDumpTerrData run will produce the level-0
# (full) dump.
# The file $pathbase/log/TerrData.snar is created as the listed-incremental archive
# information. The file $pathbase/log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpTerrData calls. The initial archive file is named
# TerrData.0.tar.
# If the $pathbase/log folder exists under TerrData a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named TerrData.snar-n, where n is the
# next level # obtained by incrementing $pathbase/log/TDlevel.txt. tar will be
# invoked with this new TerrData.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# state
P2=${2^^}		# county
P3=$3			# congno
P4=${4^^}		# -U
P5=${5^^}			# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpTerrData <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
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
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpTerrData abandoned **"
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#
if [ "$P4" != "-U" ];then
  echo "** IncDumpTerrData <state> <county> <congno> <terrid> -u SANDISK unrecognized option $P4 - abandoned. **"
 read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if [ "$P5" != "SANDISK" ];then
  echo "** IncDumpTerrData <state> <county> <congno> <terrid> -u SANDISK unrecognized <mount-name> - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
echo "testing U_DISK/.. $U_DISK/USB\ Drive..."
if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpTerrData abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpTerrData abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpTerrData initiated from Make."
  echo "   IncDumpTerrData initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpTerrData initiated from Terminal."
  echo "   IncDumpTerrData initiated."
fi
TEMP_PATH="$folderbase/temp"
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $U_DISK/USB\ Drive/$congterr
level=level
nextlevel=nextlevel
newlevel=newlevel
td=TerrData
# if $U_DISK/USB\ Drive/$congterr/log/TerrData.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$td.snar-0;then
  # initial archive 
  archname=$congterr$td.0.tar
  echo $archname
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$td$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$td$nextlevel.txt
  archive=$congterr$td.0.tar
  echo $archive
  pushd ./
  cd $pathbase
  tar --create \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$td.snar-0 \
	  --file=$U_DISK/USB\ Drive/$congterr/$congterr$td.0.tar \
	  TerrData
  popd
  ~/sysprocs/LOGMSG "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
  echo "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
  oldsnar=$congterr$td.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$td$nextlevel.txt\
   > $U_DISK/USB\ Drive/$congterr/log/$congterr$td$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$td$nextlevel.txt
 while read -e;do
  export archname=$congterr$td.$REPLY.tar
  export snarname=$oldsnar
# snarname=$td.snar-$REPLY
# cp $dump_path/log/$oldsnar $dump_path/log/$snarname
# echo "./log/$snarname"
 echo "$archname"
 pushd ./
 cd $pathbase
 tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file=$U_DISK/USB\ Drive/$congterr/$archname \
	TerrData
 popd
done < $U_DISK/USB\ Drive/$congterr/log/$congterr$td$nextlevel.txt
cp $U_DISK/USB\ Drive/$congterr/log/$congterr$td$newlevel.txt \
   $U_DISK/USB\ Drive/$congterr/log/$congterr$td$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpTerrData $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpTerrData
}
############################################################
function RestartIncPDFs(){
# RestartIncPDFs.sh  - Set up for fresh incremental archiving of TerrData.
# 	1/28/23.	wmk.
#
#	Usage. bash  RestartIncPDFs.sh <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation number
#		-u = (optional) restart on USB drive
#		<mount-name> = (optional, mandatory if -u specified) USB mount name
#
# Dependencies.
#	~/Territories/Territory-PDFs - base directory for territory PDF files.
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/TerrData.nnn.tar files all deleted after warning;
#	/Territories/log/TerrData.snar-0 deleted after warning;
#	/Territories/log/TerrDatalevel.txt deleted; this sets up next run of
#	IncDumpTerrData to start at level 0;
#
# Modification History.
# ---------------------
# 10/9/22.	wmk.	original code; adapted from RestartIncTerrData; -u, <mount-name>
#			 support added; *codebase support added; jumpto references removed.
# 1/28/23.	wmk.	USB drive mounted checks added; exit handling allowing Terminal continue.
# Legacy mods.
# 4/22/22.	wmk.	modified for general use /FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 4/24/22.	wmk.	*congterr* used througout.
# 5/5/22.	wmk.	(automated) mod with NOPROMPT conditional.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from RestartRelease.
# 12/24/21.	wmk.	notify-send conditional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
#
# Notes. The entire incremental dump collection for RawData/RefUSA will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4,,}		# -u
P5=${5^^}		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "RestartIncPDFs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi

 if [ "$P4" != "-u" ];then
  echo "RestartIncPDFs <state> <county> <congno> -u SANDISK $P4 unrecognized - abandoned."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P5" != "SANDISK" ];then
  echo "RestartIncPDFs <state> <county> <congno> -u SANDISK missing <mount-name> - abandoned."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi 
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "RestartIncSCRaw abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - RestartIncSCRaw abandoned."
    exit 1
   else
   "echo continuing with $P5 mounted..."
   fi
  fi
 else
  echo "$P5 mounted - continuing.."
 fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/Territories/FL/SARA/86777
fi
if [ "$folderbase/Territories/$P1/$P2/$P3" != "$pathbase" ];then
 echo "pathbase: $pathbase"
 echo "$folderbase/Territories/$P1/$P2/$P3 does not match *pathbase* - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   RestartIncPDFs initiated from Make."
  echo "   RestartIncPDFs initiated."
else
  bash ~/sysprocs/LOGMSG "   RestartIncPDFs initiated from Terminal."
  echo "   RestartIncPDFs initiated."
fi
TEMP_PATH=$folderbase/temp
if [ "$NOPROMPT" == "" ];then NOPROMPT=0;fi;if [ $NOPROMPT -ne 1 ];then
echo " **WARNING - proceeding will remove all prior PDF incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
 if [ "$ynreply" == "y" ];then
  echo "  Proceeding to remove prior incremental dump files..."
 else
  ~/sysprocs/LOGMSG "  User halted RestartIncPDFs."
  echo " Stopping RestartIncPDFs - secure TerrPDFs incremental backups.."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 0
 fi
fi
#
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $pathbase
pdfs=pdfs
level=level
nextlevel=nextlevel
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$level.txt;then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$level.txt
fi
echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt
#cat $dump_path/log/$congterr$pdfs$nextlevel.txt
if test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs.snar-0; then
 rm $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs.snar-0
fi
if test -f $U_DISK/USB\ Drive/$congterr/$congterr$pdfs.0.tar; then
 rm $U_DISK/USB\ Drive/$congterr/$congterr$pdfs*.tar
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  RestartIncPDFs $P1 $P2 $P3 $P4 $P5 complete."
echo "  RestartIncPDFs $P1 $P2 $P3 $P4 $P5 complete."
# end RestartIncPDFs
}
############################################################
function IncDumpPDFs(){
# IncDumpPDFs.sh  - Incremental archive of Geany subdirectories.
#	1/28/23.	wmk.
#
#	Usage. bash IncDumpPDFs <state> <county> <congno> [-u <mount-name>]
#
#		<state> = 2 char state abbrev
#		<county> = 4 char county abbrev
#		<congno> = congregation #
#		-u = (optional) dump to removable media
#		<mount-name> = removable media mount name
#
# Dependencies.
#	~/Territories/Territories-PDFs - base directory for territory PDFs
#	~/Territories/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Territories/*congterr/*congterr*pdfs.n.tar - incremental dump of ./Territories-PDFs
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Territories/*congterr/log/*congterr*pdfs.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Territories/*congterr/log/pdfslevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 10/9/22.	wmk.	original code; adapted from IncDumpGeany; jumpto references removed.
# 10/10/22.	wmk.	bug fix missing '$' in *archname reference.
# 1/28/23.	wmk.	bug fix in drive tests echo; exit handling allowing remain in
#			 Terminal; debug stuff removed.
# Legacy mods.
# 8/11/22.	wmk.	-u and <mount-name> support as dump target.
# 9/2/22.	wmk.	error messages cleaned up.
# 9/5/22.	wmk.	correct oldsnar eliminating *dump_path.
# 9/11/22.	wmk.	bug fix checking P4 for mount.	
# Legacy mods.
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	corrected awk to use *pathbase* in all file refs;
#			 *congterr* env var support.
# 4/24/22.	wmk.	*congterr* used througout.
# Legacy mods.
# 11/18/21.	wmk.	original shell; adapted from IncDumpRURaw.
# 11/24/21.	wmk.	notify-send condtional for multihost.
# 3/1/22.	wmk.	HOME changed to USER in host conditional.
# 3/31/22.	wmk.	fix level-0 notify-send; display archive filename;
#			 improve nextlevel handling, incremented at exit.
#
# Notes. IncDumpPDFs.sh performs an incremental archive (tar) of the
# Projects-Geany subdirectories. If the folder ./log does not exist under
# Territories, it is created and a level-0 incremental dump is performed.
# A shell utility RestartGeany.sh is provided to reset the Geany dump
# information so that the next IncDumpPDFs run will produce the level-0
# (full) dump.
# Note. 8/11/22. Starting with this date, the .tar paths are full paths which
# include the *pathbase prefix. This is to avoid confusion in the reload
# process when a removable media is being used.
# The file ./log/$P1$P2$P3Geany.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpPDFs calls. The initial archive file is named
# $P1$P2$P3Geany.0.tar.
# If the ./log folder exists under Geany a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named $P1$P2$P3Geany.snar-n, where n is the
# next level # obtained by incrementing ./log/$P1$P2$P3Geanylevel.txt. tar will be
# invoked with this new Geany.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
P1=${1^^}		# <state>
P2=${2^^}		# <county>
P3=$3			# <congno>
P4=${4^^}		# -u
P5=${5^^}		# SANDISK
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P4" ] || [ -z "$P5" ];then
 echo "IncDumpPDFs <state> <county> <congno> -u SANDISK missing parameter(s) - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi
if [ ! -z "$P4" ];then
 if [ "$P4" != "-U" ];then
  echo "** IncDumpPDFs <state> <county> <congno> <terrid> [-u <mount-name>] unrecognized option $P4 - abandoned. **"
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
 if [ "$P5" != "SANDISK" ];then
  echo "** IncDumpPDFs <state> <county> <congno> <terrid> -u SANDISK missing <mount-name> - abandoned. **"
  read -p "Enter ctl-c to remain in Terminal:"
  exit 1
 fi
fi
 if ! test -d $U_DISK/USB\ Drive;then
  echo "$P5 not mounted... Mount flash drive $P5"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpPDFs abandoned at user request."
   read -p "Enter ctl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/USB\ Drive;then
    echo "$P5 still not mounted - IncDumpPDFs abandoned."
    read -p "Enter ctl-c to remain in Terminal:"
    exit 1
   else
   echo "continuing with $P5 mounted..."
   fi
  fi
 else
  echo "$P5 mounted - continuing..."
 fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "P3 = : '$P3'"
echo "P4 = : '$P4'"
echo "P5 = : '$P5'"
echo "parameter tests complete."
#exit
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codbase=$pathbase
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - IncDumpPDFs abandoned **"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   IncDumpPDFs initiated from Make."
  echo "   IncDumpPDFs initiated."
else
  bash ~/sysprocs/LOGMSG "   IncDumpPDFs initiated from Terminal."
  echo "   IncDumpPDFs initiated."
fi
TEMP_PATH=$folderbase/temp
#
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
 dump_path=$U_DISK/USB\ Drive/$congterr
cd $pathbase
pdfs=pdfs
level=level
nextlevel=nextlevel
newlevel=newlevel
# if $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs.snar-0;then
  # initial archive
 if ! test -d $U_DISK/USB\ Drive/$congterr/log;then
  mkdir log
 fi
  echo "0" > $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$level.txt
  echo "1" > $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt
  archname=$congterr$pdfs.0.tar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	  --listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs.snar-0 \
	  --file $U_DISK/USB\ Drive/$congterr/$archname \
	  -- Territory-PDFs
  ~/sysprocs/LOGMSG "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
  popd
  echo "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
  read -p "Enter ctl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
  oldsnar=$congterr$pdfs.snar-0
 awk '{$1++; print $0}' $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt \
   > $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$newlevel.txt
 file=$U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt
 echo "file = :'$file'"
 while read -e;do
  export archname=$congterr$pdfs.$REPLY.tar
  export snarname=$oldsnar
  echo $archname
  pushd ./
  cd $pathbase
  tar --create \
	--listed-incremental=$U_DISK/USB\ Drive/$congterr/log/$snarname \
	--file $U_DISK/USB\ Drive/$congterr/$archname \
	-- Territory-PDFs
  popd
done <$U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt
cp -p $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$newlevel.txt \
      $U_DISK/USB\ Drive/$congterr/log/$congterr$pdfs$nextlevel.txt
#
popd > $TEMP_PATH/scratchfile
#endprocbody
~/sysprocs/LOGMSG "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
echo "  IncDumpPDFs $P1 $P2 $P3 $P4 $P5 complete."
# end IncDumpPDFs
}
################################################
function ReloadFLTerr(){
# ReloadFLTerr.sh  - reload Chromebook territory subdirectories.
# 1/29/23.	wmk.
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
# 1/29/23.	wmk.	modified for SANDISK support.
# Legacy mods.
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
P3=${3,,}		# -u
P4=${4^^}		# SANDISK
P5=${5^^}		# congterr
if [ -z "$P1" ] || [ -z "$P1" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "ReloadFLTerr <terrid> <filespec> -u SANDISK [<state><county><congo>] missing parameter(s) - abandoned."
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
if [ "$P3" != "-u" ];then
  echo "ReloadFLTerr <terrid> <filespec>  -u SANDISK [<state><county><congo>] unrecognized '-' option - abandoned."
  exit 1
fi
if [ "$P4" != "SANDISK" ];then
  echo "ReloadFLTerr <terrid> <filespec>  -u SANDISK [<state><county><congo>] unrecognized <mount-name> - abandoned."
  exit 1
 fi
 if [ "${P3:1:1}" == "u" ] || [ "${P3:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/USB\ Drive;then
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
 writeover=--keep-newer-files
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
 dump_path=$U_DISK/USB\ Drive/$P5
terr=Terr
tid=$P1
# get list of RawDataRU, RawDataSC, TerrData dumps.
# FLSARA86777Terr.*.tar from dump_path.
#ls -lh $U_DISK/USB\ Drive/$P5/$congterr$terr.*.tar > $TEMP_PATH/TarList.lst
RUdata=RawDataRU
SCdata=RawDataSC
Terrdata=TerrData
ls -lh $U_DISK/USB\ Drive/$P5/$congterr$RUdata.*.tar > $TEMP_PATH/TarList.lst
ls -lh $U_DISK/USB\ Drive/$P5/$congterr$SCdata.*.tar >> $TEMP_PATH/TarList.lst
ls -lh $U_DISK/USB\ Drive/$P5/$congterr$Terrdata.*.tar >> $TEMP_PATH/TarList.lst
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
     --file=$U_DISK/USB\ Drive/$P5/$archname \
      -- RawData/RefUSA/RefUSA-Downloads/Terr$P1
   cd $pathbase
    tar --extract --wildcards \
     $writeover \
     --file=$U_DISK/USB\ Drive/$P5/$archname \
      -- RawData/RefUSA/RefUSA-Downloads/Special
   cd $pathbase
   tar --extract \
      --file $U_DISK/USB\ Drive/$P5/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Terr$P1
   cd $pathbase
   tar --extract \
      --file $U_DISK/USB\ Drive/$P5/$archname \
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
      --file $U_DISK/USB\ Drive/$P5/$archname \
      $writeover \
      -- RawData/RefUSA/RefUSA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $U_DISK/USB\ Drive/$P5/$archname \
      $writeover \
      -- RawData/SCPA/SCPA-Downloads/Terr$P1/$P2
   cd $pathbase
   tar --extract \
      --file $U_DISK/USB\ Drive/$P5/$archname \
      $writeover \
      -- TerrData/Terr$P1/$P2
  fi
  popd
done < $file
popd
~/sysprocs/LOGMSG "  ReloadFLTerr $P1 $P2 $P3 $P4 $P5 complete."
echo "  ReloadFLTerr $P1 $P2 $P3 $P4 $P5 complete."
# end ReloadFLTerr
}
