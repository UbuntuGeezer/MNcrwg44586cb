#!/bin/bash
echo " ** PutXBAModule.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# PutXBAModule - Copy /Libraries-Project/Territories .xba module to project folder.
#	4/24/22.	wmk.
#
# Modification History.
# ---------------------
# 3/8/22.	wmk.	original code; adapted from GetXBAModule.
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
projbase=$codebase/Projects-Geany/EditBas
gitbase=$folderbase/GitHub/Libraries-Project/$conglib
P1=$1
if [ -z "$P1" ];then
 echo "** missing <basmodule> parameter - PutXBAModule abandoned.**"
 exit 1
fi
cd $gitbase
if ! test -f $projbase/$P1.xba;then
 echo "** file EditBas/$P1.xba not found for copy - PutXBAModule abandoned.**"
 exit 1
fi
if [ $P1.xba -nt $projbase/$P1.xba ];then
 echo "**$P1.xba copy skipped - EditBas/$P1.xba is not newer.**"
 ~/sysprocs/LOGMSG "**$ PutXBAModule $P1.xba copy skipped - EditBas/$P1.xba is newer.**"
else
 cp -u $projbase/$P1.xba $P1.xba 
 echo "EditBas/$P1.xba copied to GitHub project folder."
 ~/sysprocs/LOGMSG "  PutXBAModule EditBas/$P1.xba copied to GitHub project folder."
fi
# end PutXBAModule.sh.

