# do not fire separate instance of *bash whn running this..
P1=$1  # for now...
TID=$P1
if test -f $TEMP_PATH/counter;then rm $TEMP_PATH/counter;fi
echo "0" > $TEMP_PATH/counter
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$rupath/Special
grep -re "(MAKE).*Terr$TID" > $TEMP_PATH/SpecTIDList.txt
if [ $? -eq 0 ];then
 rusuffx=_RU.db
 TID=$P1
 mawk -F "." '{print $2}' $TEMP_PATH/SpecTIDList.txt > $TEMP_PATH/LoopList.txt
 # loop checking all <spec-db>.db containing this territory ID.
 # if there is at least 1 where <spec-db>.db is newer than Terrxxx_RU.db
 # then set temp counter = 1
 file=$TEMP_PATH/LoopList.txt
 while read -e;do
  len=${#REPLY}
  len1=$((len+1))
  dbname=${REPLY:0:len1}
  echo " checking Terr$TID against $dbname"
	 if [ $pathbase/$rupath/Terr$TID/Terr$TID$rusuffx \
	  -ot $pathbase/$rupath/Special/$dbname.db ];then \
	  echo "1" > $TEMP_PATH/counter;break;fi
 done < $file
fi
popd > $TEMP_PATH/scratchfile
# end FlagSpecRUUpdate
