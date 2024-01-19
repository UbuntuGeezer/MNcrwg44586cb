#!/bin/bash
echo " ** FixAllMakes.sh out-of-date **";exit 1
echo " ** FixAllMakes.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllMakes.sh - fix all Makefiles with *pathbase* support.
#	5/28/22.	wmk.
#
# Modification History.
# ---------------------
# 5/4/22.	wmk.	original code.
# 5/15/22.  wmk.   (automated) pathbase corrected to FL/SARA/86777.
# 5/16/22.	wmk.	code tidying.
# 5/28/22.  wmk.   (automated) TX/HDLG/9999 -> FL/SARA/86777.

P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "FixAllMakes <makepath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllMakes path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllMakes - initiated from Make"
  echo "  FixAllMakes - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllMakes - initiated from Terminal"
  echo "  FixAllMakes - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixMakes
cd $P1
ls Make* > $projpath/MakeList.txt
if [ $? -ne 0 ];then
 echo "FixAllMakes no *makefiles* found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllMakes no *makefiles* found - abandoned."
 exit 1
fi
# loop on MakeList.txt...
file=$projpath/MakeList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 echo "processing $fn ..."
 $projpath/FixMake.sh $P1 $fn
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllMakes $P1/$P2 complete."
echo "  FixAllMakes $P1/$P2 complete."
# end FixAllMakes.sh
