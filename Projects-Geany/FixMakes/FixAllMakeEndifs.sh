#!/bin/bash
echo " ** FixAllMakeEndifs.sh out-of-date **";exit 1
echo " ** FixAllMakeEndifs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#	5/28/22.	wmk.
# FixAllMakeEndifs.sh - fix all Makefiles with *pathbase* support.
# Modification History.
# 5/10/22.	wmk.	original code.
# 5/15/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
P1=$1
if [ -z "$P1" ];then
 echo "FixAllMakeEndifs <makepath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllMakeEndifs path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllMakeEndifs - initiated from Make"
  echo "  FixAllMakeEndifs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllMakeEndifs - initiated from Terminal"
  echo "  FixAllMakeEndifs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixMakes
cd $P1
ls Make* > $projpath/MakeList.txt
if [ $? -ne 0 ];then
 echo "FixAllMakeEndifs no *makefiles* found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllMakeEndifs no *makefiles* found - skipping."
 exit 1
fi
# loop on MakeList.txt...
file=$projpath/MakeList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 echo "processing $fn ..."
 $projpath/FixMakeEndifs.sh $P1 $fn
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllMakeEndifs $P1 complete."
echo "  FixAllMakeEndifs $P1 complete."
# end FixAllMakeEndifs.sh

