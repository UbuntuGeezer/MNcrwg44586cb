#!/bin/bash
echo " ** DoFixSed.sh out-of-date **";exit 1
echo " ** DoFixSed.sh out-of-date **";exit 1
# DoFixSed.sh - perform sed operations for MakeFixDownload.
# 	6/5/23.	wmk.
#
#	Usage.	DoFixSed.sh <source-file>
#	
#		<source-file> = source file sql key name (e.g. Fix.AvenidaEstancias.sql)
#
#	Entry.
#		MakeFixDownload.tmp is template makefile for Build (yyy is territory)
#		($)HOME environment var contains the 'home' path for the system
#
#	Exit.
#		MakeFixDownload generated as makefile for Build/Make
#		 <source-file> will be substituted for v vvvv throughout the makefile
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	OBSOLETE territory detection added.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 9/1/21.	wmk.	original shell; adpated from DoSed for SpecialRUDB.
#			 makefiles.
# 12/28/21.	wmk.	change to use $ USER env var.
#
# Notes. DoFixSed uses 'sed' to 
# and to mask the territory id into the makefile for the build. It defines
# and uses a local environment var ($)terrbase for multihost support
# of the build operation.
#
P1=$1
if [ -z "$folderbase" ];then
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
echo "s/vvvvv/$P1/g" > sedatives.txt
sed -f sedatives.txt MakeFixDownload.tmp > MakeFixDownload
echo "DoFixSed complete."
# end DoFixSed {SpecialRUDB}
