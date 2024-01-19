#!/bin/bash
# MigrateRecipes.sh - Migrate makefile recipes for ".sh" files to CB system.
#	11/26/22.	wmk.
#
# Usage. bash MigrateRecipes.sh  <terrid>
#
#	<terrid> = territory ID
#
# Exit.	*pathbase/*scpath/Terr*<terrid>/MakeRegenSpecDB, MakeSetSpecTerrs,
#		 MakeSyncTerrToSpec copied to same names ".bak" and
#		 modified to build ".sh" files using awkMakeFixes.txt directives.
#
# Modification History.
# ---------------------
# 11/26/22.	wmk.	original code;
#
P1=$1		# territory ID
if [ -z "$P1" ];then
 echo "MigrateRecipes <terrid> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
projpath=$codebase/Projects-Geany/MigrateSCSpecToCB
# Note. there are no <shell-name> references within these files so the
#  *seds* are needed.
#sed "s?<terrid>?$P1?g" $projpath/awkMakefixes.tmp > $projpath/awkMakefixes.txt
cd $pathbase/$scpath/Terr$P1
grep -e "(automated) main .sh" MakeRegenSpecDB
if [ $? -eq 0 ];then
 echo "   MakeRegenSpecDB main recipe already fixed - skipping."
else
 cp -pv MakeRegenSpecDB     MakeRegenSpecDB.bak
 sed 's?<shell-name>?RegenSpecDB?g' $projpath/awkRecipefixes.tmp \
   > $projpath/awkRecipefixes.txt
 sed 's?<shell-name>?RegenSpecDB?g' $projpath/MakeRecipe.tmp \
   > $projpath/MakeRecipe.txt
 mawk -f $projpath/awkRecipefixes.txt MakeRegenSpecDB > MakeRegenSpecDB.new
 cp -pv MakeRegenSpecDB.new MakeRegenSpecDB
fi
grep -e "(automated) main .sh" MakeSetSpecTerrs
if [ $? -eq 0 ];then
 echo "   MakeSetSpecTerrs main recipe already fixed - skipping."
else
 cp -pv MakeSetSpecTerrs    MakeSetSpecTerrs.bak
 sed 's?<shell-name>?SetSpecTerrs?g' $projpath/awkRecipefixes.tmp \
   > $projpath/awkRecipefixes.txt
 sed 's?<shell-name>?SetSpecTerrs?g' $projpath/MakeRecipe.tmp \
   > $projpath/MakeRecipe.txt
 mawk -f $projpath/awkRecipefixes.txt MakeSetSpecTerrs > MakeSetSpecTerrs.new
 cp -pv MakeSetSpecTerrs.new MakeSetSpecTerrs
fi
grep -e "(automated) main .sh" MakeSyncTerrToSpec
if [ $? -eq 0 ];then
 echo "   MakeSyncTerrToSpec main recipe already fixed - skipping."
else
 cp -pv MakeSyncTerrToSpec  MakeSyncTerrToSpec.bak
 sed 's?<shell-name>?SyncTerrToSpec?g' $projpath/awkRecipefixes.tmp \
   > $projpath/awkRecipefixes.txt
 sed 's?<shell-name>?SyncTerrToSpec?g' $projpath/MakeRecipe.tmp \
   > $projpath/MakeRecipe.txt
 mawk -f $projpath/awkRecipefixes.txt MakeSyncTerrToSpec > MakeSyncTerrToSpec.new
 cp -pv MakeSyncTerrToSpec.new MakeSyncTerrToSpec
fi
echo "  MigrateRecipes complete."
# end MigrateRecipes.sh
