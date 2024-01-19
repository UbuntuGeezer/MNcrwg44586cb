#!/bin/bash
echo " ** TestScript.sh out-of-date **";exit 1
echo " ** TestScript.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash TestScript.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# 12/11/22.	wmk.	run SetToday.sh to export TODAY env var.
# 12/12/22.	wmk.	SetTody.sh path corrected.
# Legacy mods.
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
P1=$1
TID=$P1
TN="Terr"
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  TestScript - initiated from Make"
  echo "  TestScript - initiated from Make"
else
  ~/sysprocs/LOGMSG "  TestScript - initiated from Terminal"
  echo "  TestScript - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

# Pretrap.tmp - template preamble for shells using error handling.
#	5/28/23.	wmk.
# set *MYPROC = process name to display in error handling.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
export thisid=$$
export MYPROC=$0
if [ -z "$build_log" ];then
 export build_log=$TEMP_PATH/BuildLog.txt
fi
trap 'previous_command=$this_command;this_command=$BASH_COMMAND;' DEBUG
echo "ATTACH  '$pathbase/DB-Dev/GoobleDeeDook.db'"  > SQLTemp.sql
echo " as db2;"  >> SQLTemp.sql
echo "UPDATE db2.BogusTable"  >> SQLTemp.sql
echo "SET ANything=0"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
cmd=$previous_command ret=$?
if [ $ret -ne 0 ];then
 echo "$cmd FAILED.. error code = $ret"
fi
if [ $ret -eq 0 ];then
 jumpto NormalExit
# Posttrap.sh - template postscript for shells using error handling.
#   5/16/23. wmk
# end test postscript
else
 # error handling.
 export MYPROC=$0
 ~/sysprocs/BLDMSG "  ** $MYPROC $P1 - $cmd FAILED **"
  grep PPid /proc/$$/task/$$/status | \
 mawk \
 '{print "#!/bin/bash";print "export idtext="$2;print "echo \"this process id=$thisid\"";print "echo \"parent process id=$idtext\""}' > temp.sh
 chmod +x temp.sh
 sed -i '1,4d' temp.sh
 . ./temp.sh
# at this point *idtext env var contains process ID that
# can be passed to child processes.
 ps $idtext >> $build_log
 exit 1
fi
jumpto NormalExit
NormalExit:

echo "  TestScript complete."
~/sysprocs/LOGMSG "  TestScript complete."
#end proc
