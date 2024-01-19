#!/bin/bash
echo " ** FindBadMakes.sh out-of-date **";exit 1
echo " ** FindBadMakes.sh out-of-date **";exit 1
# FindBadMakes.sh - Find makefiles still using cat for .sh makes.
# 2/2/23.	wmk.
#
# Usage. bash  FindBadMakes.sh  [terrstart terrend]
#
#	terrstart = (optional) starting territory ID for scan
#   terrend = (optional, mandatory if terrstart present) ending territory for scan
#
# Entry. *scpath = RawData/SCPA/SCPA-Downloads
#		 *rupath = RawData/RefUSA/RefUSA-Downloads
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. A makefile will be considered "bad" if it contains either:
#	the sequence '.sql .. .sq'
#   or  'cat' at the beginning of a line
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ ! -z "$P1" ];then
 if [ -z "$P2" ];then
  echo "  FindBadMakes [terrstart] [terrend] missing parameter(s) - abandoned."
  exit 1
 fi
 if [ $P2 -lt $P1 ];then
  echo "  FindBadMakes [terrstart] [terrend] terrend < terrstart - abandoned."
  exit 1
 fi
else
 P1=101
 P2=900
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  FindBadMakes - initiated from Make"
  echo "  FindBadMakes - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FindBadMakes - initiated from Terminal"
  echo "  FindBadMakes - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath
if [ $P1 -eq 101 ] && [ $P2 -eq 900 ];then
 echo "  Scanning $scpath..."
 grep -rle "\.sql.*\*.sq" --include "Make*"
 grep -rle "$cat.*hdr" --include "Make*"
 cd $pathbase/$rupath
 echo "  Scanning $rupath.."
 grep -rle "\.sql.*\*.sq" --include "Make*"
 grep -rle "$cat.*hdr" --include "Make*"
else	# process range P1 .. P2
 seq $P1 $P2 > $TEMP_PATH/terrrange.txt
 file=$TEMP_PATH/terrrange.txt
 if test -f $TEMP_PATH/BadMakesList.txt;then rm $TEMP_PATH/BadMakesList.txt;fi
 while read -e;do
  if test -d $pathbase/$scpath/Terr$REPLY;then
   echo "Scanning $scpath/Terr$REPLY..."  >> $TEMP_PATH/BadMakesList.txt 
   cd $pathbase/$scpath/Terr$REPLY
   grep -rle "\.sql.*\*.sq" --include "Make*" >> $TEMP_PATH/BadMakesList.txt >> $TEMP_PATH/BadMakesList.txt
   grep -rle "$cat.*hdr" --include "Make*" >> $TEMP_PATH/BadMakesList.txt >> $TEMP_PATH/BadMakesList.txt
   if test -f SPECIAL;then
    grep -rle "dbname =" --include "MakeSpecials" >> $TEMP_PATH/scratchfile
    if [ $? -ne 0 ];then
     echo " ** $Terr$REPLY/MakeSpecials missing 'dbname =' **" >>  $TEMP_PATH/BadMakesList.txt
    fi
   fi # have SPECIAL conditional
  fi
  if test -d $pathbase/$rupath/Terr$REPLY;then 
   echo "Scanning $rupath/Terr$REPLY..."  >> $TEMP_PATH/BadMakesList.txt
   cd $pathbase/$rupath/Terr$REPLY
   grep -rle "\.sql.*\*.sq" --include "Make*"  >> $TEMP_PATH/BadMakesList.txt
   grep -rle "$cat.*hdr" --include "Make*" >> $TEMP_PATH/BadMakesList.txt
   grep -rle "codebase.*=" --include "MakeSpecials" >> $TEMP_PATH/scratchfile
   if test -f SPECIAL;then
    if [ $? -ne 0 ];then
     echo " ** $Terr$REPLY/MakeSpecials missing 'codebase =' **" >>  $TEMP_PATH/BadMakesList.txt
    fi
   fi
   if test -f SPECIAL;then
    grep -rle "dbname =" --include "MakeSpecials" >> $TEMP_PATH/scratchfile
    if [ $? -ne 0 ];then
     echo " ** $Terr$REPLY/MakeSpecials missing 'dbname =' **" >>  $TEMP_PATH/BadMakesList.txt
    fi
   fi # have SPECIAL conditional
  fi
 done < $file
fi
popd > $TEMP_PATH/scratchfile
#endprocbody
if test -f $TEMP_PATH/BadMakesList.txt;then wc -l $TEMP_PATH/BadMakesList.txt | \
 mawk '{print $1 " entries in $TEMP_PATH/BadMakesList.txt"}'; \
 sed -i 's?Make? Make?g' $TEMP_PATH/BadMakesList.txt;fi
echo "  FindBadMakes complete."
~/sysprocs/LOGMSG "  FindBadMakes complete."
# end FindBadMakes.sh
