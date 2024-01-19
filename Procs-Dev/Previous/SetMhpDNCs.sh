#!/bin/bash
#SetBIDNCs.sh - Set DNCs in Bay Indes Bridge tables.
#	5/31/22.	wmk.
#
# bash SetTerrDNCs <terrid>
#
#	<terrid> = territory ID (xxx) MHP territory ID
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
#
# *Modification History.
# * ---------------------
# * 5/31/22.	wmk.	*pathbase* support; folderbase improvements; bug fix so
#				 exits if not numeric <terrid>.
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
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
P1=$1
#
~/sysprocs/LOGMSG "  SetTerrDNCs (Dev) started."
echo "  SetTerrDNCs (Dev) started."
if [ -z "$P1" ]; then
  echo "  Territory id not specified... SetTerrDNCs abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nSetTerrDNCs abandoned."
  exit 1
fi
firstchar=${P1:0:1}
[[ $firstchar =~ ^[0-9]+$ ]] \
 && { echo "is numeric" > $TEMP_PATH/scratchfile ; } \
 || { echo " SetTerrDNCs <terrid> not numeric - abandoned"; exit 1; }
echo "end test"
exit 0
#proc body here
TID=$1
F_1=Terr
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
echo " ||		'/RawData/SCPA/SCPA-Downloads/$F_1$TID/$F_1$TID$F_3'" >> SQLTemp.sql
echo "  AS db11;" >> SQLTemp.sql
#  PRAGMA db11.table_info(Terrxxx_SCBridge);


echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/RefUSA/RefUSA-Downloads/$F_1$TID/$F_1$TID$F_2'" >> SQLTemp.sql
echo "  AS db12;" >> SQLTemp.sql
#  PRAGMA db12.table_info(Terrxxx_RUBridge);

#-- Update RU Bridge records

echo "WITH a AS (SELECT * FROM db4.DoNotCalls" >> SQLTemp.sql
echo "  WHERE TerrID IS \"$TID\"" >> SQLTemp.sql
echo "	 AND DoNotCall <> 1" >> SQLTemp.sql 
echo ")" >> SQLTemp.sql
echo "UPDATE db12.$F_1$TID$TBL_1 " >> SQLTemp.sql
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
echo "    UPPER(TRIM($F_1$TID$TBL_1.UnitAddress)) )" >> SQLTemp.sql
echo "ELSE RSO" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo "\"Foreign\" =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a)" >> SQLTemp.sql
echo " THEN (SELECT \"Foreign\" FROM a " >> SQLTemp.sql
echo "  WHERE UnitAddress IS " >> SQLTemp.sql
echo "    UPPER(TRIM($F_1$TID$TBL_1.UnitAddress)) )" >> SQLTemp.sql
echo "ELSE \"Foreign\"" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "  IN (SELECT UnitAddress FROM a);" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 < SQLTemp.sql
date +%T >> $system_log #
echo "  SetTerrDNCs (Dev) $TST_STR complete." >> $system_log #
~/sysprocs/LOGMSG "  SetMhpDNCs (Dev) $TST_STR complete."
echo "  SetMhpDNCs (Dev) $TST_STR complete."
