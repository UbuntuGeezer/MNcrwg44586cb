$!/bin/bash
echo " ** MovCSV?.sh out-of-date **";exit 1
echo " ** MovCSV?.sh out-of-date **";exit 1
dstr=2021-07-05
fstr=RUBayIndies_07-04.csv
date -d $dstr > csvdate
if [ $csvdate -lt $cutoff ];then
 mv $fstr ./Previous
 echo "  $fstr moved to ./Previous.."
else
 echo "  $fstr skipped.."
fi
