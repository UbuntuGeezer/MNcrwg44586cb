#/bin/bash
echo " ** hdrFixXXXSC.sh out-of-date **";exit 1
#hdrFixXXXsc.sh - Fix RU records territory Any postprocessor.
#FixXXXsc.sh - Fix RU records territory XXX postprocessor.
# 6/19/21.	wmk
#	Usage. bash FixXXXsc.sh
#		
# Dependencies.
#	FixXXX_SC.db exists in SCPA-Downloads/FixXXX folder
#	VeniceNTerritory.db exists in DB-Dev folder
#
# Modification History.
# ---------------------
# 3/15/21.	wmk.	original shell (template)
# 5/29/21.	wmk.	add code for multihost support.
# 6/19/21.	wmk.	bug fix (%)folderbase reference; multihost generalized.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
if [ "$HOME" = "/home/bill" ]; then
 folderbase=$HOME
else 
 folderbase="/media/ubuntu/Windows/Users/Bill"
fi
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$HOME/temp"
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Terminal"
  echo "  FixXXXsc - initiated from Terminal"
fi 
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
# now run SCTidyTerr_db.sh to tidy up fixes.
bash $folderbase/Territories/Procs-Dev/SCTidyTerr_db.sh XXX
jumpto EndProc
EndProc:
popd >> $TEMP_PATH/bitbucket.txt
notify-send "FixXXXsc.sh" "Terr XXX PostProcessing complete. $P1"
echo "  Terr XXX PostProcessing complete."
#end proc
