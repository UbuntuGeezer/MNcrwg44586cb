#!/bin/bash
echo " ** FixSyncTerrs.sh out-of-date **";exit 1
echo " ** FixSyncTerrs.sh out-of-date **";exit 1
# FixSyncTerrs.sh - Fix SyncTerrToSpec.sql
#	9/21/22.	wmk.
#
# Usage. bash  FixSyncTerrs.sh <rawpath> <terrid>
#
#	<rawpath> = raw data base path (e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<terrid> = territory id (e.g. 201)
#
# Exit.	*<rawpath>*/Terr<terrid>/SyncTerrtoSpec.sql checked for the string
#			'--WHERE rowid NOT IN'; if present, *sed* run with sedSyncFixes.txt
#		to correct the duplicates DELETE query.
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1	# rawpath
P2=$2	# terrid
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixSyncTerrs  <rawpath> <terrid> missing parameter(s) - abandoned."
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
 export pathbase=$folderbase/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixSyncTerrs - initiated from Make"
  echo "  FixSyncTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixSyncTerrs - initiated from Terminal"
  echo "  FixSyncTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$pathbase/Projects-Geany/MigrationRepairs
RUpath=$P1/Terr$P2
if ! test -f $RUpath/SyncTerrToSpec.sql;then
 echo "  Terr$P2 no SyncTerrToSpec.sql.. skipped."
 exit 0
fi
grep -e "automated) correct duplicate deletions" $RUpath/SyncTerrToSpec.sql
if [ $? -eq 0 ];then
 echo "$RUPATH/SyncTerrToSpec.sql already fixed - skipped."
 exit 0
fi
grep -e "--WHERE rowid NOT IN" $RUpath/SyncTerrToSpec.sql
if [ $? -ne 0 ];then
 echo "$RUPATH/SyncTerrToSpec.sql '--WHEN..' not found - skipped."
 exit 0
fi
cp -p $RUpath/SyncTerrToSpec.sql $RUpath/SyncTerrToSpec.bak
sed -i -f $projpath/sedSyncFixes.txt $RUpath/SyncTerrToSpec.sql
#endprocbody
echo "  FixSyncTerrs $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixSyncTerrs $P1 $P2 complete."
# end FixSyncTerrs

