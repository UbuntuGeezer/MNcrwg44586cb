#!/bin/bash
# MakeRawData.sh -  (Dev) Make RawData folders for Terr xxx.
# 4/10/22.	wmk.
#	Usage. bash MakeRawData.sh terrid [<state> <county> <congno>]
#		terrid  - territory id
#		<state> - 2 char state abbreviation
#		<county> - 4 char county abbreviation
#		<congno> - congregation number
#
#	Results.
#		Folder TErrxxx created in ~/RawData/RefUSA/RefUSA-Downloads
#			and ~/RawData/SCPA/SCPA-Downloads folders
#			on path ~/Territories
#		Folders Terrxxx and Terrxxx/Previous created in
#		    ~/RawData/RefUSA/RefUSA-Downloads
#			and ~/RawData/SCPA/SCPA-Downloads folders
#			on path ~/Territories
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 4/3/22.	wmk.	<state> <county> <congno> parameters support; HOME
#			 changed to USER in host check.
# 4/7/22.	wmk.	folderbase improvements; *pathbase* support.
# 4/10/22.	wmk.	remove *jumpto* function.
# Legacy mods.
# 1/8/21.	wmk.	original shell
# 5/30/21.	wmk.	modified for multihost system support.
# 6/17/21.	wmk.	bug fixes; ($)folderbase not substituted within ';
#					changed from cd to test in directory conditional;
#					multihost code generalized.
# 6/27/21.	wmk.	superfluous "s removed; LOGMSG used.
# 8/29/21.	wmk.	added /Terrxxx and /Terrxxx/Previous folders to
#					subdirectories created for downstream support; cd,s
#					replaced with test -d; superfluous "s removed.
P1=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
if [ -z "$pathbase" ];then
 if [ -z "$P2 " ];then
   export pathbase=$folderbase/Territories
 else
   if [ -z "$P3" ] || [ -z "$P4" ];then
    echo "  MakeRawData <terrid> <state> <county> <congno> - missing parameter(s) - abandoned."
    exit 1  
   else
    export pathbase=$folderbase/Territories/$P2/$P3/$P4
   fi
 fi
fi
if [ "$pathbase" != "$folderbase/Territories/$P2/$P3/$P4" ];then
 echo $pathbase
 echo "  MakeRawData *pathbase* does not match $folderbase/Territories/$P2/$P3/$P4 - abandoned."
 exit 1
fi
#
system_log=$folderbase/ubuntu/SystemLog.txt
if [ -z "$P1" ]; then
#  echo "  MakeRawData.. -terrid not specified - abandoned." >> $system_log #
  ~/sysprocs/LOGMSG "  MakeRawData.. -terrid not specified - abandoned."
  echo "  MakeRawData <terrid> [<state> <county> <congno>] - missing parameter(s) - abandoned."
  exit 1
fi
#  echo "  MakeRawData $1 - initiated from Terminal" >> $system_log #
~/sysprocs/LOGMSG "  MakeRawData $P1 - initiated from Terminal"
echo "  MakeRawData $P1 $P2 $P3 $P4 - initiated from Terminal"  
TID=$1
#proc body here
pushd ./ >>junk.txt
cd $pathbase/RawData
TERR_BASE1=RefUSA/RefUSA-Downloads/TErr$TID
TERR_BASE3=RefUSA/RefUSA-Downloads/Terr$TID
TERR_BASE5=RefUSA/RefUSA-Downloads/Terr$TID/Previous
TERR_BASE2=SCPA/SCPA-Downloads/TErr$TID
TERR_BASE4=SCPA/SCPA-Downloads/Terr$TID
TERR_BASE6=SCPA/SCPA-Downloads/Terr$TID/Previous
# ensure all RU paths exist
if  test -d ./$TERR_BASE1  ; then
 echo "./$TERR_BASE1 already exists.. skipped"
else
 mkdir $TERR_BASE1
 echo "./$TERR_BASE1 created"
fi

if  test -d ./$TERR_BASE3  ; then
 echo "./$TERR_BASE3 already exists.. skipped"
else
 mkdir $TERR_BASE3
 echo "./$TERR_BASE3 created"
fi

if  test -d ./$TERR_BASE5  ; then
 echo "./$TERR_BASE5 already exists.. skipped"
else
 mkdir $TERR_BASE5
 echo "./$TERR_BASE5 created"
fi

# ensure all SC paths exist
if  test -d ./$TERR_BASE2 ; then
 echo "./$TERR_BASE2 already exists.. skipped"
else
 mkdir ./$TERR_BASE2
 echo "./$TERR_BASE2 created"
fi

if  test -d ./$TERR_BASE4 ; then
 echo "./$TERR_BASE4 already exists.. skipped"
else
 mkdir ./$TERR_BASE4
 echo "./$TERR_BASE4 created"
fi

if  test -d ./$TERR_BASE6 ; then
 echo "./$TERR_BASE6 already exists.. skipped"
else
 mkdir ./$TERR_BASE6
 echo "./$TERR_BASE6 created"
fi

popd >>junk.txt
if test -f junk.txt;then
 rm junk.txt
fi
#end proc body
if [ "$USER" != "$vncwmk3" ];then
 notify-send "MakeRawData $TID" " $P2 $P3 $P4complete."
fi
~/sysprocs/LOGMSG "  MakeRawData $TID $P2 $P3 $P4 complete."
echo "  MakeRawData $TID $P2 $P3 $P4 complete."
#end MakeRawData.sh 
