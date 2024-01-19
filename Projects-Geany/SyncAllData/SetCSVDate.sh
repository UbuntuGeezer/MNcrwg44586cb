#!/bin/bash
echo " ** SetCSVDate.sh out-of-date **";exit 1
echo " ** SetCSVDate.sh out-of-date **";exit 1
# SetCSVdate.sh - Set csvdate env var to <spec-db>.db file date.
#	2/27/23.	wmk.
P1=$1
if [ -z "$P1" ];then
 echo " SetCSVDate <spec-db> missing parameter(s) - abandoned."
 read -p " Enter ctrl-c to remain in Terminal:"
 exit 1
fi
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$rupath/Special
ls -lh $P1.csv > $TEMP_PATH/SpecDir.txt
mawk 'BEGIN {print "#!/bin/bash"}{print "export csvdate=" $6}' \
 $TEMP_PATH/SpecDir.txt > $TEMP_PATH/SetCSVdateX.sh
chmod +x $TEMP_PATH/SetCSVdateX.sh
. $TEMP_PATH/SetCSVdateX.sh $P1
popd > $TEMP_PATH/scratchfile
# end CSVDate.sh
