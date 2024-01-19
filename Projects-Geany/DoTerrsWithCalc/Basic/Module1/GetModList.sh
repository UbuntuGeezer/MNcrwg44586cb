#!/bin/bash
# GetModList.sh - Get MNcrwg44586.bas module list from Module1.bas.
# 8/21/23.	wmk.
#
# Usage. bash  GetModList.sh
#
# Entry. Module1.bas = OpenOffice .bas macros source code.
#
# Modification History.
# ---------------------
# 8/21/23.	wmk.	original shell.
# 8/23/23.	wmk.	ver2.0 documentation added.
#
# Notes. This is ver2.0 support with separate ProcessQTerrs12.ods files for each
# congregation library. This isolates the publisher territory building to avoid
# confusion. 
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
export pathbase=$folderbase/Territories/MN/CRWG/44586
export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  GetModList - initiated from Make"
  echo "  GetModList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetModList - initiated from Terminal"
  echo "  GetModList - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
#if [ -z "$TODAY" ];then
# . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
#fi
#procbodyhere
pushd ./ > /dev/null
cd $codebase/Projects-Geany/DoTerrsWithCalc/Basic/Module1
grep -e "\.bas" Module1.bas > ModList.txt
if [ $? -eq 0 ];then
 sed "s?^'// ??g;s?.bas??g" ModList.txt > $TEMP_PATH/ModList.txt
 cp -pv $TEMP_PATH/ModList.txt ModList.txt
 echo "List of .bas modules on ModList.txt."
fi
popd > /dev/null
#endprocbody
echo "  GetModList complete."
~/sysprocs/LOGMSG "  GetModList complete."
# end GetModList.sh
