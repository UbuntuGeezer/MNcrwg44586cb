#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeAddNVenAllRecord.
#	9/22/21.	wmk.
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
# 9/22/21.	wmk.	original code.

P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
 echo " Must specify <property ID> mm dd.. DoSed terminated."
 exit 1
fi
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
echo "{s?m1?$P2?g;s?d1?$P3?g;s?wwww?$P1?g}" > sedatives.txt
sed -f sedatives.txt  MakeAddNVenAllRecord.tmp > MakeAddNVenAllRecord
echo "s?folderbase?$folderbase?g" >> sedatives.txt
sed -f sedatives.txt AddNVenAllRec.psq > AddNVenAllRec.sql
echo "  DoSed complete."

# end DoSed
