#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# hdrFixXXXsc.sh - Fix RU records territory Any postprocessor.
# FixXXXsc_1.sh - Fix RU records territory XXX postprocessor preamble.
#	6/28/22.	wmk.
#	Usage. bash FixXXXsc.sh
#		
# Dependencies.
#	FixXXX_SC.db exists in SCPA-Downloads/FixXXX folder
#	VeniceNTerritory.db exists in DB-Dev folder
#
# Modification History.
# ---------------------
# 5/27/22.	wmk.	*pathbase* support.
# 6/28/22.	wmk.	*procbodyhere removed; (preSCTidy.sh will be inserted).
# Legacy mods.
# 3/15/21.	wmk.	original shell (template)
# 5/29/21.	wmk.	add code for multihost support.
# 6/19/21.	wmk.	bug fix (%)folderbase reference; multihost generalized.
# 6/27/21.	wmk.	separated from hdrFixXXXSC.sh; multihost generalized.
# 4/8/22.	wmk.	HOME changed to USER in host test; folderbase improvements.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Terminal"
  echo "  FixXXXsc - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
pushd ./ > $TEMP_PATH/bitbucket.txt

