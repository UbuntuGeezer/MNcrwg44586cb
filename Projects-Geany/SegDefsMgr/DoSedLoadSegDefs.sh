#!/bin/bash
# DoSedLoadSegDefs.sh - edit MakeLoadSegDefs.tmp, LoadSegDefs.psq.
#
# Usage. bash  DoSedLoadSegDefs.sh <terrid>
#
# Entry. RU-Downloads/Special/MakeLoadSegDefs.tmp = makefile template
#					 /Special/LoadSegDefs.psq = SQL template
#
# Exit.	 MakeLoadSegDefs.tmp -> MakeLoadSegDefs
#		 MakeAddSegDefs.tmp > MakeAddSegDefs
#		 LoadSegDefs.psq   -> LoadSegDefs.sql
#		 AddSegDefs.psa  -> AddSegDefs.sql
# Modification History.
# ---------------------
# 2/11/23.	wmk.	original code.
# 2/12/23.	wmk.	<spec-db> parameter added; AddSegDefs.psq added to edits.
# Notes. DoSedListTerr Streets preps the files for *make* -f MakeLoadSegDefs.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedLoadSegDefs <terrid> <spec-db> missing parameter(s) - abandoned."
 exit 1
fi
sed "s?yyy?$P1?g" LoadSegDefs.psq > LoadSegDefs.sql
sed "s?yyy?$P1?g;s?<spec-db>?$P2?g" AddSegDefs.psq > AddSegDefs.sql
sed "s?yyy?$P1?g" Jumpto.psq > Jumpto.sql
#
sed "s?yyy?$P1?g" MakeLoadSegDefs.tmp > MakeLoadSegDefs
sed "s?yyy?$P1?g" MakeAddSegDefs.tmp > MakeAddSegDefs
echo "DoSedLoadSegDefs  $P1 complete."
