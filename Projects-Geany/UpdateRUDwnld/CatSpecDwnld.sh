#!/bin/bash
echo " ** CatSpecDwnld.sh out-of-date **";exit 1
echo " ** CatSpecDwnld.sh out-of-date **";exit 1
# CatSpecDwnld.sh - Concatenate special download(s) in RU/Special folder.
# 6/15/23.	wmk.
#
#  Usage. bash CatSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download files, 1 assumed
#
#  Entry. <special-db>.csv exists in ~/RefUSA-Downloads/Downloads folder
#		OR if count nonempty, > 0
#		  <special-db>-1.csv .. <special-db>-$count.csv files in Downloads
#
#  CatSpecDwnld.sh concatenates download .csv files in the
#  ~/RefUSA-Downloads/Special folder; <special-db>-1..<special-db>-n
#  files are combined into <special-db>.csv
#
# Dependencies.
#	folder ~/RawData/SCPA/SCPA-Downloads/Special exists
#   files <special-db>-1.csv .. <special-db>-count.csv exist
#
# Modification History.
# ---------------------
# 6/15/23.	wmk.	comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 11/8/21.	wmk.	original shell.
# 11/12/21.	wmk.	bug fix where 1st file not being cat,d.
# 11/29/21.	wmk.	bug fix in 'initiated' message.
# 12/21/21.	wmk.	tidy up superfluous touch.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
# Notes.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
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
  bash ~/sysprocs/LOGMSG "   CatSpecDwnld initiated from Make."
  echo "   CatSpecDwnld initiated."
else
  bash ~/sysprocs/LOGMSG "   CatSpecDwnld initiated from Terminal."
  echo "   CatSpecDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  CatSpecDwnld ignored.. must specify <special-db>." >> $system_log #
  echo "  CatSpecDwnld ignored.. must specify <special-db>."
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
~/sysprocs/LOGMSG "  CatSpecDwnld $TID RU initiated."
echo "  CatSpecDwnld $P1 $P2 initiated."
#proc body here env var TYPE_ is RU if needed.
 type_base=RawData/RefUSA/RefUSA-Downloads
 src_path=$pathbaseRawData/RefUSA/RefUSA-Downloads/Terr$P1
 targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
 file_suffx=_RU
# conditionally loop on .csv files.
# look checking for all files before proceeding.
if [ $F_CNT -gt 1 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
  if ! test -f $pathbase/$src_path/$P1-$i.csv; then
    echo "~/Special/$P1-$i.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1-i.csv not found - CatSpecDwnld abandoned."
    exit 1
  fi
 done;
# loop copying files.
 if test -f $pathbase/$src_path/$P1.csv;then
  rm $pathbase/$src_path/$P1.csv
 fi; 
 touch $pathbase/$src_path/$P1.csv
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $P1-$i.csv
  if ! test -f $pathbase/$src_path/$P1-$i.csv; then
    echo "~/Special/$P1.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - CatSpecDwnld abandoned."
    exit 1
  fi
  cat $pathbase/$src_path/$P1.csv $pathbase/$src_path/$P1-$i.csv \
    > $pathbase/$src_path/$P1.tmp
  mv $pathbase/$src_path/$P1.tmp $pathbase/$src_path/$P1.csv
 done;
# insufficient file count.
else
  echo "CatSpecDwnld - must have file count >= 2 - abandoned."
  ~/sysprocs/LOGMSG " CatSpecDwnld - must have file count >= 2 - abandoned."
  exit 1
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
if [ "$USER" != "vncwmk3" ];then
 notify-send "CatSpecDwnld" "$1 complete."
fi
~/sysprocs/LOGMSG  "CatSpecDwnld $1 complete."
echo "  CatSpecDwnld $P1 complete."
#end CatSpecDwnld
