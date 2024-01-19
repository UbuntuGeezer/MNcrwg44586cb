#!/bin/bash
# ExtractBasMod.sh - Extract .bas module from ProcessQTerrs12.ods Module1 source.
# */21/23.	wmk.
#
# Usage. bash  ExtractBasMod.sh <basmodule>
#
#	<basmodule> = module name to extract
#
# Entry. string <basmodule.bas> present in Module1.bas source code.
#
# Modification History.
# ---------------------
# 8/21/23.	wmk.	original shell (template)
#
# Notes. 
#
# P1=<basmodule>
#
P1=$1
if [ -z "$P1" ];then
 echo "ExtractBasMod <basmodule> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
export pathbase=$folderbase/Territories/MN/CRWG/44586
export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ExtractBasMod - initiated from Make"
  echo "  ExtractBasMod - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractBasMod - initiated from Terminal"
  echo "  ExtractBasMod - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
#currpwd=$$PWD
pushd ./ > /dev/null
modpath=$codebase/Projects-Geany/DoTerrsWithCalc
cd $modpath/Basic/Module1
grep -e "$P1.bas" Module1.bas > /dev/null
if [ $? -ne 0 ];then
 echo " ** $P1 not found in Module1.bas **"
 exit 1
fi
sed "s?<basmodule>?$P1?g" awkextractbas.tmp > awkextractbas.txt
mawk -v awkdate=  -v awktime= -f awkextractbas.txt Module1.bas  > $P1.ba1
#echo "end sub     &apos;// end <basmodule>.bas   $$awkdate   $$awktime" >> <basmodule>.ba1
#exit 1
sed "s?&apos;?\'?g;s?&quot;?\"?g;s?&amp;?&?g" $P1.ba1 > $P1.bas;
echo "$P1.bas available for editing"
popd > /dev/null
#endprocbody
echo "  ExtractBasMod $P1 complete."
~/sysprocs/LOGMSG "  ExtractBasMod $P1 complete."
# end ExtractBasMod.sh
