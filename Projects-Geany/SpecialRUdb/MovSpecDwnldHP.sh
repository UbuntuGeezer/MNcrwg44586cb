#!/bin/bash
echo " ** MovSpecDwnldHP.sh out-of-date **";exit 1
echo " ** MovSpecDwnldHP.sh out-of-date **";exit 1
# MovSpecDwnldHP.sh - Move special download(s) from *DWNLD_PATH to RU/Special folder.
# 6/15/23.	wmk.
#
#  Usage. bash MovSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download filesl 1 assumed
#
#  Entry. <special-db>.csv exists in *folderbase*/Downloads folder
#		OR if count nonempty, > 0
#		  <special-db>-1.csv .. <special-db>-$count.csv files in Downloads
#
#  Exit.
#  MovSpecDwnldHP.sh moves download .csv files from the
#  ~*folderbase*/Downloads folder to the ~/RefUSA-Downloads/Downloads
#  folder; when data is downloaded from RefUSA on a Chrome system, the
#   MyFiles/Downloads folder
#  is the staging area to receive the data in persistent storage. The
#  SpecialRUdb project shell MovSpecDwnld needs the data to be in the 
#  ~/RefUSA-Downloads folder.
#  File(s) are only moved if they are newer than file(s) in the
#  ~/RefUSA/Downloads folder.
#
# Dependencies.
#	folder /mnt/chromeos/MyFiles/Downloads exists
#	folder ~/RawData/RefUSA/RefUSA-Downloads/Downloads exists
#
# Modification History.
# ---------------------
# 6/15/23.	wmk.	comments tidied; *DWNLD_PATH checked.
# Legacy mods.
# 4/2/22.	wmk.	modified for HP Linux/Ubuntu system.
# 4/7/22.	wmk.	*folderbase* handling improved.
# 4/25/22.	wmk.	*pathbase* support;-p option on *cp* to preseve dates.
# 5/24/22.	wmk.	*DWNLD_PATH* added.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 12/28/21.	wmk.	original shell; cloned from MovSpecDwnld.
# 12/29/21.	wmk.	internal name corrected to MovSpecDwnld; superfluous folderbase
#		 references removed.
# Notes.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$DWNLD_PATH" ];then
 echo "MovSpecDwnld *DWNLD_PATH* not set - abandoned."
 exit 1
fi
#
P1=$1
P2=$2
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  bash ~/sysprocs/LOGMSG "   MovSpecDwnld initiated from Make."
  echo "   MovSpecDwnld initiated."
else
  bash ~/sysprocs/LOGMSG "   MovSpecDwnld initiated from Terminal."
  echo "   MovSpecDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  MovSpecDwnld ignored.. must specify <special-db>." >> $system_log #
  echo "  MovSpecDwnld ignored.. must specify <special-db>."
  exit 1
fi 
# this is always RU download
TYPE_=ru
if [ -z "$P2" ]; then
  F_CNT=0
else
  F_CNT=$P2
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
~/sysprocs/LOGMSG "  MovSpecDwnld $TID RU initiated."
echo "  MovSpecDwnld $TID $P2 initiated."
#procbodyhere env var TYPE_ is RU if needed.
 type_base=/RawData/RefUSA/RefUSA-Downloads
 src_path=$DWNLD_PATH
 targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Special
 file_suffx=_RU
# conditionally loop on .csv files.
if [ $F_CNT -gt 0 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $P1-$i.csv
  if ! test -f $src_path/$P1-$i.csv; then
    echo "$src_path/$P1-i.csv not found - MovSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - MovSpecDwnld abandoned."
    exit 1
  fi
  cp  -puv $src_path/$P1-$i.csv $targ_path
 done;
# single file copy.
else
  if ! test -f $src_path/$P1.csv; then
    echo "$src_path/$P1.csv not found - MovSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - MovSpecDwnld abandoned."
    exit 1
  fi
  cp  -puv $src_path/$P1.csv $targ_path
fi
#endprocbody
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
if [ "$USER" != "vncwmk3" ];then
 notify-send "MovSpecDwnld" "$P1 $P2 complete."
fi
~/sysprocs/LOGMSG  "MovSpecDwnld $P1 $P2 complete."
echo "  MovSpecDwnld $P1 $P2 complete."
#end MovSpecDwnld
