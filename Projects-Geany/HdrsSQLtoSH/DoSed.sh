#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - Run sed to morph MakeHdrsSQLtoSH.
#	11/26/22.	wmk.
#
# Usage.  bash DoSed.sh <filepath> <filename>
#
#	<filepath> = file path of <filename> 
#		e.g. $folderbase/Territories/RawData/SCPA/SCPA-Downloads/Special
#	<filename> = filename (no extension, .sql assumed) to convert
#
# Modification History.
# ---------------------
# 11/26/22.	wmk.	comments tidied; paths verified.
# Legacy mods.
# 6/5/22.	wmk.	original shell; adapted from /AnySQLtoSH project.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 4/22/22.	wmk.	modified for FL/SARA/86777.
# 4/23/22.	wmk.	mods tweaked.
# 5/8/22.	wmk.	<filepath> checked for trailing '/' and eliminated
#			 so paths don't get messed up.
# Legacy mods.
# 4/6/21.	wmk.	original code.
# 6/17/21.	wmk.	multihost support; sedatives separator "?" to avoid
#					issues with parameters containing "/".
# 10/12/21.	wmk.	./Territories filepath assumption removed.
P1=$1
len=${#P1}
len1=$((len-1))
if [ "${P1:len1:1}" == "/" ];then
 intpath=${P1:0:len1}
 P1=$intpath
fi
P2=$2
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
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
TEMP_PATH=$HOME/temp
pushd ./ > $TEMP_PATH/scratchfile
projpath=$codebase/Projects-Geany/HdrsSQLtoSH
cd $projpath
echo "s?<filename>?$P2?g" > sedatives.txt
echo "s?<filepath>?$P1?g" >> sedatives.txt
sed -f sedatives.txt MakeHdrsSQLtoSH.tmp > MakeHdrsSQLtoSH
popd > $TEMP_PATH/scratchfile
echo "DoSed  $P1  $P2 complete."
