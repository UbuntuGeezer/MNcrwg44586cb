#!/bin/bash
echo " ** FixAllRUcsv.sh out-of-date **";exit 1
echo " ** FixAllRUcsv.sh out-of-date **";exit 1
# FixAllRUcsv.sh - Fix list of RefUSA full .csv to summary .csv.
# 7/22/23.	wmk.
#
# Usage. bash  FixAllRUcsv.sh [<filepath>]
#
#	<filepath> = (optional) path to file, if omitted, *DWNLD_PATH assumed
#
# Entry. *projpath/CSVList.txt = list of csv,s to fix.
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
# 7/2/23.	wmk.	change from DBList.txt to CSVList.txt as name source.
# 7/22/23.	wmk.	P1 as path to .csv,s.
#
# Notes. If a special db .csv is mistakenly downloaded with "full", this
# utility shell reduces the download to match "summary" (13 fields).
# Watch for the filename "None.*csv in the download. There is a bug
# in RefUSA where the "Summary" button looks selected in the download
# options, but the full download occurs anyway.
#
# P1 = path to .csv files.
P1=$1
if [ -z "$P1" ];then
 P1=$DWNLD_PATH
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
  ~/sysprocs/LOGMSG "  FixAllRUcsv - initiated from Make"
  echo "  FixAllRUcsv - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllRUcsv - initiated from Terminal"
  echo "  FixAllRUcsv - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/DwnldMgr
pushd ./ > /dev/null
file=$projpath/CSVList.txt
fcount=0
while read -e;do
 frstchr=${REPLY:0:1}
 if [ "$frstchr" == "\$" ];then break;fi
 fcount=$((fcount+1))
done < $file
echo " FixAllRUcsvs - file count = $fcount"
touch $file
#read -p "Enter ctrl-c to remain in Terminal: "
#exit 0
#
export batchend=0
if test -f $TEMP_PATH/FixResults.txt;then rm $TEMP_PATH/FixResults.txt;fi
countread=0
while read -e;do
 fn=$REPLY
 countread=$((countread+1))
 if [ $countread -eq $fcount ];then
  export batchend=1
 fi
  echo "  Processing $fn..."
  $projpath/FixRUcsv.sh $fn $P1
 if [ $countread == $fcount ];then break;fi
done < $file
read -p "Enter ctrl-c to remain in Terminal: "
exit 0
cd $P2
mawk -F "," -f $projpath/awkfixcsv.txt $P2/$P1.csv > $TEMP_PATH/$P1.csv
err=$?
echo $err
if [ $err -eq 0 ];then
 cp -pv $TEMP_PATH/$P1.csv $P2/$P1.csv
 printf "%s\n" "$P2/$P1.csv converted to Summary format."
else
 echo "$P1 already converted - skipping."
fi
popd > /dev/null
#endprocbody
echo "  FixAllRUcsv $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixAllRUcsv $P1 $P2 complete."
# end FixAllRUcsv.sh
