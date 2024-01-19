#!/bin/bash
# DoSedNewSCdb.sh - *sed modifications to NewSCSpecialDB.psq.
#
# Usage. bash  DoSedNewSCdb.sh <spec-db>
#
#	<spec-db> = new special db name.
#
# Exit. SCPA-Downloads/Special/<spec-db>.db created
#		 with PropTerr table.
#
P1=$1
if [ -z "$P1" ];then
  echo "DoSedNewSCdb <spec-db> missing parameter(s) - abandoned."
  exit 1
fi
sed "s?<spec-db>?$P1?g" NewSCSpecialDB.psq > NewSCSpecialDB.sql
sed "s?<spec-db>?$P1?g" MakeNewSCSpecialDB.tmp > MakeNewSCSpecialDB
# end DoSedNewSCdb.
