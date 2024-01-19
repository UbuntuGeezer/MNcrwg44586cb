#!/bin/bash
echo " ** RemakeSetSpecs.sh out-of-date **";exit 1
echo " ** RemakeSetSpecs.sh out-of-date **";exit 1
# RemakeSetSpecs.sh - Remake MakeSetSpecTerrs for territory xxx.
#	6/5/23.	wmk.
#
# Usage. bash RemakeSetSpecs.sh  <terrid>
#
#	<terrid> = territory ID for SedFix to work on.
#
# set sqlpath pointing to /RefUSA-Downloads/Terrxxx
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 11/9/21.	wmk.	original code.
#
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
P1=$1
sqlpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
if test -f $sqlpath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - RemakeSetSpecs exiting..**";exit 2;fi
fi
~/sysprocs/LOGMSG "  'make' MakeSetSpecTerrs $P1."
make -f $sqlpath/MakeSetSpecTerrs
# end RemakeSetSpecs.sh
