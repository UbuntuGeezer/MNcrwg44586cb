#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
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
 echo " DoSed <terrid> - territory - must be specified - aborted."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ $USER == "ubuntu" ];then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
echo "s/yyy/$P1/g" > sedatives.txt
sed -f sedatives.txt MakeSCNewLetter.tmp > MakeSCNewLetter
echo "s?\$folderbase?$folderbase?g" >> sedatives.txt
sed -f sedatives.txt NewLetter.psq > NewLetter.sql
sed -f sedatives.txt MakeAddZips.tmp > MakeAddZips
sed -f sedatives.txt AddZips.psq > $pathbase/RawData/SCPA/SCPA-Downloads/Terr$P1/AddZips.sql
# end DoSed
