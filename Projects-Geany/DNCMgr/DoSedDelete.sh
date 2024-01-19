#!/bin/bash
# DoSedDelete.sh - *sed edit files for MakeDeleteDNC.
# 6/14/23.	wmk.
#
# Usage. bash  DoSedDelete.sh <propid> <unit> <initials>
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
# 6/1/23.	wmk.	original shell.
# 6/9/23.	wmk.	CRITICAL bug fix - correct editing when Unit is ' '.
# 6/14/23.	wmk.	header updated.
#
# Notes. 
#
# set parameters P1=propid, P2=unit, P3=initials.
#
P1=$1
P2=$2
P3=${3,,}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "DoSedDelete <propid> <unit> <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedDelete - initiated from Make"
  echo "  DoSedDelete - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedDelete - initiated from Terminal"
  echo "  DoSedDelete - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
if [ "$P2" != " " ];then
 sed "s?<propid>?$P1?g;s?<unit>?$P2?g;s?<initials>?$P3?g" DeleteDNC.psq > DeleteDNC.sql
else
 sed "s?<propid>?$P1?g;s?Unit IS '<unit>'?(Unit ISNULL\n OR Unit IS '')?g;s?<unit> deleted?<nounit> deleted?g;s?<initials>?$P3?g" DeleteDNC.psq > DeleteDNC.sql
fi
sed "" MakeDeleteDNC.tmp > MakeDeleteDNC
#endprocbody
echo "  DoSedDelete complete."
~/sysprocs/LOGMSG "  DoSedDelete complete."
# end DoSedDelete.sh
