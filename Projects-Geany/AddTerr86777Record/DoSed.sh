#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - perform sed modifications of MakeAddTerr86777Record.
#	6/5/22.	wmk.
#	Usage.	bash DoSed.sh <propid> m1 d1
#		<propid> = property ID of record to add
#		m1 d1 = month day of SCPA full download to extract record from
#
#	Entry.
#		DoSed.sh needs to run in the project base folder BuildSCDiff
#		AddNVenAllRec.psq is the SQL source for getting/adding the record
#		MakeAddNVenAllRecord.tmp is the makefile template
#
#	Exit.
#		AddNVenAllRec.sql is the edited SQL with the property ID and
#		 download date inserted
#		MakeAddNVenAllRecord is the makefile
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	original code; adapted from MakeAddNVenAllRecord.
#
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " Must specify <property ID> mm dd.. DoSed terminated."
 exit 1
fi
if [ -z "folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase = $folderbase/Territories/FL/SARA/86777
fi
projpath=$codebase/Projects-Geany/AddTerr86777Record
echo "{s?m1?$P2?g;s?d1?$P3?g;s?wwww?$P1?g}" > $projpath/sedatives.txt
sed -f $projpath/sedatives.txt  $projpath/MakeAddTerr86777Record.tmp \
 > $projpath/MakeAddTerr86777Record
echo "s?folderbase?$folderbase?g" >> $projpath/sedatives.txt
sed -f $projpath/sedatives.txt $projpath/Add86777Rec.psq > $projpath/Add86777Rec.sql
echo "  DoSed complete."
# end DoSed
