#!/bin/bash
#DoSed.sh - perform sed modifications of MakeUpdateMHPDwnld.
#	7/3/23.	wmk.
#
#	Usage. bash		DoSed.sh <db-name>  <terrid>
#		<dbname> = special db name (e.g. BayIndies)
#		<terrid> = territory ID
#
#	Exit.	($)incroot/PathSCdefs.i edited to PathSCdefs.inc
#			MakeUpdateMHPDwnld.tmp edited to MakeUpdateMHPDwnld
#			ExtractOldDiffs.psq edited to ExtractOldDiffs.sql
#			MakeExtractOldDiffs.tmp edited to MakeExtractOldDiffs
#			IntegrateOldDiffs.psq edited to IntegrateOldDiffs.sql
#			MakeIntegrateOldDiffs.tmp edited to MakeIntegrateOldDiffs
#
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection; comments tidied.
# 7/3/23.	wmk.	parameter error message clarified.
# Legacy mods.
# 6/7/22.	wmk.	*pathbase* support.
# 6/8/22.	wmk.	bug fix; add s?xxx?*P2* to fix .psq terr#s.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 7/4/21.	wmk.	original shell; adapted from UpdateSCBridge/DoSed.
# 7/6/21.	wmk.	title line corrected; P4 added for setting terrid
#					in RUGenMHPMap.sq; exit conditions updated.
# 9/8/21.	wmk.	major rewrite; pathRUdefs references placed inline
#					in makefile; simplified to only edit makefile.
# 9/9/21.	wmk.	ExtractOldDiffs.psq, IntegrateOldDiffs.psq included
#					in edit; touch AlwaysMake to force make of dynamic
#					targets; touch .psq files to force make of .sql files.
# 9/23/21.	wmk.	rm,s made conditional.
#
# P1 is special db name, P2 is <terrid>
P1=$1		# dbname
P2=$2		# terrid
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   export terrbase=/media/ubuntu/Windows/Users/Bill
   export folderbase=/media/ubuntu/Windows/Users/Bill
 else
   export terrbase=$HOME
   export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " (UpdateMHPDwnld)DoSed - <dbname>  <terrID>- must be specified - aborted."
 exit 1
fi
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - UpdateMHPDwnld/DoSed exiting.."
 exit 2
fi
TN=Terr
touch AlwaysMake
if test -f ExtractOldDiffs.sh;then rm ExtractOldDiffs.sh;fi
if test -f IntegrateOldDiffs.sh;then rm IntegrateOldDiffs.sh;fi
if test -f ExtractOldDiffs.sql;then rm ExtractOldDiffs.sql;fi
if test -f IntegrateOldDiffs.sql;then rm IntegrateOldDiffs.sql;fi
echo "s?yyy?$P2?g;s?xxx?$P2?g" > sedative.txt
sed -f sedative.txt ExtractOldDiffs.psq > ExtractOldDiffs.sql
sed -f sedative.txt MakeExtractOldDiffs.tmp > MakeExtractOldDiffs
sed -f sedative.txt IntegrateOldDiffs.psq > IntegrateOldDiffs.sql
sed -f sedative.txt MakeIntegrateOldDiffs.tmp > MakeIntegrateOldDiffs
echo "s/vvvv/$P1/g" >> sedative.txt
sed -f sedative.txt MakeUpdateMHPDwnld.tmp > MakeUpdateMHPDwnld
echo "  DoSed complete."
