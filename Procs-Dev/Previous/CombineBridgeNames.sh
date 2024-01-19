#!/bin/bash
# CombineBridgeNames - Combine Owner1, Owner2, Owner3 names into Bridge records.
#	8/15/22.	wmk.
#	Usage. bash CombineBridgeNames <terrid>
#		<terrid> - territory ID to update SCBridge for.
#
# Dependencies.
#	/SCPA-Downloads/Terr<terrid>/Terr<terrid>_SC.db exists and has
#	  table Terr<terrid>_SCBridge.
#
# Modification History.
# ---------------------
# 4/24/22.	wmk.	*pathbase*, env var incorporated.
# 5/2/22.	wmk.	minor corrections.
# 8/15/22.	wmk.	procbodyhere/endprocbody delimiters added.
# 8/15/22.	wmk.	obsolete message and exit added.
# Legacy mods.
# 3/2/21.	wmk.	original shell.
# 3/8/21.	wmk.	"make" compatibility changes.
# 5/27/21.	wmk		modified for use with either home or Kay's system;
#				    folderbase vars added.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/7/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#					ensured set; pushd and popd echoing suppressed;
#					log messages fixed.
# 6/17/21.	wmk.	multihost support generalized.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
echo "** executing old CombineBridgeNames which uses VeniceNTerritory.db/NVenAll **"
echo " this is outdated.. aborting "
exit 1
P0="CombineBridgeNames"
P1=$1
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
  export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
TEMP_PATH=$HOME/temp
#
TID=$P1
SFX="_SCBridge"
DB1="Terr$TID"
DB_SFX="_SC.db"
# force "make" compatibility
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  CombineBridgeNames abandoned.. must specify territory." 
  echo "  CombineBriegeNames <territory> missing parameter - abandoned."
  exit 1
else
#  echo "  $P0 $P1 - initiated from Terminal" >> $system_log #
  bash ~/sysprocs/LOGMSG "  $P0 $P1 - initiated from Terminal"
  echo "  $P0 $P1 - initiated from Terminal"
fi 
pushd ./ > $TEMP_PATH/scratchfile	# preserve entry path
cd $pathbase/Procs-Dev
#procbodyhere
echo "   starting SQLTemp generation.."
echo "-- * CombineSCBridgeNames - Combine multiple names in SC Bridge records.;" > SQLTemp.sql
echo "--; *" >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'" >> SQLTemp.sql
echo "--;" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo "||		'/DB-Dev/VeniceNTerritory.db' " >> SQLTemp.sql
echo " AS db2;" >> SQLTemp.sql
echo "--;" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/Terr$TID/$DB1$DB_SFX'" >> SQLTemp.sql
echo "  AS db11;" >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct," >> SQLTemp.sql
echo " CASE " >> SQLTemp.sql
echo " WHEN LENGTH(TRIM(\"Owner 3\")) > 0" >> SQLTemp.sql
echo "  THEN TRIM(\"Owner 1\") || \", \"" >> SQLTemp.sql
echo "    || TRIM(\"Owner 2\") || \", \"" >> SQLTemp.sql
echo "    || TRIM(\"Owner 3\")" >> SQLTemp.sql
echo " WHEN LENGTH(TRIM(\"Owner 2\")) > 0 " >> SQLTemp.sql
echo "  THEN TRIM(\"Owner 1\") || \", \"" >> SQLTemp.sql
echo "    || TRIM(\"Owner 2\")" >> SQLTemp.sql
echo " ELSE  \"Owner 1\"" >> SQLTemp.sql
echo " END AS Names" >> SQLTemp.sql
echo " FROM NVenAll " >> SQLTemp.sql
echo " WHERE Acct IN (SELECT OwningParcel" >> SQLTemp.sql
echo "   FROM Terr$TID$SFX)" >> SQLTemp.sql
echo " )" >> SQLTemp.sql
echo "UPDATE Terr$TID$SFX " >> SQLTemp.sql
echo "SET Resident1 = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)" >> SQLTemp.sql
echo " THEN (SELECT Names FROM a" >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel" >> SQLTemp.sql
echo " ) " >> SQLTemp.sql
echo "ELSE Resident1" >> SQLTemp.sql
echo "END;" >> SQLTemp.sql 
#endprocbody
#
echo "   SQLTemp generation complete."
sqlite3 < SQLTemp.sql
#
if [ $? = 0 ]; then
 if [ "$USER" != "vncwmk3" ];then
  notify-send "$P0" "$P1 Complete."
 fi
 ~/sysprocs/LOGMSG "  $P0 $P1 complete."
 echo "  $P0 $P1 complete."
else
 ~/sysprocs/LOGMSG "   $P0 - error(s) encountered.. not complete."
 echo "  $P0 - error(s) encountered.. not complete."
 popd > $TEMP_PATH/scratchfile
 exit 1
fi
popd > $TEMP_PATH/scratchfile
#end proc
# ** END CombineSCBridgeNames **********;
