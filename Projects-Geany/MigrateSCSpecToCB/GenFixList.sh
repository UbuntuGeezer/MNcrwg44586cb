#!/bin/bash
# GenFixList.sh - Generate list of SC special territories to fix.
#	11/25/22.	wmk.
projpath=$codebase/Projects-Geany/MigrateSCSpecToCB
cd $pathbase/$scpath
find -iname "Spec*.db" > $projpath/TerrFixList.txt
# end GenFixList.sh
