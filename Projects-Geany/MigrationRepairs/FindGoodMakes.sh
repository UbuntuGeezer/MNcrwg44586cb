#!/bin/bash
echo " ** FindGoodMakes.sh out-of-date **";exit 1
echo " ** FindGoodMakes.sh out-of-date **";exit 1
# FindBacMakes.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  FindBacMakes.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
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
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FindGoodMakes - initiated from Make"
  echo "  UpdatePubTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FindGoodMakes - initiated from Terminal"
  echo "  UpdatePubTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath
echo "  Scanning $scpath..."
grep -rle "(MAKE).*AnySQLtoSH" --include "Make*"
cd $pathbase/$rupath
echo "  Scanning $rupath.."
grep -rle "(MAKE).*AnySQLtoSH" --include "Make*"
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  FindGoodMakes complete."
~/sysprocs/LOGMSG "  FindGoodMakes complete."
# end FindBacMakes.sh
