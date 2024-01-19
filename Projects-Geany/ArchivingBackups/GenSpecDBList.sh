#!/bin/bash
# GenSpecDBList.sh - Generate dblist<terrid>.txt for Special territory <terrid>.
# 9/26/22.	wmk.
#
# Usage. bash  GenSpecDBList.sh <terrid> [type]
#
#	<terrid> = territory ID to generate list for.
#	[type] = (optional) RU|SC Special database type
#		(default RU)
#
# Entry. *pathbase/*rupath/Special/Make.*.Terr files are territory make files
#		   for all RU /Special databases.
#	 *pathbase/*scpath/Special/Make.*.Terr files are territory make files
#		   for all SC /Special databases.
*
# Exit. ArchivingBackups/dblist<terrid>.txt = list of databases referenced by
#		 territory <terrid> for RU or SC <type>
#
# Modification History.
# ---------------------
# 9/25/22.	wmk.	original code.
# 9/26/22.	wmk.	*datapath added to target path
#
P1=$1		# terrid
P2=${2^^}	# type RU|SC
if [ -z "$P1" ];then
 echo "GenSpecDBList  <terrid> <missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=RU
fi
if [ "$P2" != "RU" ] && [ "$P2" != "SC" ];then
 echo "GenSpecDBList <terrid> [RU|SC] unrecognized type - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  GenSpecDBList - initiated from Make"
  echo "  GenSpecDBList $P1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GenSpecDBList - initiated from Terminal"
  echo "  GenSpecDBList $P1 - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
pushd ./
if [ -z "$rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$scpath" ];then
 export scpath=RawData/SCPA/SCPA-Downloads
fi
projpath=$codebase/Projects-Geany/ArchivingBackups
if [ "$P2" == "RU" ];then
 datapath=RUData
 cd $pathbase/$rupath/Special
else
 cd $pathbase/$scpath/Special
 datapath=SCData
fi
grep -rl -e "Terr$P1" --include "*.Terr"
if [ $? -eq 0 ];then
 grep -rl -e "Terr$P1" --include "*.Terr" | mawk -F . \
  '{print $2}' > $projpath/$datapath/dblist$P1.txt
else
 echo "#" > $projpath/$datapath/dblist$P1.txt
fi
popd
#endprocbody
echo "  GenSpecDBList $P1 $P2 complete."
~/sysprocs/LOGMSG "  GenSpecDBList $P1 $P2 complete."
# end GenSpecDBList
