#!/bin/bash
# BatchMake.sh - Batch *make testing shell.
# 5/12/23.	wmk.
#
# Usage. bash  BatchMake.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/12/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
mypid=$$
#P1=$1
#P2=$2
#if [ -z "$P1" ] || [ -z "$P2" ];then
# echo "BatchMake <mm> <dd> missing parameter(s) - abandoned."
# exit 1
#fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  BatchMake - initiated from Make"
  echo "  BatchMake - initiated from Make"
else
  ~/sysprocs/LOGMSG "  BatchMake - initiated from Terminal"
  echo "  BatchMake - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
./DoSed.sh 2>>$TEMP_PATH/BuildLog.txt
mkerr=$?
if [ $mkerr -ne 0 ];then
 echo " ** error in DoSed **"
 jumpto ErrHandler
else
 echo "  DoSed complete."
fi
make --silent -f MakeFile.tmp 2>>$TEMP_PATH/BuildLog.txt
mkerr=$?
if [ $mkerr -ne 0 ];then
 echo " ** error in Makefile.tmp **"
 jumpto ErrHandler
else
 echo "  Makefile.tmp complete."
fi
#endprocbody
echo "  BatchMake complete."
~/sysprocs/LOGMSG "  BatchMake complete."
exit 0
jumpto ErrHandler
ErrHandler:
 ./BLDMSG " BatchMake pid =  '$mypid'  error:  '$mkerr'"
echo "** BatchMake error handler..."
echo " BatchMake pid = " $mypid  "error: " $mkerr
 ./BLDMSG "BatchMake parent info follows..."
 grep PPid /proc/$mypid/task/$mypid/status >> $TEMP_PATH/BuildLog.txt
 ps $mypid | mawk '{print "  " $0}' >> $TEMP_PATH/BuildLog.txt
 exit 1
# end BatchMake.sh
