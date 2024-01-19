#!/bin/bash
echo " ** MvSpecDwnld.sh out-of-date **";exit 1
echo " ** MvSpecDwnld.sh out-of-date **";exit 1
# MvSpecDwnld.sh - Move download(s) from RU/Downloads to RU/Special folder.
#	6/15/23.	wmk.
#
#  Usage. bash MvSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download filesl 1 assumed
#
#  Entry. <special-db>.csv exists in ~/RefUSA-Downloads/Downloads folder
#		OR if count nonempty, > 0
#		  <special-db>-1.csv .. <special-db>-$count.csv files in Downloads
#
#  Exit.  <special-db>.csv in ~/RefUSA-Downloads/Downloads folder contains
#		<special-db>.csv or combined .csv,s if count > 0.
#
#  MvSpecDwnld.sh moves download .csv files from the
#  ~RefUSA-Downloads/Downloads folder to the ~/RefUSA-Downloads/Special
#  folder; when data is downloaded from RefUSA, the /Downloads folder
#  is the staging area to receive the data in persistent storage. The
#  SpecialRUdb project needs the data to be in the /Special folder.
#  File(s) are only moved if they are newer than file(s) in the
#  /Special folder.
#
# Dependencies.
#	folder ~/RawData/RefUSA/RefUSA-Downloads/Downloads exists
#	folder ~/RawData/SCPA/SCPA-Downloads/Special exists
#
# Modification History.
# ---------------------
# 6/15/23.	wmk.	header description improved; comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced;CatSpecDwnld called
#			 to process multiple downloads into single file.
# 6/1/22.	wmk.	file count check corrected at end with *cat* conditional.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 11/8/21.	wmk.	original shell.
# 12/4/21.	wmk.	not found message corrected.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
# 1/30/22.	wmk.	complete message fixed.
# Notes.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
   terrbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
   terrbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
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
  ~/sysprocs/LOGMSG "   MvSpecDwnld initiated from Make."
  echo "   MvSpecDwnld initiated."
else
  ~/sysprocs/LOGMSG "   MvSpecDwnld initiated from Terminal."
  echo "   MvSpecDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  MvSpecDwnld ignored.. must specify <special-db>." >> $system_log #
  echo "  MvSpecDwnld ignored.. must specify <special-db>."
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
~/sysprocs/LOGMSG "  MvSpecDwnld $TID RU initiated."
echo "  MvSpecDwnld $TID $P2 initiated."
#proc body here env var TYPE_ is RU if needed.
 src_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Downloads
 targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Special
 projpath=$codebase/Projects-Geany/SpecialRUdb
 file_suffx=_RU
# conditionally loop on .csv files.
if [ $F_CNT -gt 0 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $P1-$i.csv
  if ! test -f $src_path/$P1-$i.csv; then
    echo "$src_path/$P1-i.csv not found - MvSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - MvSpecDwnld abandoned."
    exit 1
  fi
  cp  -puv $src_path/$P1-$i.csv $targ_path
 done;
# single file copy.
else
  if ! test -f $src_path/$P1.csv; then
    echo "$src_path/$P1.csv not found - MvSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - MvSpecDwnld abandoned."
    exit 1
  fi
  cp  -puv $src_path/$P1.csv $targ_path
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
~/sysprocs/LOGMSG  "MvSpecDwnld $P1 $P2 complete."
echo "  MvSpecDwnld $P1 $P2 complete."

if [ $F_CNT -ne 0 ];then
 $projpath/CatSpecDwnld.sh $P1 $P2
fi
#end MvSpecDwnld
