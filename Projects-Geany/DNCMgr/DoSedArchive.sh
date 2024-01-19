#!/bin/bash
# DoSedArchive.sh - *sed edit files for MakeArchiveDNCs.
# 6/14/23.	wmk.
#
# Usage. bash  DoSedArchive.sh <terrid> <initials>
#
#	<terrid> = territory ID of target territory for recovered DNCs
#	<initials> = initials of db mgr for audit
#
# Entry. /DB-Dev/TerrIDData.db.ArchivedDNCs table has archived DoNotCalls
#	from deleted territories.
#	MakeRecoverDNCs.tmp = makefile template for RecoverDNCs.sh 
#
# Dependencies.
#
# Exit.	MakeRecoverDNCs.tmp > MakeRecoverDNCs
#		RecoverDNCs.psq > RecoverDNCs.sql
# /DB-Dev/TerrIDData/DoNotCalls table has restored entries for any
#  property id/unit within <terrid> that had an archived DoNotCall record.
#
# Modification History.
# ---------------------
# 5/31/23.	wmk.	original shell.
# 6/14/23.	wmk.	error message corrected; header updated.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedArchive <terrid> <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedArchive - initiated from Make"
  echo "  DoSedArchive - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedArchive - initiated from Terminal"
  echo "  DoSedArchive - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<terrid>?$P1?g;s?<initials>?$P2?g" ArchiveDNCs.psq > ArchiveDNCs.sql
sed "" MakeArchiveDNCs.tmp > MakeArchiveDNCs
#endprocbody
echo "  DoSedArchive complete."
~/sysprocs/LOGMSG "  DoSedArchive complete."
# end DoSedArchive.sh
