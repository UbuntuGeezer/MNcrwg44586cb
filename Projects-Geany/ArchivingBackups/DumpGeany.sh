#!/bin/bash
# Note. remove /bin/bash line if this code is placed in functions in CBArchiving.sh or Sandisk.sh
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
#
# Exit. *U_DISK/*P3/*congterr/CBGeany.0.tar = fuill dump of CB../Projects-Geany
#    or *codebase/CBGeany.0.tar = full dump of CB ../Projects-Geany
#
# Modification History.
# ---------------------
# 9/19/22.	wmk.	original code.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	-u, <mount-name> support added for CB; *U_DISK definition
#			 ensured; comments tidied.
# 11/16/22.	wmk.	Sandisk.sh support documented; error handling improved
#			 to keep Terminal session alive; misc. minor bug fixes.
# Notes. DumpGeany.sh performs a full archive (tar) of the
# Projects-Geany subdirectories. 
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
 P4=FLSARA86777
fi
# handle flash drive section.
if [ -z "$U_DISK" ];then
 export U_DISK=/mnt/chromeos/removable
fi
if [ ! -z "$P1" ];then
 if [ "$P1" != "-u" ];then
  echo "DumpGeany  [-u <mountname>] [<state><county><congo>] unrecognized '-' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/$P2;then
   echo "** $P2 not mounted - mount $P2..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  DumpGeany abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  DumpGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 0
   fi
   if ! test -d $U_DISK/$P2;then	# if still not mounted
    echo "  DumpGeany abandoned, drive P2 still not mounted."
    ~/sysprocs/LOGMSG "  DumpGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   fi
 fi		# drive not mounted
fi
if [ -z "$P3" ];then
  P3=FLSARA86777
fi
# end handle flash drive section.
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
geany=CBGeany
  archname=$geany.0.tar
  if test -f $dump_path/$archname;then
   echo "$dump_path/$archname already exiists..."
   read -p " Do you wish to copy it to .bak (y/n)? "
   yn=${REPLY^^}
   if [ "$yn" == "Y" ];then
    cp -pv $dump_path/$archname $dump_path/$geany.0.bak
   fi
  fi
  echo $archname
  tar --create \
	  --file=$dump_path/$archname \
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
