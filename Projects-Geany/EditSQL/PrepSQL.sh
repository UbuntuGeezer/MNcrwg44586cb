#!/bin/bash
echo " ** PrepSQL.sh out-of-date **";exit 1
echo " ** PrepSQL.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# PrepSQL.sh - PrepSQL module for extraction.
#	9/23/22.	wmk.
#
# Usage. bash  PrepSQL.sh <modname> <sqlsrc>
#
#	<modname> = SQL module name within file
#	<sqlsrc> = source file name
#
# Modification History.
# ---------------------
# 7/6/22.	wmk.	original code.
# 9/23/22.	wmk.	*folderbase, *pathbase checks added.
# PrepSQL looks for a line '-- ** <modname>' and inserts -- * <modname>.sql before it.
#		  looks for a line '-- ** END <modname> and addes --/**/ after it.
P1=$1
P2=$2
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbsase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
projpath=$codebase/Projects-Geany/EditSQL
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "PrepSQL <modname> <sqlsrc> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -f $P2.sql; then
 echo "PrepSQL $P2.sql missing - abandoned."
 exit 1
fi
cp -pv $P2.sql $P2.sql.bak
sed "s?<mod>?$P1?g" $projpath/sedPre.txt > $projpath/sedPredir.txt
sed -i -f $projpath/sedPredir.txt $P2.sql
echo "PrepSQL complete."
# end PrepSQL
