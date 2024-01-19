#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - perform pre-make sed operations for MakeSpecialSCdb.
# 	6/5/22.	wmk.
#
#	Usage.	DoSed.sh <special-db>  <mm>  <dd> [<terrid>]
#	
#		<special-db> = special db base name (e.g. Esplanade811_333)
#		<mm> = month of download csv data extracted from (year 2021)
#		<dd> = day of download csv data extracted from 
#		[<terrid>] = (optional) preset territory ID for build process
#
#	Entry.
#		MakeSpecialDBsc.tmp is template makefile for Build (yyy is territory)
#		FixSCMenu.i is the template include file with the FixyyySC.sh recipe
#		($)HOME environment var contains the 'home' path for the system
#
#	Exit.
#		MakeSpecialDBsc generated as makefile for Build/Make
#		FixscMenu.inc is generated as recipe include file for MakeUpdateRUDwnld
#		pathSCdefs.inc generated as include file for MakeUpdateRUDwnld
#
# Modification History.
# ---------------------
# 5/18/22.	wmk.	*pathbase* support; parameter checks improved.
# 5/30/22.	wmk.	superfluous "s removed; FL/SARA/86777.
# 6/5/22.	wmk.	superfluous P4 removed.
# Legacy mods.
# 7/2/21.	wmk.	original shell; adpated from DoSed for SpecialDB.
# 7/24/21.	wmk.	name changes for new project name SpecialSCdb.
# 7/25/21.	wmk.	optional preset terrid added to parameters.
# 8/12/21.	wmk.	documentation updated.
#
# Notes. DoSed uses 'sed' to generate the include files for the build,
# and to mask the territory id into the makefile for the build. It defines
# and uses a local environment var ($)terrbase for multihost support
# of the build operation.
#
# If a <terrid> is passed in, that territory ID will be preset in all 
# records in the table named <source-file>.
#
P1=$1	# special db
P2=$2	# month
P3=$3	# day
P4=$4	# [terrid]
MM=$P2
DD=$P3
TID=$P4
if [ -z "$P1" ] ||  [ -z "$P2" ] || [ -z "$P3" ];then
  echo "  DoSed - <special-db> <mm> <dd> [<terrid>] missing parameter(s) - abandoned."
  exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export terrbase=/media/ubuntu/Windows/Users/Bill
  export  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export  terrbase=$HOME
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
echo "s/yyy/$P4/g" > sedatives.txt
echo "s/vvvvv/$P1/g" >> sedatives.txt
echo "{s?@@?$P2?g;s?zz?$P3?g}" >> sedatives.txt
sed -f sedatives.txt MakeSpecialSCdb.tmp > MakeSpecialSCdb
#sed -f sedatives.txt FixSCMenu.i > FixSCMenu.inc
#echo "s/yyy/$P1/g" > sedative.txt
#sed -f sedative.txt $terrbase/Territories/include/pathSCdefs.i > pathSCdefs.inc
echo "sed complete."
# end DoSed {SpecialSCdb}
