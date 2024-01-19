#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# DoSed.sh - perform sed modifications of MakeAddSCBridgeRecord.
#	6/18/22.	wmk.
#
#	Usage.	bash DoSed.sh <propid> <terrid>
#		<propid> = property ID of record to add
#		<terrid> = territory ID for Bridge table
#
#	Entry.
#		DoSed.sh needs to run in the project base folder AddSCBridgeRecord
#		AddSCBridgeRec.psq is the SQL source for getting/adding the record
#		MakeAddSCBridgeRecord.tmp is the makefile template
#
#	Exit.
#		AddSCBridgeRec.sql is the edited SQL with the property ID and
#		 territory ID inserted
#		MakeSCBridgeRecord is the makefile
#
# Modification History.
# ---------------------
# 9/22/21.	wmk.	original code.
# 6/18/22.	wmk.	folderbase improvments; eliminate *sed* folderbase edit.

P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " Must specify <property ID>  <terrid>.. DoSed terminated."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
echo "{s?yyy?$P2?g;s?wwww?$P1?g}" > sedatives.txt
sed -f sedatives.txt  MakeAddSCBridgeRecord.tmp > MakeAddSCBridgeRecord
sed -f sedatives.txt AddSCBridgeRec.psq > AddSCBridgeRec.sql
echo "  DoSed complete."
# end DoSed
