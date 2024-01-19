#!/bin/bash
# DoSedBuild.sh - *sed edit files for MakeBuildDNC, MakeCleanupDNCs.
# 6/14/23.	wmk.
#
# Usage. bash  DoSedBuild.sh <initials>
#
#	<initials> = initials of db mgr for audit
#
# Entry. /DB-Dev/TerrIDData.db.BuildDNCs table has deleted DoNotCalls
#	from deleted territories.
#	MakeBuildDNC.tmp = makefile template for BuildDNC.sh 
#
# Dependencies.
#
# Exit.	MakeBuildDNC.tmp > MakeBuildDNC
#		BuildDNCs.psq > BuildDNC.sql
# /DB-Dev/TerrIDData/DoNotCalls table has deleted entry
#  for property id/unit within DoNotCall record.
#
# Modification History.
# ---------------------
# 6/8/23.	wmk.	original shell.
# 6/14/23.	wmk.	header udpated.
#
# Notes. 
#
P1=$1
if [ -z "$P1" ];then
 echo "DoSedBuild <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedBuild - initiated from Make"
  echo "  DoSedBuild - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedBuild - initiated from Terminal"
  echo "  DoSedBuild - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "" MakeBuildDNCcounts.tmp > MakeBuildDNCcounts
sed "" MakeCleanupDNCs.tmp > MakeCleanupDNCs
sed "s?<initials>?$P1?g" CleanupDNCs.psq > CleanupDNCs.sql
#endprocbody
echo "  DoSedBuild complete."
~/sysprocs/LOGMSG "  DoSedBuild complete."
# end DoSedBuild.sh
