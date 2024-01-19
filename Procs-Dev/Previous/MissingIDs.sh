#!/bin/bash
#MissingIDs.sh - Generic post-processor to extract RU records with missing IDs.
# 8/7/22.	wmk.
#	Usage. bash MissingIDs.sh <terrid> [ -b]
#		<terrid> - territory id
#		-b (optional) = business territory flag; adds /Biz to paths.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/5/2022.	wmk.	*pathbase* support.
# 8/3/22.	wmk.	-b option added for business territories.
# 8/7/22.	wmk.	notify-send removed.
# Legacy mods.
# 3/13/12.	wmk.	original shell
# 5/27/21.	wmk.	modified for use with Kay's system; environment checked
#					and used for correct Territory folder paths.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/6/21.	wmk.	bug fixes; equality check ($)HOME,
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
TEMP_PATH=$HOME/temp
#
P1=$1
P2=${2^^}
if [ -z "$P1" ];then
 echo "MissingIDs <terrid> [-b] missing parameter(s) - abandoned."
 exit 1
fi
if [ ! -z "$P2" ];then
 if [ "$P2" != "-B" ];then
  bizprefx=
 else
  bizprefx=/Biz
 fi
fi
TID=$P1
F_BASE="Terr"
DB_SUFFX="_RU.db"
TBL_SUFFX="_RUBridge"
FOLDER=$F_BASE$TID
F_NAME=$F_BASE$TID$DB_SUFFX
T_NAME=$F_BASE$TID$TBL_SUFFX
local_debug=0	# set to 1 for debugging
#local_debug=1

if [ $local_debug = 1 ]; then
 echo "   processing $F_NAME "
 echo "    table $T_NAME "
fi

# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="/$HOME/temp"
  bash ~/sysprocs/LOGMSG "   MissingIDs initiated from Make."
  echo "   MissingIDs initiated."
else
  bash ~/sysprocs/LOGMSG "   MissingIDs initiated from Terminal."
  echo "   MissingIDs initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  MissingIDs ignored.. must specify <terrid>." >> $system_log #
  echo "  MissingIDs ignored.. must specify <terrid>."
  exit 1
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
echo "--MissingIDs.sql - Log territory RU missing parcels IDs to .csv." > SQLTemp.sql
echo "--	3/11/21.	wmk." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * subquery list." >> SQLTemp.sql
echo "-- * --------------" >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "-- ** MissingIDs **********" >> SQLTemp.sql
echo "-- *	3/12/21.	wmk." >> SQLTemp.sql
echo "-- *--------------------------" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * MissingIDs - Log territory RU missing parcels IDs to .csv." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Entry DB and table dependencies." >> SQLTemp.sql
echo "-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon" >> SQLTemp.sql
echo "-- *		Terrxxx_RUBridge - Bridge records from latest RU download " >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Exit DB and table results." >> SQLTemp.sql
echo "-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon" >> SQLTemp.sql
echo "-- *		Terrxxx_RUBridge - query exports any records with OwningParcel" >> SQLTemp.sql
echo "-- *		  unset (= \"-\") to MissingIDs.csv" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Notes." >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo ".cd '$pathbase$bizprefx/RawData'" >> SQLTemp.sql
echo ".cd './RefUSA/RefUSA-Downloads/$FOLDER'" >> SQLTemp.sql
echo ".open '$F_NAME'" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".output 'MissingIDs.csv'" >> SQLTemp.sql
echo "SELECT * FROM $T_NAME " >> SQLTemp.sql
echo "WHERE OwningParcel IS \"-\" " >> SQLTemp.sql 
echo " AND DelPending IS NOT 1;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- ** END MissingIDs **********;" >> SQLTemp.sql
#end proc body

if [ $local_debug = 1 ]; then
  popd
  jumpto EndProc
fi

jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql

jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  MissingIDs $TID complete."
echo "  MissingIDs $TID complete."
#end MissingIDs
