#!/bin/bash
echo " ** MovSpecDwnld.sh out-of-date **";exit 1
echo " ** MovSpecDwnld.sh out-of-date **";exit 1
# MovSpecDwnld.sh - Move special download(s) from *DWNLD_PATH to RU/Special folder.
#	7/2/23.	wmk.
#
#  Usage. bash MovSpecDwnld.sh <special-db> [count]
#
#		<special-db> - special db name
#		[count] - (optional) count of download filesl 1 assumed
#
#  Entry. <special-db>.csv exists in ~/RefUSA-Downloads/Downloads folder
#		OR if count nonempty, > 0
#		  <special-db>-1.csv .. <special-db>-$count.csv files in Downloads
#
#  Exit.
#
#  MovSpecDwnld.sh moves download .csv files from the
#  ~MyFiles/Downloads folder to the ~/RefUSA-Downloads/Downloads
#  folder; when data is downloaded from RefUSA on a Chrome system, the
#   MyFiles/Downloads folder
#  is the staging area to receive the data in persistent storage. The
#  SpecialRUdb project shell MovSpecDwnld needs the data to be in the 
#  ~/RefUSA-Downloads folder.
#  File(s) are only moved if they are newer than file(s) in the
#  ~/RefUSA/Downloads folder.
#
# Dependencies.
#	folder *folderbase*/Downloads exists
#	folder ~/RawData/RefUSA/RefUSA-Downloads/Downloads exists
#
# Modification History.
# ---------------------
# 6/15/23.	wmk.	*DWNLD_PATH env var usage checked.
# 7/2/23.	wmk.	filename construct fixed for multi-file download.
# Legacy mods.
# 12/5/22.	wmk.	notify-send removed; exit mods allowing Terminal to continue;
#			 *targpath corrected; comments tidied.
# 2/7/23.	wmk.	"Now use.." message removed.
# 3/24/23.	wmk.	parameter checking messages improved.
# Legacy mods.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced; -p (preserve
#			 attributes) added to *cp* commands.
# 5/24/22.	wmk.	*DWNLD_PATH* env var added.
# Legacy mods.
# 12/28/21.	wmk.	original shell; cloned from MovSpecDwnld.
# 12/29/21.	wmk.	internal name corrected to MovSpecDwnld; superfluous folderbase
#		 references removed.
# Notes.
P1=$1
P2=$2
if [ -z "$P1" ]; then
  echo "  MovSpecDwnld <special-db> [<ount>] missing parameter(s) - abandoned.."
  read -p "Enter ctrl-c to remain in Terminal:"
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
 codebase=$folderbase/GitHub/TerritoriesCB
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
if [ -z "$DWNLD_PATH" ];then 
 echo "  MovSpecDwnld *DWNLD_PATH* environment var not set - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
#
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   MovSpecDwnld initiated from Make."
  echo "   MovSpecDwnld initiated."
else
  ~/sysprocs/LOGMSG "   MovSpecDwnld initiated from Terminal."
  echo "   MovSpecDwnld initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
~/sysprocs/LOGMSG "  MovSpecDwnld $TID RU initiated."
echo "  MovSpecDwnld $TID $P2 initiated."
#procbodyhere    env var TYPE_ is RU if needed.
 type_path=$pathbase/RawData/RefUSA/RefUSA-Downloads
 src_path=$DWNLD_PATH
 targ_path=$pathbase/RawData/RefUSA/RefUSA-Downloads/Special
 file_suffx=_RU
# conditionally loop on .csv files.
 suffx1=-
if [ $F_CNT -gt 1 ];then
 for (( i=1; i<=$F_CNT ; i++ ));do
   suffx2=$i.csv
   echo $P1$suffx1$suffx2
  if ! test -f $src_path/$P1$suffx1$suffx2; then
    echo "$src_path/$P1$suffx1$suffx2 not found - MovSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1$suffx1$suffx2 not found - MovSpecDwnld abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
  fi
  cp  -puv $src_path/$P1$suffx1$suffx2 $targ_path
  # remove headers at this point to preserve.csv file date.
  sed -i '/Last Name/ d' $targ_path/$P1$suffx1$suffx2
 done;
 echo "  ** WARNING - run *CatSpecDwnld.sh immediately to preserve .csv dates **" 
# single file copy.
else
  if ! test -f $src_path/$P1.csv; then
    echo "$src_path/$P1.csv not found - MovSpecDwnld abandoned."
    ~/sysprocs/LOGMSG "  $P1.csv not found - MovSpecDwnld abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
  fi
  cp  -pv $src_path/$P1.csv $targ_path
  # remove headers at this point to preserve.csv file date.
  sed -i '/Last Name/ d' $targ_path/$P1.csv
fi
#endprocbody
~/sysprocs/LOGMSG  "MovSpecDwnld $P1 $P2 complete."
echo "  MovSpecDwnld $P1 $P2 complete."
#end MovSpecDwnld
