# DoSed.sh - *sed edit .psq files to .sql files.
#
# Usage. bash  DoSed.sh <spec-db.db>
#
#	<spec-db.db> = full special db name (e.g. AvenidaEstancias.db)
#
# Exit. "<spec-db>" replaced with P1 in:
#		OutofDates.psq -> OutofDates.sql
#		CreateDiffs.psq -> CreateDiffs.sql
#		UpdtSpecSCBridge.psq -> UpdtSpecSCBridge.sql
#
# Modification History.
# ---------------------
# 1/31/23.	wmk.	original code.
#
P1=$1
if [ -z "$P1" ]; then
 echo " DoSed - <spec-db.db> missing parameter(s) - abandoned."
 read -p echo "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
echo "s/<spec-db>/$P1/g" > sedative.txt
sed -f sedative.txt OutofDates.psq > OutofDates.sql
sed -f sedative.txt CreateDiffs.psq  >  CreateDiffs.sql
sed -f sedative.txt UpdtSpecSCBridge.psq  >  UpdtSpecSCBridge.sql
echo "DoSed complete."
# end DoSed
