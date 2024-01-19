#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MakeRUNewLetter.
#	9/20/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
if [ $USER == "ubuntu" ];then
  folderbase=/media/ubuntu/Windows/Users/Bill
else
  folderbase=$HOME
fi
echo "s/yyy/$P1/g" > sedatives.txt
sed -f sedatives.txt MakeRUNewLetter.tmp > MakeRUNewLetter
./InitLetter.sh $P1
# end DoSed
