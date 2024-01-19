#!/bin/bash
echo " ** MissingIDs.sh out-of-date **";exit 1
# MissingIDs.sh - Generic post-processor to extract RU records with missing IDs.
# 4/3/23.	wmk.
#	Usage. bash MissingIDs.sh <terrid>|<spec-db> [ -b | -s ]
#		<terrid> - territory id
#		<spec-db> = special db name (e.g. BirdBayDr)
#		-b (optional) = business territory flag; adds /Biz to paths.
#		-s (optional) = "special" territory flag; adds /Special to paths,
#			output to RefUSA-Donwloads/Special folder.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.	wmk.	perform 9/23 automated mod.
# 3/29/23.	wmk.	add linecount summary message; eliminate jumpto references.
# 3/31/23.	wmk.	skip OBSOLETE territory.
# 4/3/23.	wmk.	-s option support.
# Legacy mods.
# 5/5/2022.	wmk.	*pathbase* support.
# 8/3/22.	wmk.	-b option added for business territories.
# 8/7/22.	wmk.	notify-send removed.
# Legacy mods.
# 3/13/12.	wmk.	original shell
# 5/27/21.	wmk.	modified for use with Kay's system; environment checked
#					and used for correct Territory folder paths.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/6/21.	wmk.	bug fixes; equality check ($)HOME,
if [ -z "$folderbase" ];then
if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
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
 if [ "$P2" == "-S" ];then
  spec=Special
 else
  spec=
 fi
fi	# P2 specified
TID=$P1
F_BASE=Terr
DB_SUFFX=_RU.db
SPEC_SUFFX=.db
TBL_SUFFX=_RUBridge
if [ -z "$spec" ];then
 FOLDER=$F_BASE$TID
 F_NAME=$F_BASE$TID$DB_SUFFX
 T_NAME=$F_BASE$TID$TBL_SUFFX
else
 FOLDER=$spec
 F_NAME=$P1$SPEC_SUFFX
 T_NAME=Spec$TBL_SUFFX
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
# skip OBSOLETE territory.
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo "  Territory $P1 OBSOLETE - skipping..."
 exit 0
fi
#
#procbodyhere
echo "--MissingIDs.sql - Log territory RU missing parcels IDs to .csv." > SQLTemp.sql
echo "--	3/31/23.	wmk." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * subquery list." >> SQLTemp.sql
echo "-- * --------------" >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "-- ** MissingIDs **********" >> SQLTemp.sql
echo "-- *	3/31/23.	wmk." >> SQLTemp.sql
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
echo ".headers OFF" >> SQLTemp.sql
echo ".output 'MissingIDs.csv'" >> SQLTemp.sql
echo "SELECT * FROM $T_NAME " >> SQLTemp.sql
echo "WHERE OwningParcel IS \"-\" " >> SQLTemp.sql 
echo " AND DelPending IS NOT 1;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- ** END MissingIDs **********;" >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
export f_name=$FOLDER/MissingIDs.csv
#echo "f_name = '$f_name'"
wc -l $pathbase/$rupath/$FOLDER/MissingIDs.csv > $TEMP_PATH/MissingCount.txt
mawk '{print substr($2,index($2,ENVIRON["f_name"])) " " $1 " mismatched records."}' $TEMP_PATH/MissingCount.txt
~/sysprocs/LOGMSG "  MissingIDs $TID complete."
echo "  MissingIDs $TID complete."
#end MissingIDs
