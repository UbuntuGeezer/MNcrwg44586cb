#!/bin/bash
# DoSedBuildSpecSC.sh - edit all SegDefs relevant files for BuildSpecSCFromSegDefs.
#	5/21/23.
#
# Usage. bash  DoSedBuildSpecSC.sh  <spec-db>
#
#	<spec-db> = Special .db name to build
#
# Entry. MakeBuildSpecSCFromSegDefs.tmp = makefile template
#		
#
# Exit.	 
#		 MakeBuildSpecSCFromSegDefs.tmp > MakeBuildSpecSCFromSegDefs
#		 BuildSpecSCFromSegDefs.psq  -> BuildSpecSCFromSegDefs.sql
#		 (XSMawk.s - > XSMawk.sh)
#
# Modification History.
# ---------------------
# 3/22/23.	wmk.	original shell; adapted from DoSedSegDefs.
# 5/21/23.	wmk.	*sed corrected to only use *P1; docunentation corrected.
# Legacy mods.
# 2/25/23.	wmk.	rewrite for SegDefsMgr; 'SCPA' and <mm> <dd> support.
# 3/5/23.	wmk.	documentation clarified.
# Legacy mods.
# 2/11/23.	wmk.	original code.
# 2/12/23.	wmk.	<spec-db> parameter added; AddSegDefs.psq added to edits.
# 2/15/23.	wmk.	name change from DoSedLoadSegDefs to DoSedSegDefs;
#			 ClearSegDefs files added to edit list.
#
P1=$1
if [ -z "$P1" ];then
 echo "DoSedBuildSpecSC <spec-db> missing parameter(s) - abandoned."
 exit 1
fi
sed "s?vvvvv?$P1?g" BuildSpecSCFromSegDefs.psq > BuildSpecSCFromSegDefs.sql
#
sed "s?vvvvv?$P1?g" MakeBuildSpecSCFromSegDefs.tmp > MakeBuildSpecSCFromSegDefs
echo "DoSedBuildSpecSC  $P1 complete."
