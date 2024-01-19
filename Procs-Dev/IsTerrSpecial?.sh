#!/bin/bash
echo " ** IsTerrSpecial?.sh out-of-date **";exit 1
# IsTerrSpecial?.sh - Determine if territory <terrid> is "special".
#	12/15/22.	wmk.
P1=$1
is_specialRU=0
is_specialSC=0
terr=Terr
ru=_RU
sc=_SC
pushd ./
cd $pathbase/$rupath/Special
grep -e "$P1" SpecialTerrList.txt
if [ $? -eq 0 ];then
is_specialRU=1
fi
if [ $is_specialRU -ne 0 ];then
 echo "Territory $P1 is RefUSA special."
else
 echo "Terrotory $P1 is NOT RefuSA special."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 0
fi
if test -d $pathbase/$rupath/$terr$P1;then 
 cd $pathbase/$rupath/$terr$P1
 ls $terr$P1$ru.db 1>$TEMP_PATH/scratchfile 2>$TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  is_specialRU=1
 fi
else
 echo "Territory $P1 RefUSA data not loaded."
fi
if test -d $pathbase/$scpath/$terr$P1;then 
 cd $pathbase/$scpath/$terr$P1
 ls $terr$P1$sc.db 1> $TEMP_PATH/scratchfile 2>$TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  is_specialSC=1
 fi
else
 echo "Territory $P1 SCPA data not loaded."
fi
if [ $is_specialRU -ne 0 ];then
 echo "Territory $P1 is RefuSA special."
fi
if [ $is_specialSC -ne 0 ];then
 echo "Territory $P1 is SCPA special."
fi
popd
# end IsTerrSpecial?
