#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# DumpBasic.sh  - Full archive of Chromebook Basic subdirectories.
# 11/16/22.	wmk.
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
P2=$2			# mount name
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
 if ! test -d $U_DISK/$P2;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpBasic abandoned, drive not mounted."
    sysprocs/LOGMSG "  DumpBasic abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/$P2;then	# if still not mounted
    echo "  DumpBasic abandoned, drive $P2 still not mounted."
    sysprocs/LOGMSG "  DumpBasic abandoned, drive not mounted."
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
#proc body here
pushd ./ > $TEMP_PATH/scratchfile
if [ -z "$P1" ];then
 dump_path=$codebase
else
 if [ -z "$congterr" ];then
  dump_path=$U_DISK/$P2
 else
  dump_path=$U_DISK/$P2/$congterr
 fi
fi
cd $codebase
basic=Basic
  archname=CB$basic.0.tar
  if test -f $dump_path/$archname;then
   echo "$dump_path/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $dump_path/$archname $dump_path/CB$basic.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file=$dump_path/$archname \
	  Basic
  ~/sysprocs/LOGMSG "  DumpBasic complete."
  echo "  DumpBasic complete."
if [ -z "$P2" ];then
  echo "** use *Files app to copy $archname to flash drive for backup."
fi
# end DumpBasic
