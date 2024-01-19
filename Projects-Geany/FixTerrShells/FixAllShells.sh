#!/bin/bash
echo " ** FixAllShells.sh out-of-date **";exit 1
echo " ** FixAllShells.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllShells.sh - fix all .sh files with *pathbase* support.
# 5/28/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
#	5/15/22.	wmk.
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "FixAllShells <shellpath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllShells path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllShells - initiated from Make"
  echo "  FixAllShells - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllShells - initiated from Terminal"
  echo "  FixAllShells - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixShells
cd $P1
ls *.sh > $TEMP_PATH/ShellList.txt
if [ $? -ne 0 ];then
 echo "FixAllShells no *.sh* files found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllShells no *.sh* files found - abandoned."
 exit 1
fi
# loop on ShellList.txt...
file=$TEMP_PATH/ShellList.txt
sed -i 's?.sh??g' $TEMP_PATH/ShellList.txt
while read -e;do
 len=${#REPLY}
# len2=$((len-3))
# fn=${REPLY:0:len2}
 fn=$REPLY
 echo "processing $fn ..."
 $projpath/FixShell.sh $P1 $fn
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllShells $P1/$P2 complete."
echo "  FixAllShells $P1 complete."
# end FixAllShells.sh
