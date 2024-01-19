#!/bin/bash
echo " ** FixRUcsv.sh out-of-date **";exit 1
echo " ** FixRUcsv.sh out-of-date **";exit 1
# FixRUcsv.sh - Fix RefUSA full .csv to summary .csv.
# 6/30/23.	wmk.
#
# Usage. bash  FixRUcsv.sh <basename> [<filepath>]
#
#	<basename> = base file name to fix (e.g. WatersideDr)
#	<filepath> = (optional) path to file, if omitted, *DWNLD_PATH assumed
#
# Entry. 
#
# Dependencies. awkfixcsv.txt *mawk directives
#
# Exit.	<filepath>/<basename>.csv reformatted to "Summary" format.
#
# Modification History.
# ---------------------
# 6/29/23.	wmk.	original shell.
# 6/30/23.	wmk.	parameter list changed from SpecialRUdb version;
#			 "Summary" RefUSA documented.
#
# Notes. If a special db .csv is mistakenly downloaded with "full", this
# utility shell reduces the download to match "summary" (13 fields).
# Watch for the filename "None.*csv in the download. There is a bug
# in RefUSA where the "Summary" button looks selected in the download
# options, but the full download occurs anyway.
#
# P1=<filepath> P2=<basename>
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "FixRUcsv <filename> [<filepath>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$P2" ] || [ "$P2" == "-" ];then
P2=$DWNLD_PATH
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixRUcsv - initiated from Make"
  echo "  FixRUcsv - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixRUcsv - initiated from Terminal"
  echo "  FixRUcsv - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
if [ -z "$batchend" ];then batchend=1;rm $TEMP_PATH/FixResults.txt;fi
projpath=$codebase/Projects-Geany/DwnldMgr
pushd ./ > /dev/null
cd $P2
mawk -F "," -f $projpath/awkfixcsv.txt $P2/$P1.csv > $TEMP_PATH/$P1.csv
err=$?
#echo $err
if [ $err -eq 0 ];then
 cp -pv $TEMP_PATH/$P1.csv $P2/$P1.csv
 printf "%s\n" "$P2/$P1.csv converted to Summary format." >> $TEMP_PATH/FixResults.txt
else
 echo "$P1 already converted - skipping." >> $TEMP_PATH/FixResults.txt
fi
if [ $batchend -ne 0 ];then
 cat $TEMP_PATH/FixResults.txt
fi
popd > /dev/null
#endprocbody
echo "  FixRUcsv $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixRUcsv $P1 $P2 complete."
# end FixRUcsv.sh
