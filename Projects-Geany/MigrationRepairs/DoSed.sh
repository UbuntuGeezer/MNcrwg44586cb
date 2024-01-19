#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MigrationRepairs makefiles..
#	5/28/22..	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
#
# Modification History.
# ---------------------
# 5/28/22.	wmk.	original code.
# 5/11/23.	wmk.	PatchSpecTerrDBs.psq, MakePatchSpecTerrDBs added to edit list.
#
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - <terrid> missing <terrid> - aborted."
 exit 1
fi
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt MakeRebuildFixSC.tmp > MakeRebuildFixSC
sed -f sedative.txt MakeRebuildFixRU.tmp > MakeRebuildFixRU
#
echo "s/xxx/$P1/g" > sedative.txt
sed -f sedative.txt  PatchSpecTerrDBs.psq > PatchSpecTerrDBs.sql
sed -f sedative.txt MakePatchSpecTerrDBs.tmp > MakePatchSpecTerrDBs
echo "DoSed $P1 complete."
# end DoSed
