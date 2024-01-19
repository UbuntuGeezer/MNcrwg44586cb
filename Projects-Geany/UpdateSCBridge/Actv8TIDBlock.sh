#!/bin/bash
echo " ** Actv8TIDBlock.sh out-of-date **";exit 1
# Actv8TIDBlock - uncomment block of territory IDs in TIDList.txt.
#	11/25/22.	wmk.
#
# Usage. bash  Actv8TIDBlock.sh <1st-digit> | <digit-range>
#
#	<1st-digit> = first digit of territories to reactivate in TIDList.txt
#	<digit-range> = range of first digits to deactivate (e.g. 123456)
#
# Entry. UpdateSCBridge/TIDList.txt = current TID list for processing. 
#
# Exit.	UpdateSCBridge.TIDList.txt = modified TID list with block deactivated
#		 '#' removed from all lines beginning with <1st-digit>
#
#		UpdateSCBridge.TIDList.bak = TIDList.txt from KillTIDBlock.
#
# Modification History.
# ---------------------
# 11/25/22.	wmk.	original shell.
# 5/11/23.	wmk.	change to use *TEMP_PATH; target is TIDList.txt.
#
# Notes. 
#
P1=$1
if [ -z "$P1" ];then
 echo " Actv8TIDBlock <1st-digit> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
sed "s?<dig>?$P1?g" awkactv8TIDs.tmp > awkactv8TIDs.txt
mawk -f awkactv8TIDs.txt TIDList.txt > $TEMP_PATH/TIDList.tmp
cp -pv $TEMP_PATH/TIDList.tmp TIDList.txt
echo "Actv8TIDBlock complete."
echo " TIDList.txt has '$P1' block restored."
# end Actv8TIDBlock.
