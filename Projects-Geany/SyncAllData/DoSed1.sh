#!/bin/bash
echo " ** DoSed1.sh out-of-date **";exit 1
echo " ** DoSed1.sh out-of-date **";exit 1
# DoSed1.sh - *sed modify LatestDwnldDate files for SyncAllData.
#	3/22/23.	wmk.
#
# Usage. bash  DoSed.sh  <db-path> <db-name> <db-table>
#
#	<db-path> = database path
#	<db-name> = database name
#	<db-table> = table name from which to extract latest date.
#
# Entry. *PWD/GetLatestMaster.psq = sql template for GetLatestMaster
#		 *PWD/MakeSyncAllData.tmp = makefile for SyncAllData
#		 *PWD/RefreshSCTerrIDs.psq = sql template for RefreshSCTerrs
#		 *PWD/SetDBcsvDate.psq = sql template for SetDBcsvDate
#		 *PWD/RUSpecV86777.psq = sql template for RUSpecV86777
#
# Dependencies.
#
# Exit.	*PWD/GetLatestMaster.sql = GetLatestMaster SQL base query.
#		*PWD/LatestDwnldDate.sql = LatestDwnldDate SQL base query.
#		*PWD/RefreshSCTerrIDs.sql = RefreshSCTerrIDs SQL base query.
#		*PWD/SetDBcsvDate.sql = SetDBcsvData SQL base query.
#		*PWD/MakeCheckZSCTerrLists.tmp > MakeCheckZSCTerrLists.
#		*PWD/MakeSetDBcsvDate.tmp > MakeSetDBcsvDate.
#		*PWD/MakeCheckRUSPecV86777.tmp > MakeCheckRUSpecV86777.
#
# Modification History.
# ---------------------
# 2/4/23.	wmk.	original shell.
# 2/5/23.	wmk.	modified to edit MakeSyncAllData.tmp.
# 2/17/23.	wmk.	documentation improved, parameters corrected.
# 2/18/23.	wmk.	MakeGetLatestMaster.psq added to edit list.
# 2/20/23.	wmk.	RefreshSCTerrIDs.psq, CheckZSCTerrLists.psq,
#			 MakeCheckZSCTerrLists.tmp added to edit list.
# 2/27/23.	wmk.	SetDBcsvDate.psq, MakeSetDBcsvDate.tmp added to edit list.
# 3/3/23.	wmk.	ValidateSpecDB.psq added to edit list.
# 3/22/23.	wmk.	CheckRUSpecV86777.psq, MakeCheckRUSpecV86777.tmp added
#			 to edit list.
# Notes. 
#
# set parameters P1..Pn here..
P1=$1		# <db-path>
P2=$2		# <db-name>
P3=$3		# <db-table>
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "DoSed1 <db-path> <db-name> <db-table> missing parameter(s) - abandoned."
 exit 1
fi
if [[ "$P2" =~ .*.db ]];then
 dbname=$P2
else
 dbname=$P2.db
fi
#echo "dbname = '$dbname'"
#exit 0
#
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
  ~/sysprocs/LOGMSG "  SyncAllData/DoSed1 - initiated from Make"
  echo "  DoSed1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SyncAllData/DoSed1 - initiated from Terminal"
  echo "  DoSed1 - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" LatestDwnldDate.psq > LatestDwnldDate.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" GetLatestMaster.psq > GetLatestMaster.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" RefreshSCTerrIDs.psq > RefreshSCTerrIDs.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" CheckZSCTerrLists.psq > CheckZSCTerrLists.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" ValidateSpecDB.psq > ValidateSpecDB.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" CheckRUSpecV86777.psq > CheckRUSpecV86777.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g;s?<csv-date>?$csvdate?g" \
 SetDBcsvDate.psq > SetDBcsvDate.sql
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" MakeCheckZSCTerrLists.tmp > MakeCheckZSCTerrLists
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" MakeSetDBcsvDate.tmp > MakeSetDBcsvDate
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" MakeCheckRUSpecV86777.tmp > MakeCheckRUSpecV86777
#endprocbody
echo "  DoSed1 $P1 $P2 $P3 complete."
~/sysprocs/LOGMSG "  DoSed1 $P1 $P2 $P3 complete."
# end DoSed1.sh
