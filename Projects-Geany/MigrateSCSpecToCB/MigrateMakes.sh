#!/bin/bash
# MigrateMakes.sh - Migrate makefiles to CB system.
#	11/26/22.	wmk.
#
# Usage. bash MigrateMakes.sh  <terrid>
#
#	<terrid> = territory ID
#
# Exit.	*pathbase/*scpath/Terr*<terrid>/MakeRegenSpecDB, MakeSetSpecTerrs,
#		 MakeSyncTerrToSpec, MakeSpecials copied to same names ".bak" and
#		 modified with *codebase, *procpath, *bashpath vars and references
#		 corrected.
#
# Modification History.
# ---------------------
# 11/25/22.	wmk.	original code;
# 11/26/22.	wmk.	add check if previously run to each *mawk.
#
P1=$1		# territory ID
if [ -z "$P1" ];then
 echo "MigrateMakes <terrid> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
projpath=$codebase/Projects-Geany/MigrateSCSpecToCB
# Note. there are no <terrid> references within any of these makefiles so the
#  *sed* is not needed... just included for reference.
#sed "s?<terrid>?$P1?g" $projpath/awkMakefixes.tmp > $projpath/awkMakefixes.txt
cd $pathbase/$scpath/Terr$P1
grep -e "(automated) correct \*procpath" MakeRegenSpecDB
if [ $? -eq 0 ];then
 echo "   MakeRegenSpecDB *procpath already fixed - skipping."
else
 cp -pv MakeRegenSpecDB     MakeRegenSpecDB.bak
 mawk -f $projpath/awkMakefixes.txt MakeRegenSpecDB > MakeRegenSpecDB.new
 cp -pv MakeRegenSpecDB.new MakeRegenSpecDB
fi
grep -e "(automated) correct \*procpath" MakeSetSpecTerrs
if [ $? -eq 0 ];then
 echo "   MakeSetSpecTerrs *procpath already fixed - skipping."
else
cp -pv MakeSetSpecTerrs    MakeSetSpecTerrs.bak
 mawk -f $projpath/awkMakefixes.txt MakeSetSpecTerrs > MakeSetSpecTerrs.new
 cp -pv MakeSetSpecTerrs.new MakeSetSpecTerrs
fi
grep -e "(automated) correct \*procpath" MakeSyncTerrToSpec
if [ $? -eq 0 ];then
 echo "   MakeSyncTerrToSpec *procpath already fixed - skipping."
else
 cp -pv MakeSyncTerrToSpec     MakeSyncTerrToSpec.bak
 mawk -f $projpath/awkMakefixes.txt MakeSyncTerrToSpec > MakeSyncTerrToSpec.new
 cp -pv MakeSyncTerrToSpec.new MakeSyncTerrToSpec
fi
grep -e "(automated) correct \*procpath" MakeSpecials
if [ $? -eq 0 ];then
 echo "   MakeSpecials *procpath already fixed - skipping."
else
 cp -pv MakeSpecials     MakeSpecials.bak
 mawk -f $projpath/awkMakefixes.txt MakeSpecials > MakeSpecials.new
 cp -pv MakeSpecials.new MakeSpecials
fi
echo "  MigrateMakes complete."
# end MigrateMakes.sh
