#!/bin/bash
# MovPDFs.sh - Move territory .pdf files from ~/Downloads to /Territories.../Territory-PDFs folder.
# 6/14/23.	wmk.
#
# Usage. bash  MovPDFs.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/6/23.	wmk.	original shell.
# 6/14/23.	wmk.	use *DWNLD_PATH environment var.
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
  ~/sysprocs/LOGMSG "  MovPDFs - initiated from Make"
  echo "  MovPDFs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  MovPDFs - initiated from Terminal"
  echo "  MovPDFs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
cp -pv $DWNLD_PATH/*.pdf $pathbase/Territory-PDFs
#endprocbody
echo "  MovPDFs complete."
~/sysprocs/LOGMSG "  MovPDFs complete."
# end MovPDFs.sh
