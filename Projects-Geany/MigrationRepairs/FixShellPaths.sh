#!/bin/bash
echo " ** FixShellPaths.sh out-of-date **";exit 1
echo " ** FixShellPaths.sh out-of-date **";exit 1
# FixShellPaths.sh - Fix *make* paths in makefile.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# 9/23/22.	wmk.
#
# Usage. bash  FixShellPaths <shellfile>
#
#	<shellfile> = shell to correct paths in
#				 (e.g. ExtractBody.sh)
#
# Entry. user *PWD is folder containing <shellfile>
#
# Exit.	*codebase environment var defined.
#		*pathbase modified to *folderbase/Territories/FL/SARA/868777
#
# Modification History.
# ---------------------
# 9/22/22.	wmk.	original code; adapted from FixMakePaths.
# 9/23/22.	wmk.	minor corrections.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.	wmk.	bug fix where if [ -z "$pathbase" ] conditional being deleted
#			 in target shell.
# Legacy mods.
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1	# shellfile
if [ -z "$P1" ];then
 echo "FixShellPaths  <shellfile> <missing parameter(s) - abandoned."
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixShellPaths - initiated from Make"
  echo "  FixShellPaths $P1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixShellPaths - initiated from Terminal"
  echo "  FixShellPaths $P1 - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$codebase/Projects-Geany/MigrationRepairs
grep -e "automated) CB \*codebase env var" $P1
if [ $? -eq 0 ];then
 echo "$P1 already fixed - skipped."
 exit 0
fi
mawk -f $projpath/awkfixbashpaths.txt $P1 > $TEMP_PATH/$P1
if test -f $TEMP_PATH/$P1;then
 cp -pv $TEMP_PATH/$P1 $P1
 chmod +x $P1
fi
#endprocbody
echo "  FixShellPaths $P1 complete."
~/sysprocs/LOGMSG "  FixShellPaths $P1 complete."
# end FixShellPaths
