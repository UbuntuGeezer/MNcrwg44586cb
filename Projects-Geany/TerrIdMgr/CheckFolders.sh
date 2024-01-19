#!/bin/bash
# CheckFolders.sh - <description>.
# 6/3/23.	wmk.
#
# Usage. bash  CheckFolders.sh <terrid>
#
#	<terrid> = territory ID to check folders for
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/3/23.	wmk.	original shell.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
if [ -z "$P1" ];then
 echo "CheckFolders <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  CheckFolders - initiated from Make"
  echo "  CheckFolders - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckFolders - initiated from Terminal"
  echo "  CheckFolders - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
	# first check RefUSA/Terr$P1.
	echo "checking RefUSA/Terr$P1..."
	if test -d $pathbase/$rupath/Terr$P1;then \
	 thisdir=$PWD; \
	 cd $pathbase/$rupath/Terr$P1; \
	 $codebase/Projects-Geany/TerrIdMgr/CountFiles.sh; \
	 numfiles=$?; \
	 echo " numfiles = $numfiles"; \
	 cd $thisdir; \
	else \
	 export numfiles=-1;fi
	#fi
	if [ $numfiles -gt 0 ];then
	 echo " CheckFolders - RefUSA-Downloads/Terr$P1 folder exists and is non-empty - exiting."
	 exit 1
	fi
	# next check SCPA/Terr$P1.
	echo "checking SCPA/Terr$P1..."
	if test -d $pathbase/$rupath/Terr$P1;then
	 thisdir=$PWD
	 cd $pathbase/$scpath/Terr$P1
	 $codebase/Projects-Geany/TerrIdMgr/CountFiles.sh
	 numfiles=$?
	 echo " numfiles = $numfiles"
	 cd $thisdir
	else
	 export numfiles=-1
	fi
	if [ $numfiles -gt 0 ];then
	 echo " CheckFolders - SCPA-Downloads/Terr$P1 folder exists and is non-empty - exiting."
	 exit 1
	fi
	# next check TerrData/Terr$P1.
	echo "checking TerrData/Terr$P1..."
	if test -d $pathbase/TerrData/Terr$P1;then
	 thisdir=$PWD
	 cd $pathbase/TerrData/Terr$P1
	 $codebase/Projects-Geany/TerrIdMgr/CountFiles.sh
	 numfiles=$?
	 echo " numfiles = $numfiles"
	 cd $thisdir
	else
	 export numfiles=-1
	fi
	if [ $numfiles -gt 0 ];then
	 echo " CheckFolders - TerrData/Terr$P1 folder exists and is non-empty - exiting."
	 exit 1
	fi
#endprocbody
echo "  CheckFolders complete."
~/sysprocs/LOGMSG "  CheckFolders complete."
# end CheckFolders.sh
