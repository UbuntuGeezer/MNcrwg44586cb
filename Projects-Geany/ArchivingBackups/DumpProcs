#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh.
# DumpProcs.sh  - Full archive of Chromebook Procs subdirectories.
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
 if ! test -d $U_DISK/$P2;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpProcs abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  DumpProcs abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/$P2;then	# still not mounted
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
  dump_path=$U_DISK/$P2
 else
  dump_path=$U_DISK/$P2/$congterr
 fi
fi
cd $codebase
procs=Procs
  archname=CB$procs.0.tar
  if test -f $dump_path/$archname;then
   echo "$dump_path/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $dump_path/$archname $dump_path/CB$procs.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file=$dump_path/$archname \
	  Procs-Dev
  ~/sysprocs/LOGMSG "  DumpProcs complete."
  echo "  DumpProcs complete."
# end DumpProcs
