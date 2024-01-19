#!/bin/bash
# FlashBacks - Update flash drive with all incremental dumps.
#	7/16/22.	wmk.
#
# Usage.	bash FlashBacks.sh
#
# Exit. All incremental dumps updated on after user mounted flash drive.
#
# Modification History.
# ---------------------
# 4/22/22.	wmk.	modified for general use FL/SARA/86777.
# 4/23/22.	wmk.	*congterr* env var introduced.
# 6/5/22.	wmk.	-v option added to *cp*s for progresss tracking..
# 7/16/22.	wmk.	echo ($)BACKUP_PATH for flash drive prompt.
# Legacy mods.
# 10/17/21.	wmk.	original code.
# 10/30/21.	wmk.	LOGMSG corrected to include flash drive name.
# 12/22/21.	wmk.	notify-send conditional.
# 3/3/22.	wmk.	HOME changed to USER in host test.
# This shell will exit if not interactive from Terminal.
P1=${1^^}
P2=${2^^}
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "FlashBacks <state> <county> <congno> missing parameter(s) - abandoned."
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P1$P2$P3" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P1$P2$P3 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   FlashBacks initiated from Make."
  echo "   FlashBacks initiated."
else
  bash ~/sysprocs/LOGMSG "   FlashBacks initiated."
  echo "   FlashBacks initiated."
fi
TEMP_PATH="$folderbase/temp"
#begin proc body
echo "BACKUP_PATH = $BACKUP_PATH"
read -p "Insert flash drive and enter mount name: "
flash_name=$REPLY
if test -d "$U_DISK/$flash_name";then
 ~/sysprocs/LOGMSG "  FlashBacks copying to $U_DISK/$flash_name."
 echo "FlashBacks copying to $U_DISK/$flash_name."
 if ! test -d "$U_DISK/$flash_name/$P1$P2$P3";then
  pushd ./
  cd $U_DISK/$flash_name
  mkdir $P1$P2$P3
  cd $P1$P2$P3
  mkdir log
  popd
 fi
 cp -pruv $pathbase/*.tar $U_DISK/$flash_name/$P1$P2$P3
 cp -pruv $pathbase/log*  $U_DISK/$flash_name/$P1$P2$P3
else
 ~/sysprocs/LOGMSG "  FlashBacks - unable to locate drive $flash_name - abandoned."
 echo "FlashBacks - unable to locate drive $flash_name - abandoned."
 exit 1
fi
#end proc body
if [ "$USER" != "vncwmk3" ];then
 notify-send "FlashBacks" "  complete."
fi
~/sysprocs/LOGMSG "  FlashBacks complete."
echo "  FlashBacks complete"
# end FlashBacks
