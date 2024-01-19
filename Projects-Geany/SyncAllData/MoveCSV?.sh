#!/bin/bash
echo " ** MoveCSV?.sh out-of-date **";exit 1
echo " ** MoveCSV?.sh out-of-date **";exit 1
dstr=2023-02-17
fstr=VillageCir.csv
csvdate=$(date -d $dstr +%Y%m%d)
cutoff=$(date -d "2022-01-01" +%Y%m%d)
if [ $csvdate -lt $cutoff ];then
 mv $pathbase/$rupath/Special/$fstr $pathbase/$rupath/Special/Previous
 echo "  $fstr moved to ./Previous.."
else
 echo "  $fstr skipped.."
fi
