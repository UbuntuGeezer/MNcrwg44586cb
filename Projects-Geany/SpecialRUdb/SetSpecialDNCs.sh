#!/bin/bash
echo " ** SetSpecialDNCs.sh out-of-date **";exit 1
echo " ** SetSpecialDNCs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# SetSpecialDNCs.sh - Set DNCs in Special database Bridge tables.
#	4/24/22.	wmk.
#
# bash SetSpecialDNCs <special-db>
#
#	<special-db> = Special database name (e.g. BayIndiesMHP)
#
#	Entry Dependencies.
#   	TerrIDData.db - as db3, Territory data including DoNotCalls
#			DoNotCalls - table of DONOTCALLs by territory
#		<special-db>.db - as db30, Special RU database
#			Spec_RUBridge - Bridge data for territory with OwningParcels set
#
#	Exit Results.
#		Terrxxx_RU.db - Map download data
#			Terrxxx_RUBridge - records updated with DoNotCall, RSO and Foreign
#				set on appropriate DNC parcels
#
# Modification History.
# ---------------------
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# Legacy mods.
# 11/12/21.	wmk.	original shell; adpated from SetSpecialDNCs.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var;
#			 change to use LOGMSG.
# 3/14/22.	wmk.	env var terrbase added for TX/HC/99999 support.
# Legacy mods.
#	1/6/21.		wmk.	original shell; adapted from GenTerrHdr.sh
#	5/30/21.	wmk.	modified for multihost system support.
#	9/11/21.	wmk.	name change to SetMHPdncs.sh; code cleanup;
#	9/13/21.	wmk.	DoNotCalls conditional added to TerrIDData.db
#						extraction; documentation corrected since only
#						Terrxxx_RUBridge records updated.
#	9/18/21.	wmk.	DoNotCals corrected to DoNotCall.
#
#	Notes. Bay Indies must use UnitAddress to set DONOTCALLs, since
#	all properties have the same parcel ID.

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
if [ -z "$terrbase" ];then
 terrbase=$pathbase
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Make."
else
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Terminal."
fi
TEMP_PATH=$folderbase/temp
#
#echo "  SetSpecialDNCs (Dev) started." >> $system_log #
~/sysprocs/LOGMSG "  SetSpecialDNCs (Dev) started."
echo "  SetSpecialDNCs (Dev) started."
if [ -z "$1" ]; then
  echo "  <special-db> not specified... SetSpecialDNCs abandoned." >> $system_log #
  echo -e "<special-db> must be specified...\nSetSpecialDNCs abandoned."
  exit 1
fi
#proc body here
DB_BASENAME=$1
F_1=Spec
F_2=_RU.db
F_3=_SC.db
TBL_1=_RUBridge
TBL_2=_SCBridge
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
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
echo " ||		'/RawData/RefUSA/RefUSA-Downloads/Special/$DB_BASENAME.db'" >> SQLTemp.sql
echo "  AS db30;" >> SQLTemp.sql
#  PRAGMA db30.table_info(Spec_RUBridge);

#-- Update RU Bridge records

echo "WITH a AS (SELECT * FROM db4.DoNotCalls" >> SQLTemp.sql
echo ")" >> SQLTemp.sql
echo "UPDATE db30.$F_1$TBL_1 " >> SQLTemp.sql
echo "SET DoNotCall =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a)" >> SQLTemp.sql
echo " THEN 1" >> SQLTemp.sql
echo "ELSE DoNotCall" >> SQLTemp.sql
echo "END, " >> SQLTemp.sql
echo "RSO =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a)" >> SQLTemp.sql
echo " THEN (SELECT RSO FROM a " >> SQLTemp.sql
echo "  WHERE UnitAddress IS " >> SQLTemp.sql
echo "    UPPER(TRIM($F_1$TBL_1.UnitAddress)) )" >> SQLTemp.sql
echo "ELSE RSO" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "\"Foreign\" =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a)" >> SQLTemp.sql
echo " THEN (SELECT \"Foreign\" FROM a " >> SQLTemp.sql
echo "  WHERE UnitAddress IS " >> SQLTemp.sql
echo "    UPPER(TRIM($F_1$TBL_1.UnitAddress)) )" >> SQLTemp.sql
echo "ELSE \"Foreign\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a);" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 < SQLTemp.sql
~/sysprocs/LOGMSG "  SetSpecialDNCs (Dev) $TST_STR complete."
echo "  SetSpecialDNCs (Dev) $TST_STR complete."
