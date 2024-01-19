#!/bin/bash
# CatSpecDwnld.sh - Concatenate special download(s) in RU/Special folder.
# 12/28/21.	wmk.
#
#  Usage. bash CatSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download filesl 1 assumed
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
# 11/8/21.	wmk.	original shell.
# 11/12/21.	wmk.	bug fix where 1st file not being cat,d.
# 11/29/21.	wmk.	bug fix in 'initiated' message.
# 12/21/21.	wmk.	tidy up superfluous touch.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
# Notes.

if [ "$USER" == "ubuntu" ];then
 folderbase=/media/ubuntu/Windows/Users/Bill
else 
 folderbase=$HOME
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
  TEMP_PATH="$HOME/temp"
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
 type_base=Territories/RawData/RefUSA/RefUSA-Downloads
 src_path=Territories/RawData/RefUSA/RefUSA-Downloads/Special
 targ_path=Territories/RawData/RefUSA/RefUSA-Downloads/Special
 file_suffx=_RU
# conditionally loop on .csv files.
# look checking for all files before proceeding.
if [ $F_CNT -gt 1 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
  if ! test -f $folderbase/$src_path/$P1-$i.csv; then
    echo "~/Special/$P1-$i.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1-i.csv not found - CatSpecDwnld abandoned."
    exit 1
  fi
 done;
# loop copying files.
 if test -f $folderbase/$src_path/$P1.csv;then
  rm $folderbase/$src_path/$P1.csv
 fi; 
 touch $folderbase/$src_path/$P1.csv
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $P1-$i.csv
  if ! test -f $folderbase/$src_path/$P1-$i.csv; then
    echo "~/Special/$P1.csv not found - CatSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - CatSpecDwnld abandoned."
    exit 1
  fi
  cat $folderbase/$src_path/$P1.csv $folderbase/$src_path/$P1-$i.csv \
    > $folderbase/$src_path/$P1.tmp
  mv $folderbase/$src_path/$P1.tmp $folderbase/$src_path/$P1.csv
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
