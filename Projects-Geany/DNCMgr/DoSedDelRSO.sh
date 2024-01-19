#!/bin/bash
# DoSedDelRSO.sh - *sed edit files for MakeDeleteRSO.
# 6/14/23.	wmk.
#
# Usage. bash  DoSedDelRSO.sh <propid> <unit> <initials>
#
#	<propid> = property ID of DNC to delete
#	<unit> = unit of DNC to delete
#	<initials> = initials of db mgr for audit
#
# Entry. /DB-Dev/TerrIDData.db.DeletedDNCs table has deleted DoNotCalls
#	from deleted territories.
#	MakeDeleteDNC.tmp = makefile template for DeleteDNC.sh 
#
# Dependencies.
#
# Exit.	MakeDeleteDNC.tmp > MakeDeleteDNC
#		DeleteDNCs.psq > DeleteDNC.sql
# /DB-Dev/TerrIDData/DoNotCalls table has deleted entry
#  for property id/unit within DoNotCall record.
#
# Modification History.
# ---------------------
# 6/14/23.	wmk.	original shell; adapted from DoSedDelete.
# Legacy mods.
# 6/1/23.	wmk.	original shell.
# 6/9/23.	wmk.	CRITICAL bug fix - correct editing when Unit is ' '.
# Notes. 
#
# set parameters P1=rsoid,  P2=initials.
#
P1=$1
P2=${2,,}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedDelRSO <rsoid> <initials> missing parameter(s) - abandoned."
 exit 1
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
  ~/sysprocs/LOGMSG "  DoSedDelRSO - initiated from Make"
  echo "  DoSedDelRSO - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedDelRSO - initiated from Terminal"
  echo "  DoSedDelRSO - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<rsoid>?$P1?g;s?<initials>?$P2?g" DeleteRSOdnc.psq > DeleteRSOdnc.sql
sed "s?<rsoid>?$P1?g;s?<initials>?$P2?g" DeleteRSO.psq > DeleteRSO.sql
sed "s?<rsoid>?$P1?g" MakeDeleteRSO.tmp > MakeDeleteRSO
sed "" MakeDeleteRSOdnc.tmp > MakeDeleteRSOdnc
#endprocbody
echo "  DoSedDelRSO complete."
~/sysprocs/LOGMSG "  DoSedDelRSO complete."
# end DoSedDelRSO.sh
