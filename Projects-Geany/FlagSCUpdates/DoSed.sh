#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeFlagSCUpdates.
#	4/2/23.	wmk.
#	Usage.	bash DoSed.sh <terrid> mm dd
#		<terrid> = territory ID
#		mm = month of Diff .db to check
#		dd = day of Diff .db to check
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 4/2/23.	wmk.	bug fix 'echo' within read. comments tidied.
# Legacy mods.
# 3/30/21.	wmk.	original code.
# 7/1/22.	wmk.	month/day editing made consistent using @ @  z z.
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " DoSed - territory mm dd - must be specified - aborted."
 read -p  "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
echo "{s/yyy/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
sed -f sedative.txt MakeFlagSCUpdates.tmp > MakeFlagSCUpdates
echo "{s/xxx/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
sed -f sedative.txt FlagSCUpdate.psq  >  FlagSCUpdate.sql
echo "DoSed complete."
# end DoSed
