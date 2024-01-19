# checkpostscript.sh - check length of *TEMP_PATH/FoundTerrID.txt.
#   6/2/23. wmk.
if ! test -s $TEMP_PATH/FoundTerrID.txt;then
 idfound=0
else
 idfound=1
fi
if [ $idfound -eq 0 ];then
 exit 1
fi
