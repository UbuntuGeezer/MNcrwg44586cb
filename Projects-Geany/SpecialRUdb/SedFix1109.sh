#!/bin/bash
echo " ** SedFix1109.sh out-of-date **";exit 1
echo " ** SedFix1109.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# SedFix1109.sh - Patch SetSpecTerrs.sql for territory xxx.
#		5/5/22.	wmk.
#
# Usage. bash SedFix1109.sh  <terrid>
#
#	<terrid> = territory ID for SedFix to work on.
#
# Modification History.
# ---------------------
# 11/9/21.	wmk.	original code.
# 5/5/22.	wmk.	*pathbase* support.
# set sqlpath pointing to /RefUSA-Downloads/Terrxxx
if [ -z "$folderbase" ];then
 if[ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathabase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
P1=$1
if [ -z "$P1" ];then
 echo "SedFix1109 missing <terrid> parameter - abandoned."
 exit 1
fi
sqlpath=$pathbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr$P1
if test -f $sqlpath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - SedFix1109 exiting..**"
 exit 2
fi
echo "s?AS Acct FROM db19.Spec_RUBridge?AS Acct FROM Terr$P1 _SCBridge?g" > sedatives.txt
echo "s? _SCBridge?_SCBridge?g" >> sedatives.txt
echo "20a-- * 11/9/21.   wmk.    bug fix setting territory in db29." >> sedatives.txt
echo "2d" >> sedatives.txt
echo "1a-- * 11/9/21.   wmk." >> sedatives.txt
sed  -i -f sedatives.txt $sqlpath/SetSpecTerrs.sql
# end SedFix1109.sh
