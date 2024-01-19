#!/bin/bash
echo " ** GetNextSpecDB.sh out-of-date **";exit 1
echo " ** GetNextSpecDB.sh out-of-date **";exit 1
# GetNextSpecDB.sh - Get next Special dbname from $TEMP_PATH/RUspecDBs.txt.
#	2/28/23.	wmk.
#
# Entry. *ix = current index into RUspecDBs.txt
#		 *csvname imported from caller
#		 $TEMP_PATH/RUspecDBs.txt = list of RU/Special .dbs
#
# Exit.  *ix = *ix++
#		 *csvname = next name from $TEMP_PATH/RUspecDBs.txt
#		 setcsv.sh generated to set *csvname
#
# Modification History.
# ---------------------
# 2/28/23.	wmk.	original shell.
#
# Notes.

if [ -z "$csvname" ];then
 echo " ** missing *csvname in GetNextSpecDB **"
 exit 1
fi
if ! test -f $TEMP_PATH/RUspecDBs.txt;then
 echo " ** missing *TEMP/PATH/RUspecDBs.txt in GetNextSpecDB **"
 exit
fi
mawk -F "/" '{if(NR == ENVIRON["ix"]){print "#!/bin/bash";print "csvname=" substr($12,1,length($12)-3)}}' \
 $TEMP_PATH/RUspecDBs.txt > setcsv.sh
chmod +x setcsv.sh
export ix=$((ix+1))
echo "run . ./setcsv.sh to set *csvname."
# end GetNextSpecDB
