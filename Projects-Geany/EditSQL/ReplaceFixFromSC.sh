#!/bin/bash
echo " ** ReplaceFixFromSC.sh out-of-date **";exit 1
echo " ** ReplaceFixFromSC.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# ReplaceFixFromSC.sh - replace FixFromSC with edited code from Terr124.
#	7/10/22.	wmk.
#
# Usage. bash  ReplaceFixFromSC <terrid>
#
#	<terrid> = territory ID
#
# Modification History.
# ---------------------
# 7/6/22.	wmk.	original code.
# 7/10/22.	wmk.	add PrepSQL to sequence.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
P1=$1
if [ -z "$P1" ];then
 echo "ReplaceFixFromSC <terrid> missing parameter(s). - abandoned."
 exit 1
fi
terr=Terr
fix=Fix
rusfx=RU.sql
ru=RU
projpath=$codebase/Projects-Geany/EditSQL
cd $pathbase/$rupath/$terr$P1
cd $projpath
if test -f FixFromSC.sql;then
 rm FixFromSC.sql
fi
./GetSQLSource.sh $pathbase/$rupath/$terr$P1 $fix$P1$ru
./DoSed.sh FixFromSC $fix$P1$ru
./PrepSQL.sh FixFromSC $fix$P1$ru
cp -p FixFromSC124.sql FixFromSC.sql
make -f MakeReplaceSQL
sed -i "s?124?$P1?g" $fix$P1$rusfx
./PutSQLSource.sh $pathbase/$rupath/$terr$P1 $fix$P1$ru
echo "ReplaceFixFromSC $P1 complete."
# end ReplaceFixFromSC.sh path file

