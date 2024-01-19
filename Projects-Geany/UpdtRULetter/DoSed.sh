#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeUpdtRULetter.
#	6/6/23.	wmk.
#
#	Usage.	bash DoSed.sh <terrid> mm dd
#		<terrid> = territory ID
#
#	Exit.	MakeUpdtRULetter.tmp edited to MakeUpdtRULetter
#			ClearRUBridge.psq to ClearRUBridge.sql
#
#
# Modification History.
# ---------------------
# 10/20/21.	wmk.	original shell; adapted from MakeUpdateSCBridge.
# 6/6/23.	wmk.	*folderbase updated; OBSOLETE territory detection.
P1=$1
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   export terrbase=/media/ubuntu/Windows/Users/Bill
   export folderbase=/media/ubuntu/Windows/Users/Bill
 else
   export terrbase=$HOME
   export folderbase=$HOME
 fi
fi
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
if test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - UpdtRUletter/DoSed exiting...**"
 exit 2
fi
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt MakeUpdtRULetter.tmp > MakeUpdtRULetter
sed -f sedative.txt ClearRUBridge.psq > ClearRUBridge.sql
# end DoSed {MakeUpdtRULetter}
