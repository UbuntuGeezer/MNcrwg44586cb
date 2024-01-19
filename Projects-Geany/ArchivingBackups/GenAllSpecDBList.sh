#!/bin/bash
# GenAllSpecDBList.sh - Generate dblist<terrid>.txt for all Special territory <terrid>.
# 9/26/22.	wmk.
#
# Usage. bash  GenAllSpecDBList.sh [type]
#
#	[type] = (optional) RU|SC Special database type
#		(default RU)
#
# Entry. *projpath/SpecRUTerrList.txt = all RU territories list (e.g. Terr103)
#	 *projpath/SpecSCTerrList.txt = all SC terrtitories list (e.g. Terr103)
# 
# Exit. ArchivingBackups/dblist<terrid>.txt = list of databases referenced by
#		 territory <terrid> for RU or SC <type>
#	  for all RU/SC <terrid>s
#
# Modification History.
# ---------------------
# 9/26/22.	wmk.	original code.
#
P1=${1^^}	# type RU|SC
if [ -z "$P1" ];then
 echo "GenSpecDBList  <terrid> <missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P1" ];then
 P1=RU
 echo "GenAllSpecDBList [type] - type defaulted to RU."
fi
if [ "$P1" != "RU" ] && [ "$P1" != "SC" ];then
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
if [ "$P1" == "RU" ];then
 cd $pathbase/$rupath/Special
 speclist=SpecRUTerrList.txt
else
 cd $pathbase/$scpath/Special
 speclist=SpecSCTerrList.txt
fi
#procbodyhere
# loop on speclist of territories.
terrcount=0
file=$projpath/$speclist
while read -e; do
 frstchar=${REPLY:0:1}
 terrid=${REPLY:4:4}
 if [ ${#terrid} -eq 0 ];then
  continue
 elif [ "$fstchar" == "#" ];then
  continue
 elif [ "$fstchar" == "$" ];then
  break
 fi
 terrcount=$((terrcount+1))
 $projpath/GenSpecDBList.sh $terrid $P1
done < $file
#endprocbody
echo "  GenAllSpecDBList $terrcount territories processed."
echo "  GenAllSpecDBList $P1 complete."
~/sysprocs/LOGMSG "  GenAllSpecDBList $P1 complete."
