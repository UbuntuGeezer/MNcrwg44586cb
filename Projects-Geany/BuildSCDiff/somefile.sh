#/bin/bash
echo " ** somefile.sh out-of-date **";exit 1
echo " ** somefile.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/5/21.	wmk.	07:31
#	Usage. bash <filename>.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
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
if [ -z "$system_log" ]; then
  system_log="/media/ubuntu/Windows/Users/Bill/ubuntu/SystemLog.txt"
  TEMP_PATH="/home/ubuntu/temp"
  ~/sysprocs/LOGMSG "  <filename> - initiated from Make"
else
  ~/sysprocs/LOGMSG "  <filename> - initiated from Terminal"
  echo "  <filename> - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#proc body here
pushd ./ > $TEMP_PATH/bitbucket.txt
