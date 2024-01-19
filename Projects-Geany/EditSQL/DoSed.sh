#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - Run sed to fix MakeExtractBas.tmp > MakeExtractBas.
#	7/6/22.	wmk.
#
# Usage. bash DoSed.sh <sqlmodule> <sqlfile>
#
#	<sqlmodule> = name of .bas module to extract
#	<sqlfile> = filename(.sql) containing <sqlmodule>
#
# Exit.
#
# Modification History.
# ----------------------
# 7/6/22.	wmk.	original code; adapted from EditBas project.
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
   export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 echo "*pathbase* env var not set - DoSed abandoned."
 exit 1
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSed <sqlmodule> <sqlfile> missing parameter - abaondoned."
 exit 1
fi
#
projpath=$codebase/Projects-Geany/EditSQL
echo "s?<sqlmodule>?$P1?g" > $projpath/sedatives.txt
echo "s?<sqlfile>?$P2?g" >> $projpath/sedatives.txt
sed -f $projpath/sedatives.txt  $projpath/awkExtract.tx > $projpath/awkExtract.txt
sed -f $projpath/sedatives.txt  $projpath/awkSplit1.tx > $projpath/awkSplit1.txt
sed -f $projpath/sedatives.txt  $projpath/awkSplit2.tx > $projpath/awkSplit2.txt
sed  "s?<date>?$TODAY?g"        $projpath/sedAddDate.tx > sedAddDate.txt
sed -f $projpath/sedatives.txt  $projpath/MakeExtractSQL.tmp >  $projpath/MakeExtractSQL
sed -f $projpath/sedatives.txt  $projpath/MakeDeleteSQL.tmp >  $projpath/MakeDeleteSQL
sed -f $projpath/sedatives.txt  $projpath/MakeReplaceSQL.tmp >  $projpath/MakeReplaceSQL
echo "DoSed complete."
# end DoSed.sh
