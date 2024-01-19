#!/bin/bash
echo " ** FixMakes=.sh out-of-date **";exit 1
echo " ** FixMakes=.sh out-of-date **";exit 1
# FixMakes=.sh - Fix === comment lines in makefile to start with '#'.
# 5/7/23.	wmk.
#
# Usage. bash  FixMakes=.sh <path> <terrid>
#
#	<path> = SCPA-Downloads or RefUSA-Downloads
#	<terrid> = territory ID
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/6/23.	wmk.	original shell.
# 5/7/23.	wmk.	header corrections.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMakes= <path> <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  FixMakes= - initiated from Make"
  echo "  FixMakes= - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMakes= - initiated from Terminal"
  echo "  FixMakes= - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $P1/Terr$P2
ls Make* > $TEMP_PATH/Makefiles.txt
if [ $? -ne 0 ];then
 echo "FixMakes= Terr$P2 - no makefiles to process."
 exit 0
fi
file=$TEMP_PATH/Makefiles.txt
while read -e;do
 echo "  processing $REPLY..."
 sed -i 's?^=?#=?g' $REPLY
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  FixMakes= complete."
~/sysprocs/LOGMSG "  FixMakes= complete."
# end FixMakes=.sh
