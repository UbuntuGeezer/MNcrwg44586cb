#!/bin/bash
echo " ** CycleNextCSV.sh out-of-date **";exit 1
echo " ** CycleNextCSV.sh out-of-date **";exit 1
# CycleNextCSV.sh - cycle through setting RecordDate fields on next RU/Special/<db-name>.csv.
#	2/28/23.	wmk.
. ./GetNextSpecDB.sh
. ./setcsv.sh
./DoSed1.sh $pathbase/$rupath/Special $csvname Spec_RUBridge
./SetAllDBcsvDate.sh $csvname
# end CycleNextCSV.sh
