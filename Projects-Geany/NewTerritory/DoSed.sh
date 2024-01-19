#!/bin/bash
#DoSed.sh - perform sed modifications of MakeNewTerritory.
#	4/27/23.	wmk.
#	Usage.	bash DoSed.sh <terrid> [<state> <county> <congo>]
#
#		<terrid> = territory ID; if only creating cong territory
#			this is set to ' ' so it is non-empty
#		<state> = (optional) 2 char state abbreviation
#		<county> = (optional) 4 char county abbreviation
#		<congno> = (optional) congregation number
#
# Modification History.
# ---------------------
# 1/21/23.	wmk.	change to edit MakePubTerr.tmp.
# 4/27/23.	wmk.	MakeDefineCongTerr.tmp reintroduced.
# Legacy mods.
# 5/8/21.	wmk.	original code; from MakeRUNewTerritory.
# 6/17/21.	wmk.	modified for MakeNewTerritory.
# 4/1/22.	wmk.	<state> <county> <congno> parameters support.
P1=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ]; then
 echo " DoSed - territory - must be specified - aborted."
 exit 1
fi
if [ ! -z "$P2" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "DoSed <terrid> <state> <county> <congno> - missing parameter(s) - abandoned."
  exit 1
 fi
fi
echo "s/yyy/$P1/g" > sedatives.txt
sed -f sedatives.txt MakePubTerr.tmp > MakePubTerr
sed -f sedatives.txt CheckTerrDefined.psq > CheckTerrDefined.sql
echo "s?<state>?$P2?g;s?<county>?$P3?g;s?<congno>?$P4?g" >> sedatives.txt
sed -f sedatives.txt MakeDefineCongTerr.tmp > MakeDefineCongTerr
# end DoSed
