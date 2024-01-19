#!/bin/bash
echo " ** GetSQLSource.sh out-of-date **";exit 1
echo " ** GetSQLSource.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# GetSQLSource - Copy .sql source file to project folder.
#	7/9/22.	wmk.
#
# Usage.  bash   GetSQLSource <sqlpath> <sqlfile>
#
# Modification History.
# ---------------------
# 7/6/22.	wmk.	original code; adapted from EditBas project.
# 7/9/22.	wmk.	.sql file missing message corrected.
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
 echo "** GetSQLSource <sqlpath> <sqlfile> missing paramter(s) - abandoned.**"
 exit 1
fi
if ! test -d $P1;then
 echo "  ** $P1  path not found - abandoned. **"
 exit 1
fi
if ! test -f $P1/$P2.sql;then
 echo "** file $P2.sql not found for copy - GetSQLSource abandoned.**"
 exit 1
fi
if [ $P1/$P2.sql -ot $projpath/$P2.sql ];then
 echo "**$P2.sql copy skipped - EditSQL/$P2.sql is newer.**"
 ~/sysprocs/LOGMSG "**$ GetSQLSource $P2.sql copy skipped - EditSQL/$P2.sql is newer.**"
else
 cp -pu $P1/$P2.sql $projpath
 echo "$P2.sql copied to EditSQL project folder."
 ~/sysprocs/LOGMSG "  GetSQLSource $P2.sql copied to EditSQL project folder."
fi
# end GetSQLSource.sh.
