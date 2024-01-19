#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# DoSed.sh - perform pre-make sed operations.
# 	6/5/23.	wmk.
#
#	Usage.	DoSed.sh <terrid>
#	
#		<terrid> = territory ID for build process
#			MUST be a letter/phone territory (601-647)
#			DoSed will flag an error and prompt the user to use either
#			 the UpdateMHPDwnld or UpdateRUDwnld project, as appropriate.
#
#	Entry.
#		MakeUpdateRUDwnld.tmp - makefile for Build (yyy is territory)
#		FixRUMenu.i - template include file with the FixyyyRU.sh recipe
#		./include/pathRUdefs.i - include file of RU paths for make reference
#		ExtractOldDiffs.sq - query (template) extract old Bridge records not in new
#		($)HOME environment var contains the 'home' path for the system
#
#	Exit.
#		MakeUpdateRUDwnld generated as makefile for Build/Make
#		FixRUMenu.inc is generated as recipe include file for MakeUpdateRUDwnld
#		pathRUdefs.inc - pathRUdefs includ file for MakeUpdateRUDwnld
#		ExtractOldDiffs.sql - query to extract old Bridge records not in new
#		pathRUdefs.inc generated as include file for MakeUpdateRUDwnld
#
# Modification History.
# ---------------------
# 2/5/23.	wmk.	original code; adapted from UpdateRUDwnld project.
# 6/6/23.	wmk.	OBSOLETE territory detection added.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/3/22.	wmk.	include removed from edit list.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use FL/SARA/86777.
# 7/9/22.	wmk.	ClearRUBridge.psq, MakeClearRUBRidge added to *sed edit list.
# Legacy mods.
# 3/30/21.	wmk.	original shell.
# 5/27/21.	wmk.	modified to use env var HOME to determine Territories path.
# 6/2/21.	wmk.	documentation rigorously updated.
# 6/6/21.	wmk.	folderbase env var set.
# 7/6/21.	wmk.	added ExtractOldDiffs.sq, IntegrateOldDiffs to edited files.
# 8/29/21.	wmk.	filename changes from ExtractOldDiffs, IntegrateOldDiffs.sq
#					to .psq suffix to be consistent with new AnySQLtoSQ.sh proc
# 9/8/21.	wmk.	modified to edit makefile templates for MakeExtractOldDiffs
#					and MakeIntegrateOldDiffs instead of editing the .psq files.
# 12/21/21.	wmk.	correct filebase	 var for chromeos.
#
# Notes. DoSed uses 'sed' to generate the include files for the build,
# and to mask the territory id into the makefile for the build. It defines
# and uses a local environment var ($)terrbase for multihost support
# of the build operation.
#
P1=$1
if [ -z "$P1" ];then
 echo "DoSed <terrid> missing parameter - abandoned."
 exit 1
fi
# reject OBSOLETE territory.
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - UpdateLtrDwnld/DoSed exiting. **"
 exit 2
fi
# reject MHP territories, since they have special update rules.
if [[ ( $P1 -ge 235  &&  $P1 -le 251 )  \
 || ( $P1 -ge 268  &&  $P1 -le 269 ) \
 || ( $P1 -ge 261  &&  $P1 -le 264 ) \
 || ( $P1 -ge 317  &&  $P1 -le 321 ) ]];then
 echo " ** $P1 is a MHP territory - use the UpdateMHPDwnld project **"
 exit 1
fi
# reject non-Letter territories, since they have special update rules.
if ! [[ ( $P1 -ge 601  &&  $P1 -le 647 ) ]];then
 echo " ** $P1 is a not a Letter territory - use the UpdateRUDwnld project **"
 exit 1
fi
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
projpath=$codebase/Projects-Geany/UpdateRUDwnld
# 
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt MakeUpdateLtrDwnld.tmp > MakeUpdateLtrDwnld
#sed -f sedative.txt ClearRUBridge.psq > ClearRUBridge.sql
#sed -f sedative.txt MakeClearRUBridge.tmp > MakeClearRUBridge
#sed -f sedative.txt FixRUMenu.i > FixRUMenu.inc
echo "s/xxx/$P1/g" > sedative.txt
#sed -f sedative.txt $pathbase/include/pathRUdefs.i > $projpath/pathRUdefs.inc
#echo "s?yyy?$P1?g" > sedative.txt
#sed -f sedative.txt MakeExtractOldDiffs.tmp > MakeExtractOldDiffs
#sed -f sedative.txt MakeIntegrateOldDiffs.tmp > MakeIntegrateOldDiffs
#sed -f sedative.txt TestForMHPTable.psq > TestForMHPTable.sql
echo "DoSed [UpdateLtrDwnld] $P1 complete."
