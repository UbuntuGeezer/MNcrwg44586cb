#!/bin/bash
# ListSince.sh - List .tar files where date >= P1/P2.
#	5/26/22.	wmk.
#
# Modification History.
# ---------------------
# 5/26/22.	wmk.	original code.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "ListSince <monthname> <day> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
TEMP_PATH=$HOME/temp
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
projpath=$pathbase/Projects-Geany/ArchivingBackups
sed "s?month?$P1?g;s?dday?$P2?g" $projpath/awkSince.txt > $projpath/awkSinceDirs.txt
cd $pathbase
ls -lh *.tar > $TEMP_PATH/ListSince.txt
awk -f $projpath/awkSinceDirs.txt $TEMP_PATH/ListSince.txt
echo "ListSince $P1 $P2 complete."
#end ListSince
