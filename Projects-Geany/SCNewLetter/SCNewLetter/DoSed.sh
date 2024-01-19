#!/bin/bash
#DoSed.sh - perform sed modifications of MakeSCNewLetter.
#	9/21/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
#		<terrid> = territory ID
#
#	Exit. MakeSCNewLetter.tmp --> MakeSCNewLetter
#		  NewLetter.psq > NewLetter.sql
#
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
sed -f sedatives.txt MakeSCNewLetter.tmp > MakeSCNewLetter
echo "s?\$folderbase?$folderbase?g" >> sedatives.txt
sed -f sedatives.txt NewLetter.psq > NewLetter.sql
# end DoSed
