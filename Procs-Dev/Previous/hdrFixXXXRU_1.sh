#!/bin/bash
# hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/18/22.	wmk.
#	Usage. bash FixXXXRU.sh
#		
# Dependencies.
#	TerrXXX_RU.db exists in RefUSA-Downloads/TerrXXX folder
#	VeniceNTerritory.db exists in DB-Dev folder
#
# Modification History.
# ---------------------
# 5/27/22.	wmk.	*pathbase* support.
# 6/18/22.	wmk.	bug fix; superfluous fi in folderbase conditional.
# Legacy mods.
# 3/11/21.	wmk.	original shell (template)
# 5/27/21.	wmk.	modified for use with Kay's system; folderbase env
#					var added.
# 6/6/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH
#					ensured set; superfluous popd in epilog removed.
# 6/8/21.	wmk.	switch logic in ($)HOME check so anything other than
#					/home/ubuntu gets set to ($)HOME folderbase.
# 8/28/21.	wmk.	split into 2 files from hdrFixXXXRU.sh; this is
#					the code up to where the converted SQL gets inserted;
#					hdrFixXXXRU_2.SH is the shell after the converted
#					SQL is inserted; cat used to join everything up.
#					(see FixAnyRU.sh).
# 9/4/21.	wmk.	bug fix missing shebang line 1; superfluous #s removed;
#					jumpto disabled.
# 9/19/21.	wmk.	pushd/popd eliminated.
# 4/8/22.	wmk.	code check; folderbase handling improved.
#jumpto function definition
#function jumpto
#{
#    label=$1
#    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
#    eval "$cmd"
#    exit
#}
P1=$1
TID=$P1
TN=Terr
if [ -z "$folderbase" ];then
  if  [ "$USER" == "ubuntu" ] ; then
   export folderbase=/media/ubuntu/Windows/Users/Bill
  else 
   export folderbase=$HOME
  fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   $FN$P1$RU initiated from make."
  echo "   $FN$P1$RU initiated from make."
  ~/sysprocs/LOGMSG "  FixXXXRU - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixXXXRU - initiated from Terminal"
  echo "  FixXXXRU - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#proc body here

pushd ./ > $TEMP_PATH/bitbucket.txt
