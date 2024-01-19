#/bin/bash
# MakeBRawData.sh -  (Dev) Make RawData folders for Terr xxx.
# 5/11/22.	wmk.
#
#	Usage. bash MakeBRawData.sh terrid
#		terrid  - territory id
#
#	Results.
#		Folder TErrxxx created in ~/BRawData/BRefUSA/BRefUSA-Downloads
#			and ~/BRawData/BSCPA/BSCPA-Downloads folders
#			on path ~/Territories
#		Folders Terrxxx and Terrxxx/Previous created in
#		    ~/BRawData/BRefUSA/BRefUSA-Downloads
#			and ~/BRawData/BSCPA/BSCPA-Downloads folders
#			on path ~/Territories
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 5/11/22.	wmk.	*pathbase* support.
# 8/12/22.	wmk.	change from BRawData to RawData; (business territoriess
#			 now determined strictly by <terrid>.
# Legacy mods.
# 9/24/21.	wmk.	original shell; adapted from MakeRawData;
#					jumpto function eliminated.
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
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$1" ]; then
#  echo "  MakeBRawData.. -terrid not specified - abandoned." >> $system_log #
  ~/sysprocs/LOGMSG "  MakeBRawData.. -terrid not specified - abandoned."
  echo "  MakeBRawData.. must specify - terrid."
  exit 1
else
#  echo "  MakeBRawData $1 - initiated from Terminal" >> $system_log #
  ~/sysprocs/LOGMSG "  MakeBRawData $1 - initiated from Terminal"
  echo "  MakeBRawData $1 - initiated from Terminal"
fi 
TID=$1
#proc body here
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

#end proc body
~/sysprocs/LOGMSG "  MakeBRawData $TID complete."
echo "  MakeBRawData $TID complete."
#end MakeBRawData.sh 
