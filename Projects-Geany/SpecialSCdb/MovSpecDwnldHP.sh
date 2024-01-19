#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# MvSpecDwnldHP.sh - Move special download(s) to SC/Special folder (HP/ubuntu).
# 5/30/22.    wmk.   (automated) pathbase corrected to FL/SARA/86777.
# 5/16/22.	wmk.
#
#  Usage. bash MvSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download files 1 assumed
#
#  Entry. <special-db>.csv exists in *folderbase*/Downloads folder
#		OR if count nonempty, > 0
#	 <special-db>-1.csv .. <special-db>-$count.csv files in above folder 
#
#  MvSpecDwnld.sh moves download .csv files from the
#  ~SCPA-Downloads/Downloads folder to the ~/SCPA-Downloads/Special
#  folder; when data is downloaded from SCPA, the /Downloads folder
#  is the staging area to receive the data in persistent storage. The
#  SpecialSCdb project needs the data to be in the /Special folder.
#  File(s) are only moved if they are newer than file(s) in the
#  /Special folder.
#
# Dependencies.
#	folder ~*folderbase*/Downloads exists
#	folder ~*pathbase*/Special exists
#
# Modification History.
# ---------------------
# 5/15/22.  wmk.   (automated) pathbase corrected to FL/SARA/86777.
# 5/16/22.	wmk.   modified for HP/ubuntu system; *pathbase* support.
# Legacy mods.
# 4/7/22.	wmk.	modified for TX/HGLD/99999; HOME changed to USER in
#			 host check.
# 4/10/22.	wmk.	export *folderbase* corrections.
# Legacy mods.
# 12/15/21.	wmk.	original shell; adapted from RU version.
# Notes.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
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
  ~/sysprocs/LOGMSG "   MovSpecDwnld $P1 $P2(SC) initiated from Make."
  echo "   MovSpecDwnld initiated."
else
  ~/sysprocs/LOGMSG "   MovSpecDwnld $P1 $P2(SC) initiated from Terminal."
  echo "   MovSpecDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  echo "  MovSpecDwnld ignored.. must specify <special-db>." >> $system_log #
  echo "  MovSpecDwnld ignored.. must specify <special-db>."
  exit 1
fi 
# this is always SC download
TYPE_=SC
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
~/sysprocs/LOGMSG "  MovSpecDwnld $P1 $P2 SC initiated."
echo "  MovSpecDwnld $P1 $P2 initiated."
#proc body here env var TYPE_ is SC if needed.
 type_base=Territories/RawData/SCPA/SCPA-Downloads
 src_path=$folderbase/Downloads
 targ_path=$pathbase/RawData/SCPA/SCPA-Downloads/Special
# conditionally loop on .csv files.
if [ $F_CNT -gt 0 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
   echo $P1-$i.csv
  if ! test -f $src_path/$P1-$i.csv; then
    echo "$src_path/$P1-$i.csv not found - MovSpecDwnld abandoned."
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
#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
~/sysprocs/LOGMSG  "MovSpecDwnld $P1 $P2 (SC) complete."
echo "  MovSpecDwnld $P1 $P2 complete."
#end MovSpecDwnldHP
