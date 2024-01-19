#!/bin/bash
# DoSedSegDefs.sh - edit all SegDefs relevant files for Load, Add, Clear SegDefs.
#	6/5/23.
#
# Usage. bash  DoSedSegDefs.sh <terrid> <spec-db>|SCPA <mm> <dd>
#
#	<terrid> = territory ID for segments
#	<spec-db> = <spec-db> name for Add operations (no .db extension)
#						or SCPA
#	<mm> = (optional, mandatory if <spec-db> begins with SCPA) month suffix for SCPA
#	<dd> = (optional, mandatory if <mm> present
#
# Entry. RU-Downloads/Special/MakeLoadSegDefs.tmp = makefile template
#					 /Special/LoadSegDefs.psq = SQL template
#
# Exit.	 MakeLoadSegDefs.tmp -> MakeLoadSegDefs
#		 MakeAddSegDefs.tmp > MakeAddSegDefs
#		 MakeClearSegsDefs.tmp > MakeClearSegDefs
#		 MakeListTerrSegs.tmp > MakeListTerrSegs
#		 MakeBuildSCFromSegDefs.tmp > MakeBuildSCFromSegDefs
#		 LoadSegDefs.psq   -> LoadSegDefs.sql
#		 AddSegDefs.psq  -> AddSegDefs.sql
#		 ClearSegDefs.psq   -> ClearSegDefs.sql
#		 ListTerrSegs.psq  - > ListTerrSegs.sql
#		 BuildSCFromSegDefs.psq  -> BuildSCFromSegDefs.sql
#		 XMawk.s - > XMawk.sh
#
# Modification History.
# ---------------------
# 2/25/23.	wmk.	rewrite for SegDefsMgr; 'SCPA' and <mm> <dd> support.
# 3/5/23.	wmk.	documentation clarified.
# 6/5/23.	wmk.	OBSOLETE territory warning added.
# Legacy mods.
# 2/11/23.	wmk.	original code.
# 2/12/23.	wmk.	<spec-db> parameter added; AddSegDefs.psq added to edits.
# 2/15/23.	wmk.	name change from DoSedLoadSegDefs to DoSedSegDefs;
#			 ClearSegDefs files added to edit list.
#
# Notes. DoSedSegDefs preps the files for
#	 *make* -f Make[LoadSeg|Add|Clear]SegDefs.
#
P1=$1
P2=$2
P3=$3
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedSegDefs <terrid> <spec-db>|SCPA <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
pars=${2:0:4}
db4chr=${pars^^}
if [ "$db4chr" == "SCPA" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "DoSedSegDefs <terrid> SCPA <mm> <dd> missing parameter(s) - abandoned."
  exit 1
 fi
fi
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - DoSedSegDefs exiting... **"
 exit 2
fi
sed "s?yyy?$P1?g" LoadSegDefs.psq > LoadSegDefs.sql
sed "s?yyy?$P1?g;s?<spec-db>?$P2?g" AddSegDefs.psq > AddSegDefs.sql
sed "s?yyy?$P1?g" BuildSCFromSegDefs.psq > BuildSCFromSegDefs.sql
sed "s?yyy?$P1?g" ClearSegDefs.psq > ClearSegDefs.sql
sed "s?yyy?$P1?g" ListTerrSegs.psq > ListTerrSegs.sql
sed "s?yyy?$P1?g" preambleClear.s > preambleClear.sh
sed "s?yyy?$P1?g" XMawk.s > XMawk.sh
sed "s?yyy?$P1?g" Jumpto.psq > Jumpto.sql
if [ "$db4chr" == "SCPA" ];then
 sed -i 's?<rawpath>?SCPA/SCPA-Downloads?g' Jumpto.sql
else
 sed -i 's?<rawpath>?RefUSA/RefUSA-Downloads?g' Jumpto.sql
fi
#
if [ "$db4chr" == "SCPA" ];then
 sed "s?<rawpath>?SCPA/SCPA-Downloads?g" MakeListTerrSegs.tmp > MakeListTerrSegs
else
 sed "s?<rawpath>?RefUSA/RefUSA-Downloads?g" MakeListTerrSegs.tmp > MakeListTerrSegs
fi
sed "s?yyy?$P1?g" MakeLoadSegDefs.tmp > MakeLoadSegDefs
sed "s?yyy?$P1?g" MakeListTerrSegs.tmp > MakeListTerrSegs
sed "s?yyy?$P1?g" MakeAddSegDefs.tmp > MakeAddSegDefs
sed "s?yyy?$P1?g;s?@@?$P3?g;s?zz?$P4?g" MakeBuildSCFromSegDefs.tmp > MakeBuildSCFromSegDefs
sed "s?yyy?$P1?g" MakeClearSegDefs.tmp > MakeClearSegDefs
echo "DoSedSegDefs  $P1 $P2 $P3 $P4 complete."
