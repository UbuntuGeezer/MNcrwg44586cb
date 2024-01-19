#!/bin/bash
# DoSedMove.sh - *sed edit files for MakeMoveDNC.
# 6/14/23.	wmk.
#
# Usage. bash  DoSedMove.sh <rsoid> <newaddr> <newunit> <newzip> <newterrid> <initials>
#
#	<rsoid> = RSO id of RSO to move
#	<newaddr> = new address RSO moving to
#	<newunit> = new unit RSO moving to
#	<newzip> = new zip code RSO moving to
#	<newterrid> = new territory ID RSO moving to (or '000')
#	<initials> = initials of db mgr for audit
#
# Entry. /DB-Dev/TerrIDData.db.MovedDNCs table has deleted DoNotCalls
#	from deleted territories.
#	MakeMoveDNC.tmp = makefile template for MoveDNC.sh 
#
# Dependencies.
#
# Exit.	MakeMoveDNC.tmp > MakeMoveDNC
#		MoveDNCs.psq > MoveDNC.sql
# /DB-Dev/TerrIDData/DoNotCalls table has deleted entry
#  for property id/unit within DoNotCall record.
#
# Modification History.
# ---------------------
# 6/13/23.	wmk.	original shell; adapted from DoSedDelete.
# 6/14/23.	wmk.	header updated.
# Legacy mods.
# 6/1/23.	wmk.	original shell.
# 6/9/23.	wmk.	CRITICAL bug fix - correct editing when Unit is ' '.
# Notes. 
#
# set parameters P1=rsoid, P2=newaddr, P3=newunit, P4=newzip, P5=newterrid, P6=initials.
#
P1=$1
P2=$2
P3=$3
P4=$4
P5=$5
P6=${6,,}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ] || [ -z "$P5" ] || [ -z "$P6" ];then
 echo "DoSedMove <rsoid> <newaddress> <newunit> <newzip> <newterrid> <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedMove - initiated from Make"
  echo "  DoSedMove - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedMove - initiated from Terminal"
  echo "  DoSedMove - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
#procbodyhere
if [ "$P3" != " " ];then
 sed \
  "s?<rsoid>?$P1?g;s?<new-address>?$P2?g;s?<new-unit>?$P3?g;s?<newzip>?$P4?g;s?<new-terrid>?$P5?g;s?<initials>?$P6?g" \
 MoveRSO.psq > MoveRSO.sql
 sed "" MakeMoveRSO.tmp > MakeMoveRSO
else
 sed \
 "s?<rsoid>?$P1?g;s?<new-address>?$P2?g;s?,'<new-unit>'?,''?g;s?= '<new-unit>'?= ''?g;s?<newzip>?$P4?g;s?<new-terrid>?$P5?g;s?<initials>?$P6?g" \
 MoveRSO.psq > MoveRSO.sql
 sed "" MakeMoveRSO.tmp > MakeMoveRSO
fi
#endprocbody
echo "  DoSedMove complete."
~/sysprocs/LOGMSG "  DoSedMove complete."
# end DoSedMove.sh
