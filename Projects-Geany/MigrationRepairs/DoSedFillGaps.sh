# DoSedFillGaps
echo " ** DoSedFillGaps.sh out-of-date **";exit 1
echo " ** DoSedFillGaps.sh out-of-date **";exit 1
#!/bin/bash
# DoSedFillGaps.sh - Initialize FillGaps86777.sql and MakeFillGaps86777.
# 3/5/23.	wmk.
#
# Usage. bash  DoSedFillGaps.sh <import-src> <import-file>
#
#	<import-src> = path to import source of records to insert
#	<import-file> = filename (no extension, .csv assumed) with source records.
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/5/23.	wmk.	original shell.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedFillGaps <import-src> <import-file> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  DoSedFillGaps - initiated from Make"
  echo "  DoSedFillGaps - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedFillGaps - initiated from Terminal"
  echo "  DoSedFillGaps - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<import-src>?$P1?g;s?<import-file>?$P2?g" MakeFillGaps86777.tmp > MakeFillGaps86777
sed "s?<import-src>?$P1?g;s?<import-file>?$P2?g" FillGaps86777.psq > FillGaps86777.sql
#endprocbody
echo "  DoSedFillGaps complete."
~/sysprocs/LOGMSG "  DoSedFillGaps complete."
# end DoSedFillGaps.sh
