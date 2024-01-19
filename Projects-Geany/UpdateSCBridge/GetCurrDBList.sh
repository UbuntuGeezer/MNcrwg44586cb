#!/bin/bash
echo " ** GetCurrDBList.sh out-of-date **";exit 1
# GetCurrDBList.sh - Get current DB list from /Special to DBList.txt.
#	5/4/23.	wmk.
#
# Usage. bash  GetCurrDBList.sh <mmdd> 
#
#	<mmdd> = monthday of DBList in /Special for local folder name
#
# Exit. UpdateSCBridge/DBList<mmdd>.txt is copy of DBList.txt from /Special
#		UpdateSCBridge/DBList.txt is DBList<mmdd>.txt with '.db' suffixes removed.
#
# Dependencies.
#		/Special/DBList.txt file exsits as current /Special db list.
#
# Modification History.
# ---------------------
# 5/4/23.	wmk.	original shell.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
if [ -z "$P1" ];then
 echo "GetCurrDBList <mmdd> missing parameter(s) - abandoned."
 exit 1
fi
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
  ~/sysprocs/LOGMSG "  GetCurrDBList - initiated from Make"
  echo "  GetCurrDBList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetCurrDBList - initiated from Terminal"
  echo "  GetCurrDBList - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/UpdateSCBridge
pushd ./ > $TEMP_PATH/scratchfile
cd $projpath
if ! test -f $pathbase/$scpath/Special/DBList.txt;then
 echo "** Missing /Special/DBList.txt - run /Special/GenDBList.sh **"
 exit 1
fi
cp -pv $pathbase/$scpath/Special/DBList.txt ./DBList$P1.txt
sed  's?.db??g' DBList$P1.txt > DBList.txt
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  GetCurrDBList $P1 complete."
~/sysprocs/LOGMSG "  GetCurrDBList $P1 complete."
# end GetCurrDBList.sh
