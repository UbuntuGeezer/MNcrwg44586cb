#!/bin/bash
#DoSed.sh - perform sed modifications of MakeFlagRUUpdates.
#	2/5/23.	wmk.
#	Usage.	bash DoSed.sh <tid1> <tid2>
#		<tid1> = (optional) starting territory ID for processing
#		<tid2> = (optional, mandaory if <tid1> present) ending territory id
#
# Modification History.
# ---------------------
# 2/4/23.	wmk.	original code; adapted from FlagSCUpdates project.
# Legacy mods.
# 3/30/21.	wmk.	original code.
# 7/1/22.	wmk.	month/day editing made consistent using @ @  z z.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#
P1=$1		# TID1
P2=$2		# TID2
if [ ! -z "$P1" ];then
 if [ -z "$P2" ];then
  echo " DoSed  [<tid1> <tid2>] missing <tid2> - abandoned."
  exit 1
 fi
fi
echo "{s/<TID1>/$P1/g;s/<TID2>/$P2/g}" > sedative.txt
sed -f sedative.txt MakeFlagRUUpdates.tmp > MakeFlagRUUpdates
#echo "{s/xxx/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
#sed -f sedative.txt FlagRUUpdate.psq  >  FlagRUUpdate.sql
echo "DoSed complete."
# end DoSed
