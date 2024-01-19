#!/bin/bash
echo " ** sed.sh out-of-date **";exit 1
echo " ** sed.sh out-of-date **";exit 1
# sed.sh - perform pre-make sed operations.
# 	6/6/23.	wmk.
#
#	usage.	sed.sh <terrid>
#	
#		<terrid> = territory ID building
#
# Modification History.
# ---------------------
# 3/29/21.	wmk.	original code.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 6/6/23.	wmk.	terminated unconditionally as error.
#
echo "UpdateRUDwnld/sed called by mistake."
exit 1
P1=$1
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt MakeUpdateRUDwnld.tmp > MakeUpdateRUDwnld
sed -f sedative.txt FixRUMenu.i > FixRUMenu.inc
echo "s/xxx/$P1/g" > sedative.txt
sed -f sedative.txt /media/ubuntu/Windows/Users/Bill/Territories/include/pathRUdefs.i > pathRUdefs.inc
echo "sed complete."
