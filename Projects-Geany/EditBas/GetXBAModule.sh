#!/bin/bash
echo " ** GetXBAModule.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# GetXBAModule - Copy /Libraries-Project/Territories .xba module to project folder.
#	4/24/22.	wmk.
#
# Modification History.
# ---------------------
# 3/7/22.	wmk.	original code.
# 3/8/22.	wmk.	exit added if file not found error.
# 4/24/22.	wmk.	*pathbase*, *congterr env vars included;*conglib*
#			 env var introduced.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
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
projbase=$codebase/Projects-Geany/EditBas
gitbase=$folderbase/GitHub/Libraries-Project/$conglib
P1=$1
if [ -z "$P1" ];then
 echo "** missing <basmodule> - GetXBAModule abandoned.**"
 exit 1
fi
cd $gitbase
if ! test -f $P1.xba;then
 echo "** file GitHub/$P1.xba not found for copy - GetXBAModule abandoned.**"
 exit 1
fi
if [ $P1.xba -ot $projbase/$P1.xba ];then
 echo "**$P1.xba copy skipped - EditBas/$P1.xba is newer.**"
 ~/sysprocs/LOGMSG "**$ GetXBAModule $P1.xba copy skipped - EditBas/$P1.xba is newer.**"
else
 cp -u $P1.xba $projbase/$P1.xba
 echo "$P1.xba copied to EditBas project folder."
 ~/sysprocs/LOGMSG "  GetXBAModule $P1.xba copied to EditBas project folder."
fi
# end GetXBAModule.sh.
