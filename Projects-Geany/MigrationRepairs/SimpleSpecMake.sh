#!/bin/bash
echo " ** SimpleSpecMake.sh out-of-date **";exit 1
echo " ** SimpleSpecMake.sh out-of-date **";exit 1
# SimpleSpecMake.sh - Simplify Make.<spec-db>.Terr makefile.
# 5/10/23.	wmk.
#
# Usage. bash  SimpleSpecMake.sh <path> <spec-db>
#
#	<path> = SCPA-Downloads or RefUSA-Downloads/Special
#	<spec-db> = special db name (no .db suffix)
#
# Entry. <path>/Make.<spec-db>.Terr is makefile for rebuilding SC/RU territories
#	affected if <spec-db>.db updated.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/10/23.	wmk.	original shell; adapted from FixMakes= shell.
# Legacy mods.
# 5/6/23.	wmk.	original shell.
# 5/7/23.	wmk.	header corrections.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "SimpleSpecMake <path> <spec-db>> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  SimpleSpecMake - initiated from Make"
  echo "  SimpleSpecMake - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SimpleSpecMake - initiated from Terminal"
  echo "  SimpleSpecMake - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls Make.$P2.Terr > $TEMP_PATH/Makefiles.txt
if [ $? -ne 0 ];then
 echo "SimpleSpecMake Terr$P2 - no Make.$P2.Terr to process."
 exit 0
fi
file=$TEMP_PATH/Makefiles.txt
while read -e;do
 skip=0
 grep -e "(automated) replace first recipe line" Make.$P2.Terr > $TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  skip=1
  echo "  Make.$P2.Terr already processed - skipping.."
 fi
 if [ $skip -eq 0 ];then 
  echo "  processing $REPLY..."
  mawk -f $projpath/awkreprecipe1st.txt Make.$P2.Terr > $TEMP_PATH/Make.$P2.Terr
  mv Make.$P2.Terr Make.$P2.Terr.bak
  cp -pv $TEMP_PATH/Make.$P2.Terr Make.$P2.Terr
 fi
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  SimpleSpecMake complete."
~/sysprocs/LOGMSG "  SimpleSpecMake complete."
# end SimpleSpecMake.sh
