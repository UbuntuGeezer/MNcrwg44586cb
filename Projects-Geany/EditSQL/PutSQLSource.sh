#!/bin/bash
echo " ** PutSQLSource.sh out-of-date **";exit 1
echo " ** PutSQLSource.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# PutSQLSource - Copy .sql source file to project folder.
#	7/6/22.	wmk.
#
# Usage.  bash   PutSQLSource <sqlpath> <sqlfile>
#
# Modification History.
# ---------------------
# 7/6/22.	wmk.	original code; adapted from EditBas project.
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
projpath=$codebase/Projects-Geany/EditSQL
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "** PutSQLSource <sqlpath> <sqlfile> missing paramter(s) - abandoned.**"
 exit 1
fi
if ! test -d $P1;then
 echo "  ** $P1  path not found - abandoned. **"
 exit 1
fi
if ! test -f $P1/$P2.sql;then
 echo "** file $P1.sql not found for copy - PutSQLSource abandoned.**"
 exit 1
fi
if [ $projpath/$P2.sql -ot $P1/$P2.sql ];then
 echo "**$P2.sql copy skipped - $P1/$P2.sql is newer.**"
 ~/sysprocs/LOGMSG "**$ PutSQLSource $P2.sql copy skipped - EditSQL/$P2.sql is newer.**"
else
 if test -f $P1/$P2.sql;then
  mv $P1/$P2.sql $P1/$P2.bak
 fi
 cp -pv $projpath/$P2.sql  $P1/$P2.sql
 echo "$P2.sql copied to $P1 folder."
 ~/sysprocs/LOGMSG "  PutSQLSource $P2.sql copied to $P1 folder."
fi
# end PutSQLSource.sh.
