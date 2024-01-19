#!/bin/bash
echo " ** FixMakePaths.sh out-of-date **";exit 1
echo " ** FixMakePaths.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixMakePaths.sh - Fix *make* paths in makefile.
# 9/22/22.	wmk.
#
# Usage. bash  FixMakePaths <makefile>
#
#	<makefile> = makefile to correct paths in
#				 (e.g. MakeRebuildFixSC.tmp)
#
# Exit.	*codebase environment var defined.
#		*projpath modified to use *codebase
#		*altproj modified to use *codebase
#
# Modification History.
# ---------------------
# 9/22/22.	wmk.	original code; adapted from FixMakeSpecials.
# Legacy mods.
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1	# makefile
if [ -z "$P1" ];then
 echo "FixMakePaths  <makefile> <missing parameter(s) - abandoned."
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixMakePaths - initiated from Make"
  echo "  FixMakePaths $P1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMakePaths - initiated from Terminal"
  echo "  FixMakePaths $P1 - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$codebase/Projects-Geany/MigrationRepairs
grep -e "automated) CB \*codebase env var" $P1
if [ $? -eq 0 ];then
 echo "$P1 already fixed - skipped."
 exit 0
fi
mawk -f $projpath/awkfixpathbase.txt $P1 > $TEMP_PATH/$P1
mawk -f $projpath/awkaddcodebase.txt $TEMP_PATH/$P1 > $P1
#cp -pv $TEMP_PATH/$P1 $P1
#endprocbody
echo "  FixMakePaths $P1 complete."
~/sysprocs/LOGMSG "  FixMakePaths complete."
# end FixMakePaths
