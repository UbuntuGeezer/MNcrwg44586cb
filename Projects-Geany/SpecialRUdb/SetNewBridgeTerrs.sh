#!/bin/bash
echo " ** SetNewBridgeTerrs.sh out-of-date **";exit 1
echo " ** SetNewBridgeTerrs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash SetNewBridgeTerrs.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
P1=$1
TID=$P1
TN="Terr"
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  SetNewBridgeTerrs - initiated from Make"
  echo "  SetNewBridgeTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SetNewBridgeTerrs - initiated from Terminal"
  echo "  SetNewBridgeTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

-- SetNewBridgeTerrs.s - set new special Bridge CongTerrID fields.
--		7/18/21.	16:47;
.open '$pathbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special/BayIndiesMHP.db'
ATTACH '$pathbase/Territories/DB-Dev/PolyTerri.db'
 AS db5;
ATTACH '$pathbase/Territories/DB-Dev/MultiMail.db'
 AS db3;
-- find matches in TerrProps;
with a AS (select TRIM(UnitAddress) AS StreetAddr,
 CongTerrID AS TerrNo FROM TerrProps 
 where TerrNo IN (SELECT TerrID from TerrList))
UPDATE Spec_RUBridge
SET CongTerrID = (SELECT TerrNo FROM a 
CASE 
WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS trim(UnitAddress))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
-- now find matches in SplitProps;
with a AS (select TRIM(UnitAddress) AS StreetAddr,
 CongTerrID AS TerrNo FROM SplitProps 
 where TerrNo IN (SELECT TerrID from TerrList))
UPDATE Spec_RUBridge
SET CongTerrID =
CASE 
WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS trim(UnitAddress))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
-- end SetNewBridgeTerrs.sq;


#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "SetNewBridgeTerrs.sh" "SetNewBridgeTerrs processing complete. $P1"
fi
echo "  SetNewBridgeTerrs complete."
~/sysprocs/LOGMSG "  SetNewBridgeTerrs complete."
#end proc
