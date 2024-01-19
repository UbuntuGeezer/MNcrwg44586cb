#!/bin/bash
echo " ** SimpleAllSpecMake.sh out-of-date **";exit 1
echo " ** SimpleAllSpecMake.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# SimpleAllSpecMake.sh.sh - Fix all MakeSpecials files on *rawbase*.
# 5/10/23.	wmk.	original shell.
#	9/21/22.	wmk.
#
# Usage.  bash SimpleAllSpecMake.sh.sh <rawbase> [<limit>]
#
#	<rawbase> = base path of Terryyy files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads/Special)
#	<limit> = (optional) max count of db,s to process
#				default=100
# Modification History.
# ---------------------
# 6/3/22.	wmk.	original code; adapted from RebuildAllFixSCs.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "SimpleAllSpecMake.sh <rawbase> [<limit>] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
fi
if ! test -d $P1;then
 echo "SimpleAllSpecMake.sh path '$P1' does not exist - abandoned."
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  SimpleAllSpecMake.sh - initiated from Make"
  echo "  SimpleAllSpecMake.sh - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SimpleAllSpecMake.sh - initiated from Terminal"
  echo "  SimpleAllSpecMake.sh - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls Make.*.Terr > $projpath/DBList.txt
awk -F "." '{print $2}' $projpath/DBList.txt > $projpath/BatchList.txt
# loop on BatchList.txt...
cd $projpath
file=$projpath/BatchList.txt
flimit=$P2
fcount=0
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
  echo "processing  Make.$fn.Terr ..."
  $projpath/SimpleSpecMake.sh $P1 $fn 
  fcount=$((fcount+1))
  if [ $fcount -ge $flimit ];then break;fi
done < $file
#endprocbody.
echo "  $fcount files processed."
~/sysprocs/LOGMSG "  SimpleAllSpecMake.sh $P1 $P2 $P3 complete."
echo "  SimpleAllSpecMake.sh $P1 $P2 $P3 complete."
# end SimpleAllSpecMake.sh.sh
