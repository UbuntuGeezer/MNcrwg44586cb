#!/bin/bash
# DoSedExtact.sh - *sed edit MakeExtractSchema, ExtractSchema.psq.
# 5/28/23.	wmk.
#
# Usage. bash  DoSedExtact.sh <dbpath> <dbname>
#
#	<dbpath> = full path to database (e.g. *pathbase/*scpath/Special)
#	<dbname> = database name (w/o .db extension)
#
# Entry. 
#
# Dependencies.
#
# Exit.	*TEMP_PATH/dbschema.txt = schema records from <dbpath>/<dbname>.db
#
# Modification History.
# ---------------------
# 5/28/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "DoSedExtact <dbpath> <dbname> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedExtact - initiated from Make"
  echo "  DoSedExtact - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedExtact - initiated from Terminal"
  echo "  DoSedExtact - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<dbpath>?$P1?g;s?<dbname>?$P2?g" ExtractSchema.psq > ExtractSchema.sql
#endprocbody
echo "  DoSedExtact complete."
~/sysprocs/LOGMSG "  DoSedExtact complete."
# end DoSedExtact.sh
