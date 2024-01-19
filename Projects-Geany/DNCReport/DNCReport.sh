#!/bin/bash
echo " ** DNCReport.sh out-of-date **";exit 1
echo " ** DNCReport.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DNCReport.sh - Produce DNCReport in Tracking folder.
#	11/1/21.	wmk.
#	Usage.	bash DNCReport.sh
if [ -z "$USER" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
~/sysprocs/LOGMSG "  DNCReport initiated."
echo "DNCReport initiated."
cd $codebase/Projects-Geany/DNCReport
sqlite3 < DNCSummary.sql
~/sysprocs/LOGMSG "  DNCReport complete."
echo "DNCReport complete - see Tracking/DNCSummary.csv."
