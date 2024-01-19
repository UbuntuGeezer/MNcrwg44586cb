#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllPSQs.sh - fix all Makefiles with *pathbase* support.
#	5/30/22.	wmk.
# Modification History.
# ---------------------
# 5/7/22.	wmk.	original code.
# 5/30/22.	wmk.	handle folder '.' passed.
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "FixAllPSQs <sqlpath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllPSQs path '$P1' does not exist - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixAllPSQs - initiated from Make"
  echo "  FixAllPSQs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllPSQs - initiated from Terminal"
  echo "  FixAllPSQs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixSQLs
if [ "$P1" != "." ];then
 cd $P1
fi
ls *.psq > $projpath/PSQList.txt
if [ $? -ne 0 ];then
 echo "FixAllPSQs no *.sql* files found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllPSQs no *.sql* files found - abandoned."
 exit 1
fi
sed -i 's?.psq??g' $projpath/PSQList.txt
# loop on SQL.txt...
file=$projpath/PSQList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 echo "processing $fn ..."
 $projpath/FixSQL.sh $P1 $fn PSQ
done < $file
#end proc body.
if [ "$USER" != "vncwmk3" ];then
 notify-send "FixAllPSQs" "$P1/$P2 complete"
fi
~/sysprocs/LOGMSG "  FixAllPSQs $P1/$P2 complete."
echo "  FixAllPSQs $P1/$P2 complete."
# end FixAllPSQs.sh
