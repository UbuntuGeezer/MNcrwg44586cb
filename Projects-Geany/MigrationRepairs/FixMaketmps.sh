#!/bin/bash
echo " ** FixMaketmps.sh out-of-date **";exit 1
echo " ** FixMaketmps.sh out-of-date **";exit 1
# FixMaketmps.sh - Fix header line in key Make files, eliminating '.tmp'.
#
# Usage. bash  FixMaketmps.sh <path> <terrid>
#
#	<path> = SCPA-Downloads or RefUSA-Downloads
#	<terrid> = territory ID
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixMaketmps <path> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixMaketmps - initiated from Make"
  echo "  FixMaketmps - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixMaketmps - initiated from Terminal"
  echo "  FixMaketmps - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $P1/Terr$P2
#ls Make* > $TEMP_PATH/Makefiles.txt
echo "MakeRegenSpecDB" > $TEMP_PATH/Makefiles.txt
echo "MakeSetSpecTerrs" >> $TEMP_PATH/Makefiles.txt
echo "MakeSyncTerrToSpec" >> $TEMP_PATH/Makefiles.txt
if ! test -f MakeRegenSpecDB;then
 echo "FixMaketmps Terr$P2 - no makefiles to process."
 exit 0
fi
file=$TEMP_PATH/Makefiles.txt
while read -e;do
 echo "   processing $REPLY..."
 sed -i '1s?.tmp??' $REPLY
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  FixMaketmps $P2 complete."
~/sysprocs/LOGMSG "  FixMaketmps $P2 complete."
# end FixMaketmps.sh
