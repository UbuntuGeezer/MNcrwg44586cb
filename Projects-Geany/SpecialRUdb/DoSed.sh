#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# DoSed.sh - perform pre-make sed operations for MakeSpecialRUdb.
# 	6/29/23.	wmk.
#
#	Usage.	DoSed.sh <terrid>|" " <source-file>
#	
#		<terrid> = territory ID for build process
#		<source-file> = source file sql (e.g. Esplande811_333)
#
#	Entry.
#		MakeSpecialDB.tmp is template makefile for Build (yyy is territory)
#		FixRUMenu.i is the template include file with the FixyyyRU.sh recipe
#		($)HOME environment var contains the 'home' path for the system
#
#	Exit.
#		MakeSpecialDB generated as makefile for Build/Make
#		SetNewBridgeTerrs.sq generated from SetNewBridgeTerrs.s
#		FixRUMenu.inc is generated as recipe include file for MakeUpdateRUDwnld
#		pathRUdefs.inc generated as include file for MakeUpdateRUDwnld
#
# Modification History.
# ---------------------
# 5/24/23.	wmk.	bug fix in P2 error message.
# 6/29/23.	wmk.	bug fixes when " " is <terrid>.
# Legacy mods.
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# 12/5/22.	wmk.	pathrudefs.i path corrected for *codebase; comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 5/31/22.	wmk.	specpathdefs.i > specpathdefs.inc added.
# Legacy mods.
# 7/18/21.	wmk.	original shell; adpated from DoSed for SpecialDB.
# 8/17/21.	wmk.	code checked for forward compatibility with newest
#					makefiles.
#
# Notes. DoSed uses 'sed' to generate the include files for the build,
# and to mask the territory id into the makefile for the build. It defines
# and uses a local environment var ($)terrbase for multihost support
# of the build operation.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSed <terrid> | <special-db> missing parameter(s) - abandoned"
 exit 1
fi
if [ "$P1" == " " ];then
 TID=
else
 TID=$P1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
   terrbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
   terrbase=$HOME
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
if [ ! -z "$TID" ];then
 if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
  echo " ** Territory $P1 OBSOLETE - SpecialRUdb/DoSed exiting... **"
  exit 2
 fi
fi
echo "s?vvvvv?$P2?g" > sedatives.txt
sed -f sedatives.txt MakeSpecialRUdb.tmp > MakeSpecialRUdb
echo 's?%folderbase?$pathbase?g' >> sedatives.txt
echo "s/yyy/$TID/g" >> sedatives.txt
sed -f sedatives.txt SetNewBridgeTerrs.s > SetNewBridgeTerrs.sq
echo "s/xxx/$TID/g" > sedative.txt
sed -f sedative.txt $codebase/include/pathRUdefs.i > pathRUdefs.inc
#
sed -f sedatives.txt specpathdefs.i > specpathdefs.inc
echo "sed complete."
# end DoSed {SpecialDB}
