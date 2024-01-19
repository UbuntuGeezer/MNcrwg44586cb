#!/bin/bash
#DoSed.sh - perform sed modifications of MakeBizBridgeToTerr.
#	6828/21.	wmk.
#	Usage.	bash DoSed.sh <terrid>
P1=$1
TN="Terr"
echo "s/yyy/$P1/g" > sedative.txt
sed -f sedative.txt  MakeBizBridgeToTerr.tmp > MakeBizBridgeToTerr
echo "  DoSed complete."
