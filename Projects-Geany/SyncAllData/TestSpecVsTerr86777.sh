
echo " ** TestSpecVsTerr86777.sh out-of-date **";exit 1
echo " ** TestSpecVsTerr86777.sh out-of-date **";exit 1
# test spec vs Terr86777
	projpath=$codebase/Projects-Geany/SyncAllData
	specname=AuburnCoveCir.db
	 # check against latest SC master Terr86777.db
	 pushd ./ > $TEMP_PATH/scratchfile
	 cd $projpath;./DoSed1.sh $pathbase/$rupath/Special $specname Spec_RUBridge
	 make -f $projpath/MakeLatestDwnldDate
	 . ./LatestDwnldDate.sh
	 # have *TEMP/PATH/LatestDwnldDate.txt
	 ls -lh $pathbase/$rupath/Special/$specname > $TEMP_PATH/DBdate.txt
	 file=$TEMP_PATH/DBdate.txt
	 while read -e;do
 	  date1=$(echo $REPLY | mawk -F " " '{print $6}')
 	  break
	 done < $file
	 file=$TEMP_PATH/LatestDwnldDate.txt
	 while read -e;do
	  date2=$(echo $REPLY | mawk -F "," '{print $1}')
	 done < $file
	 #read -p "Enter ctrl-c to remain in Terminal"
	 #exit 0
     echo "AuburnCoveCir.db $date2"
     echo "Terr86777.db $date1"
	 if [ "$date1" < "$date2" ];then\
	   echo "  ** $specname out-of-date **";\
	   echo "$specname - older than Terr86777.db" >> $projpath/RUSpecOODlist.txt;\
	   oodcount=$((oodcount+1));fi
	 popd > $TEMP_PATH/scratchfile
