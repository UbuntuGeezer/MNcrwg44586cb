#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllSpecSQLs.sh - fix all /Special/*.sql with *pathbase* support.
#	5/9/22.	wmk.
#
# Usage.  FixAllSpecSQLs.sh <sqlpath>
#
#	<sqlpath> = root path of *SQL* files
#
# Entry.  /Special downstream of <sqlpath>
#
# Modification History.
# ---------------------
# 5/9/22.	wmk.	original code; adapted from FixAllSpecMakes.sh
#
subpath1=RefUSA/RefUSA-Downloads
subpath2=SCPA/SCPA-Downloads
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
  ~/sysprocs/LOGMSG "  FixAllSpecSQLs - initiated from Make"
  echo "  FixAllSpecSQLs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllSpecSQLs - initiated from Terminal"
  echo "  FixAllSpecSQLs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixSQLs
thisproj=$codebase/Projects-Geany/FixTerrSQLs
echo "processing (RU) /Special ..."
srcpath=$pathbase/RawData/$subpath1/Special
cd $srcpath
if test -f $TEMP_PATH/SQLList.txt;then rm $TEMP_PATH/SQLList.txt;fi
ls *.sql > $TEMP_PATH/SQLList.txt
if [ $? -eq 0 ];then
  file2=$TEMP_PATH/SQLList.txt
  # loop on SQL.txt (RU)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   # elminate *fn* P2 suffix when calling FixSQL shell...
   echo "processing $fn ..."
   if [ "$extstr" != "bak" ];then
    $projpath/FixSQL.sh $srcpath $fn
   else
    echo " skipping .bak file."
   fi
  done < $file2
fi
echo "processing (SC) /Special ..."
srcpath=$pathbase/RawData/$subpath2/Special
cd $srcpath
if test -f $TEMP_PATH/SQLList.txt;then rm $TEMP_PATH/SQLList.txt;fi
ls *.sql > $TEMP_PATH/SQLList.txt
if [ $? -eq 0 ];then
  sed -i 's?.sql??g' $TEMP_PATH/SQLList.txt
  file2=$TEMP_PATH/SQLList.txt
  # loop on SQL.txt (SC)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   echo "processing $fn ..."
   echo "srcpath = '$srcpath'"
   if [ "$extstr" != ".bak" ];then
    $projpath/FixSQL.sh $srcpath $fn
   else
    echo " skipping .bak file."
   fi
  done < $file2
 else
  echo " No *SQL* files in $srcpath"
fi
~/sysprocs/LOGMSG "  FixAllSpecSQLs complete."
echo "  FixAllSpecSQLs complete."
# end FixAllSpecSQLs.sh
