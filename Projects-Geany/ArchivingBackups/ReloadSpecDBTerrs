#!/bin/bash
# ReloadSpecDBTerrs.sh - Reload all territories using <spec-db>.
#	12/15/22.	wmk.
#
# Usage. bash ReloadSpecDBTerrs.sh <spec-db>
#
#	<spec-db> = /Special/<spec-db>.db for which to reload dependent territories.
#
# Exit. All terrtories dependent upon <spec-db>.db incrementally reloaded
#
# Notes. Uses ListDBTerrs to generate list of territories to reload.
P1=$1		# <spec-db>
P2=$2		# -u
P3=$3		# <mount-name>
#echo "ReloadSpecDBTerrs <spec-db> -u <mount-name> not yet implmented."
#echo "  Reload the following territories manually.."
$pathbase/$rupath/Special/ListDBTerrs.sh $P1
mawk '{print substr($1,5,3)}' $TEMP_PATH/DBTerrList.txt > TerrReloadList.txt
cat TerrReloadList.txt
projpath=$codebase/Projects-Geany/ArchivingBackups
file=$projpath/TerrReloadList.txt
while read -e;do
 TID=${REPLY:0:3}
 $projpath/ReloadFLTerr.sh $TID ! $P2 $P3
done < $file
echo "Territories reloaded..."
cat TerrReloadList.txt
# end ReloadSpecDBTerrs.sh
