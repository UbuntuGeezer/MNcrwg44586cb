#!/bin/bash
# ckallnew.sh - check all Territory system folders for files newer than dump.
#	7/12/22.	wmk.
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	original shell.
# 6/27/22.	wmk.	procsbld added to list.
# 7/9/22.	wmk.	donotcalls added to list.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
fi
TEMP_PATH=$HOME/temp
echo "  ckallnew initiated."
shellpath=$pathbase/Procs-Dev
$shellpath/cknewfiles.sh procs
$shellpath/cknewfiles.sh procsbld
$shellpath/cknewfiles.sh scraw
$shellpath/cknewfiles.sh ruraw
$shellpath/cknewfiles.sh geany
$shellpath/cknewfiles.sh basic
$shellpath/cknewfiles.sh donotcalls
$shellpath/cknewfiles.sh include
$shellpath/cknewfiles.sh maindbs
$shellpath/cknewfiles.sh release
$shellpath/cknewfiles.sh terrdata
$shellpath/cknewfiles.sh bruraw
$shellpath/cknewfiles.sh bscraw
$shellpath/cknewfiles.sh bterrdata
echo "  ckallnew complete."
# end ckallnew
