#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed1.sh - perform sed modifications of MakeAddSCBridgeRecord.
#	5/24/23.	wmk.
#
#	Usage.	bash DoSed1.sh <propid>  <spec-db> [<terrid>]
#		<propid> = property ID of record to add
#		<spec-db> = special db base name (e.g. Aria)
#		<terrid> = (optional) territory ID for Bridge table
#
#	Entry.
#		DoSed1.sh needs to run in the project base folder AddSCBridgeRecord
#		AddSpecSCBridgeRec.psq is the SQL source for getting/adding the record
#		MakeAddSpecSCBridgeRecord.tmp is the makefile template
#
#	Exit.
#		AddSpecSCBridgeRec.sql is the edited SQL with the property ID and
#		 territory ID inserted
#		MakeAddSpecSCBridgeRecord is the makefile
#
# Modification History.
# ---------------------
# 5/24/23.	wmk.	original code; DoSed1 adapted from DoSed.
# Legacy mods.
# 9/22/21.	wmk.	original code.
# 6/18/22.	wmk.	folderbase improvments; eliminate *sed* folderbase edit.
# P1 = property ID; P2 = <spec-db>; [P3] =(optional)  <terrid> for new record
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " DoSed1 <property ID>  <sped-db> missing parameter(s) -  DoSed1 terminated."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
echo "{s?yyy?$P3?g;s?vvvvv?$P2?g;s?wwww?$P1?g}" > sedatives.txt
sed -f sedatives.txt  MakeAddSpecSCBridgeRecord.tmp > MakeAddSpecSCBridgeRecord
sed -f sedatives.txt AddSpecSCBridgeRec.psq > AddSpecSCBridgeRec.sql
echo "  DoSed1 complete."
# end DoSed1
