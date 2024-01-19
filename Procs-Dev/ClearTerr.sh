#!/bin/bash
echo " ** ClearTerr.sh out-of-date **";exit 1
#ClearTerr.sh - Clear territory records from main dbs for territory.
#	10/6/22.	wmk.
#
# bash ClearTerr	terrid
#
#	terrid = territory id for which to clear records
#
#	Entry Dependencies.
#	~/DB/junk.db is meta db for shell scripts
#   ~/DB/MultiMail.db is master db for multimail territory records
#   ~/DB/PolyTerri.db is master db for polygon territory records
#	For testing, this shell is run from the ~/Procs-Dev folder
#
#	Exit Results.
#	PolyTerri.TerrProps and MultiMail.SplitPros records for territory
#		xxx deleted.
#	SQLTemp.txt written to proc initiating folder (Procs-Dev)
#	SQLTrace.txt written to ~/DB-Dev folder
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/6/22.	wmk.	comments tidied; jumpto references removed.
# Legacy mods.
# 5/2/22.		wmk.	*pathbase* support.
# * Legacy mods.
#	11/26/20.	wmk.	original shell
#	1/10/21.	wmk.	include terrid in log messages
#	3/8/21.		wmk.	adapted for use with "make".
#	4/7/21.		wmk.	one-line log messages.
#	4/29/21.	wmk.	delete DONOTCALLs and start fresh.
#   5/27/21.	wmk		modified for use with either home or Kay's system;
#					    folderbase vars added.
#	5/30/21.	wmk.	modified for multihost system support.
#	6/7/21.		wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#						ensured set.
#	6/17/21.	wmk.	multihost code generalized.
#
#	Notes. This shell runs 4 queries on the master dbs. The first two
#	set DelPending for the specified territory. Then a COMMIT is executed,
# 	after which the records are actually deleted. This is a safeguard so
#	that if a system crash occurs while the records are actually being
#	deleted, they will still at least have the DelPending flag set.

if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
fi
TEMP_PATH=$HOME/temp
#
#
P1=$1
~/sysprocs/LOGMSG "  ClearTerr $P1 (Dev) started."
echo "  ClearTerr $P1 started."
if [ -z $P1 ]; then
  ~/sysprocs/LOGMSG "  Territory id not specified... ClearTerr abandoned."
  echo -e "Territory id must be specified...\ClearTerr abandoned."
  exit 1
fi
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
echo "-- SQLTemp.sql - ClearTerr.sh - Clear territory" > SQLTemp.sql
echo "-- records for territory from main dbs." >> SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './DB-Dev' " >> SQLTemp.sql
echo ".shell touch SQLTrace.txt" >> SQLTemp.sql
DB_END=".db"
DB_END2=".db"
TBL_END1=""
TBL_END2=""
TBL_END3=""
DB_NAME="MultiMail$DB_END"
DB_NAME2="PolyTerri$DB_END2"
TBL_NAME1="SplitProps$TBL_END1"
TBL_NAME2="TerrProps$TBL_END2"
TBL_NAME3="$TBL_END3"
#
echo ".shell echo \"Opening ./Terr$TID/$DB_NAME\" | awk '{print \$1}' > SQLTrace.txt" >> SQLTemp.sql
echo ".open junk.db " >> SQLTemp.sql
#
echo "ATTACH '$DB_NAME' " >> SQLTemp.sql
echo " AS db3;" >> SQLTemp.sql
#
echo "ATTACH '$DB_NAME2' " >> SQLTemp.sql
echo "  AS db5;"  >> SQLTemp.sql
#
echo ".shell echo \"DelTerr - Set DelPending on territory $TID records.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#
#
#-- * Allow for system crash between setting DelPending and actually
#-- * deleting;
# 
echo "-- set all MultiMail records for territory $TID to DelPending"  >> SQLTemp.sql
echo "UPDATE SplitProps"  >> SQLTemp.sql
echo " SET DelPending = 1"  >> SQLTemp.sql
echo " WHERE CongTerrID IS \"$TID\" " >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
# 
echo "-- set all PolyTerri records for territory $TID to DelPending"  >> SQLTemp.sql
echo "UPDATE TerrProps"  >> SQLTemp.sql
echo " SET DelPending = 1"  >> SQLTemp.sql
echo " WHERE CongTerrID IS \"$TID\""  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
#
#
echo ".shell echo \"RmvTerr - DELETE territory $TID records.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#-- delete all MultiMail records with DelPending"  >> SQLTemp.sql
echo "DELETE FROM SplitProps"  >> SQLTemp.sql
echo " WHERE DelPending = 1"  >> SQLTemp.sql
echo " AND CongTerrID IS \"$TID\";"  >> SQLTemp.sql
#-- delete all PolyTerri records with DelPending
echo "DELETE FROM TerrProps"  >> SQLTemp.sql
echo " WHERE DelPending = 1"  >> SQLTemp.sql
echo " AND CongTerrID IS \"$TID\";"  >> SQLTemp.sql
#
echo ".shell echo \"ClearTerr complete..\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#
echo ".quit" >> SQLTemp.sql
#
sqlite3 < SQLTemp.sql
#
~/sysprocs/LOGMSG "  ClearTerr $TID (Dev) $TST_STR complete."
echo "  ClearTerr $TID (Dev) $TST_STR complete."
