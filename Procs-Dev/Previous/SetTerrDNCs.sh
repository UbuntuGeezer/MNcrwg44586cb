#!/bin/bash
#SetTerrDNCs.sh - Set DNCs in territory Bridge tables.
#	6/19/22.	wmk.
#
# bash SetTerrDNCs <terrid>
#
#	<terrid> = territory ID (xxx)
#
#	Entry Dependencies.
#   	TerrIDData.db - as db3, Territory data including DoNotCalls
#			DoNotCalls - table of DONOTCALLs by territory
#		Terrxxx_RU.db - as db12, Map download data
#			Terrxxx_RUBridge - Bridge data for territory with OwningParcels set
#		Terrxxx_SC.db - as db11, Map download data
#			Terrxxx_SCBridge - Bridge data for territory with OwningParcels set
#
#	Exit Results.
#		Terrxxx_RU.db - Map download data
#			Terrxxx_RUBridge - records updated with DoNotCall, RSO and Foreign
#				set on appropriate DNC parcels
#		Terrxxx_SC.db - as db11, Map download data
#			Terrxxx_SCBridge - records updated with DoNotCall, RSO and Foreign
#				set on appropriate DNC parcels
#
# Modification History.
# ---------------------
# 6/18/22.	wmk.	*pathbase support.
# 6/19/22.	wmk.	TEMP_PATH var definition fixed.
# Legacy mods.
# 1/6/21.	wmk.	original shell; adapted from GenTerrHdr.sh
# 5/30/21.	wmk.	modified for multihost system support.
# 11/10/21.	wmk.	minor bug fix with touch where $ TEMP_PATH not set;
#					change to use LOGMSG; superfluous "s removed.
#
#	Notes.
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z $folderbase ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase= $folderbase/Territories/FL/SAR/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
#
~/sysprocs/LOGMSG "  SetTerrDNCs (Dev) started."
echo "  SetTerrDNCs (Dev) started."
if [ -z $1 ]; then
~/sysprocs/LOGMSG "  Territory id not specified... SetTerrDNCs abandoned."
  echo -e "Territory id must be specified...\nSetTerrDNCs abandoned."
  exit 1
fi
#proc body here
TID=$1
F_1=Terr
F_2=_RU.db
F_3=_SC.db
TBL_1=_RUBridge
TBL_2=_SCBridge
if [ true ]; then
TST_STR=(test)
else
TST_STR=
fi
TEMP_PATH=$folderbase/TEMP
touch $TEMP_PATH/scratchfile
error_counter=0
echo "-- SQLTemp.sql - Set DNCs in Bridge tables" > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
#echo ".cd './RawData'" >> SQLTemp.sql
echo ".open './DB-Dev/junk.db' " >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/TerrIDData.db'" >> SQLTemp.sql
echo " AS db4;" >> SQLTemp.sql
#pragma db4.table_info(DoNotCalls);

echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/$F_1$TID/$F_1$TID$F_3'" >> SQLTemp.sql
echo "  AS db11;" >> SQLTemp.sql
#  PRAGMA db11.table_info(Terrxxx_SCBridge);


echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/RefUSA/RefUSA-Downloads/$F_1$TID/$F_1$TID$F_2'" >> SQLTemp.sql
echo "  AS db12;" >> SQLTemp.sql
#  PRAGMA db12.table_info(Terrxxx_RUBridge);

#-- Update RU Bridge records

echo "WITH a AS (SELECT * FROM db4.DoNotCalls" >> SQLTemp.sql
echo "  WHERE TerrID IS \"$TID\")" >> SQLTemp.sql
echo "UPDATE db12.$F_1$TID$TBL_1 " >> SQLTemp.sql
echo "SET DoNotCall =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "ELSE DoNotCall" >> SQLTemp.sql
echo "END, " >> SQLTemp.sql
echo "RSO =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN (SELECT RSO FROM a " >> SQLTemp.sql
echo "  WHERE PropID IS $F_1$TID$TBL_1.OwningParcel)" >> SQLTemp.sql
echo "ELSE RSO" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "\"Foreign\" =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN (SELECT \"Foreign\" FROM a" >> SQLTemp.sql
echo "  WHERE PropID is $F_1$TID$TBL_1.OwningParcel) " >> SQLTemp.sql
echo "ELSE \"Foreign\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE OwningParcel IN (SELECT PropID FROM a);" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
#-- * Update Terrxxx_SCBridge records;
echo "WITH a AS (SELECT * FROM db4.DoNotCalls" >> SQLTemp.sql
echo "  WHERE TerrID IS \"$TID\")" >> SQLTemp.sql
echo "UPDATE $F_1$TID$TBL_2 " >> SQLTemp.sql
echo "SET DoNotCall = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN 1 " >> SQLTemp.sql
echo "ELSE DoNotCall" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "RSO = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN (SELECT RSO FROM a" >> SQLTemp.sql
echo "  WHERE PropID IS $F_1$TID$TBL_2.OwningParcel)" >> SQLTemp.sql
echo "ELSE RSO" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "\"Foreign\" = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo " THEN (SELECT \"Foreign\" FROM a" >> SQLTemp.sql
echo "  WHERE PropID is $F_1$TID$TBL_2.OwningParcel) " >> SQLTemp.sql
echo "ELSE \"Foreign\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE OwningParcel IN (SELECT PropID FROM a);" >> SQLTemp.sql
#echo " AND UnitAddress IN (SELECT UnitAddress FROM a)" >> SQLTemp.sql
#echo " AND (Unit IS  \"\"" >> SQLTemp.sql
#echo "      OR Unit IS NULL " >> SQLTemp.sql
#echo "      OR Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
#echo "        WHERE UnitAddress" >> SQLTemp.sql
#echo " 	    IS $F_1$TID$TBL_2.UnitAddress));" >> SQLTemp.sql
# 
echo ".quit" >> SQLTemp.sql
if [ 1 -eq 1 ]; then
  jumpto TrySQL
fi
if [ 1 -eq 1 ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
~/sysprocs/LOGMSG "  SetTerrDNCs (Dev) $TST_STR complete."
echo "  SetTerrDNCs (Dev) $TST_STR complete."
# end SetTerrDNCs.sh
