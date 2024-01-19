#/bin/bash
echo " ** hdrFixXXXRU.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/8/21.	wmk.	10:39
#	Usage. bash FixXXXRU.sh
#		
# Dependencies.
#	TerrXXX_RU.db exists in RefUSA-Downloads/TerrXXX folder
#	VeniceNTerritory.db exists in DB-Dev folder
#
# Modification History.
# ---------------------
# 3/11/21.	wmk.	original shell (template)
# 5/27/21.	wmk.	modified for use with Kay's system; folderbase env
#					var added.
# 6/6/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH
#					ensured set; superfluous popd in epilog removed.
# 6/8/21.	wmk.	switch logic in ($)HOME check so anything other than
#					/home/ubuntu gets set to ($)HOME folderbase.

#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
TID=$P1
TN="Terr"
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase="/media/ubuntu/Windows/Users/Bill"
else 
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$HOME/temp"
  ~/sysprocs/LOGMSG "  FixXXXRU - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixXXXRU - initiated from Terminal"
  echo "  FixXXXRU - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#proc body here
pushd ./ > $TEMP_PATH/bitbucket.txt
popd   > $TEMP_PATH/bitbucket.txt
#end proc body

# conditional to skip SQL execution.
if [ not = true ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
# now run RUTidyTerr_db.sh to tidy up fixes.
#bash /media/ubuntu/Windows/Users/Bill/Territories/Procs-Dev/RUTidyTerr_db.sh XXX
jumpto EndProc
EndProc:
#popd >> $TEMP_PATH/bitbucket.txt
notify-send "FixXXXRU.sh" "Terr XXX PostProcessing complete. $P1"
echo "  Terr XXX PostProcessing complete."
#end proc
