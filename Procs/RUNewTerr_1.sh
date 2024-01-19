#!/bin/bash
# RUNewTerr_1.sh - Process RefUSA new territory stage 1.
#	10/10/20.	wmk.
#	10/19/20.	wmk.	RefUSA-Downloads path updated
# RUNewTerr_1 - prompt user through phase 1 of processing RefUSA
#	download into SQL database territory
#	Usage. bash RUNewTerr_1 <terrid>
#		<terrid> = territory ID (e.g. 101)
# All phase 1 operations involve LibreCalc; Until a LibreCalc/Territories
#	Library macro is written, the user will be prompted through a series
#	of bash Echo messages for each step of phase 1..
#
date +%T >> $system_log #
echo "  RUNewTerr Phase 1 started." >> $system_log #
echo "  RUNewTerr Phase 1 started."
if [ -z $1 ]; then
  echo "  Territory id not specified... RUNewTerr abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUNewTerr abandoned."
  exit 1
fi
touch $TEMP_PATH/scratchfile
error_counter=0
cd $WINCONG_PATH/Territories/RawData/RefUSA/RefUSA-Downloads
echo "  Switched to RefUSA-Downloads folder." >> $system_log #
# look for file Terxxx.csv from RefUSA...
ls Terr$1.csv
   if [ $? -eq 0 ]; then  
     echo "  Terr$1.csv found" >> $TEMP_PATH/scratchfile
   else
     error_counter=$((error_counter+1))
     date +%T >> $system_log #
     echo -e "  RUNewTerr_1:Error - Terrxxx.csv not found." >> $system_log #
     echo -e "  RUNewTerr_1:Error - Terrxxx.csv not found."
   fi
echo "  run LibreCalc and load Terr$1.csv for processing."
read -p "Press Enter when ready to continue..."
echo "  save Terr$1.csv as Terr$1.ods..."
read -p "Press Enter when ready to continue..."
echo "  change tab color to 'dark lime' and Protect sheet..."
read -p "Press Enter when ready to continue..."
echo "  move/copy sheet (copy) to end..."
echo "  remove sheet protection..."
read -p "Press Enter when ready to continue..."
echo "  tools/macros/'run macro' select Territories/Module1/ImportRefUSA..."
echo "  when macro completes, now have sheet 'Admin - Import format'..."
read -p "Press Enter when ready to continue..."
echo "  rename sheet to Terr$1_Import, and Protect sheet..."
read -p "Press Enter when ready to continue..."
echo "  move/copy sheet (copy) to end..."
echo "  remove sheet protection..."
read -p "Press Enter when ready to continue..."
echo "  tools/macros/'run macro' select Territories/Module1/RUImportToBridge..."
echo "  when macro completes, now have sheet 'Admin - Bridge format'..."
read -p "Press Enter when ready to continue..."
echo "  rename sheet to Terr$1_Bridge, and Protect sheet..."
read -p "Press Enter when ready to continue..."
echo "  Save Terr$1.ods..."
echo "  Move/Copy (copy) Terr$1_Bridge to new file 'Terr$1_Bridge.ods'"
read -p "Press Enter when ready to continue..."
echo "  Close Terr$1.ods... now in Terr$1_Bridge.ods..."
echo "  Delete header rows (4), but leave column headings..."
echo "  Save as .csv file 'Terr$1_Bridge.csv'..."
read -p "Press Enter when ready to continue..."
echo "  Close Terr$1_Bridge.csv and leave LibreCalc..."
read -p "Press Enter when ready to continue..."
echo "  RUNewTerr Phase 1 complete." >> $system_log #
echo "  RUNewTerr Phase 1 complete."
