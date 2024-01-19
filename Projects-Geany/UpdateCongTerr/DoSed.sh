#!/bin/bash
#DoSed.sh - performs sed(s) for UpdateNVenAll build.
#	6/15/23.	wmk.
#
# Usage.	DoSed.sh m1 d1 m2 d2
#	m2 = month of most recent download/differences .db
#
# Entry. DiffsToCongTerr.sh built from DiffsToCongTerr.sql
#
# Exit. SCNewVsCongTerr.sql > SCNewVsCongTerr.sq
#		MakeUpdateCongTerr.tmp > MakeUpdateCongTerr
#		CreateNewSCPA.psq > CreateNewSCPA.sql
#		BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
#		MakeCreateNewSCPA.tmp > MakeCreateNewSCPA
#		MakeBuildDiffAcctsTbl.tmp > MakeBuildDiffAcctsTbl
#
# Modification History.
# ---------------------
# 11/27/22.	wmk.	*pathbase fixed; comments tidied.
# 4/25/23.	wmk.	MakeBuildDiffAcctsTbl.tmp added to edit list.
# 4/26/23.	wmk.	MakeReportUnassigned.tmp, ReportUnassigned.psq added.
# 5/3/23.	wmk.	change 4/26 mods to MakeReportOrphans.tmp, 
#			 ReportOrphans.psq added.
# 6/15/23.	wmk.	missing ReportOrphans *sed,s added.
# 6/16/23.	wmk.	YYYY-MM-DD replacement edited for 2023.
# Legacy mods.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# Legacy mods.
# 4/27/22.	wmk.	modified for UpdateCongTerr project.
# 5/26/22.	wmk.	bug fix; missing *TEMP_PATH* definition; edit
#			 DiffsToCongTerr.tmp -> DiffsToCongTerr instead of DiffsToNVenAll.
# Legacy mods.
# 4/26/22.	wmk.	*pathbase* support.
# 5/27/22.	wmk.	SetDiffAcctsTerrIDS.psq > .sql added.
# Legacy mods.
# 4/19/21.	wmk.	original code.
# 6/25/21.	wmk.	multihost modifications; SCNewVsNVenAll editing added.
# 7/22/21.	wmk.	BuildDiffAccts editing added.
# 8/25/21.	wmk.	CreateNewSCPA.sql/.sq build added.
# 9/29/21.	wmk.	added folderbase substitution to CreateNewSCPA.sql
#					edit; switch to using m2 d2 in CreateNewSCPA.sql.
# 11/3/21.	wmk.	sed on CreateNewSCPA.sql, BuildDiffAccts.sqlchanged 
#					to CreateNewSCPA.psq.
# 12/2/21.	wmk.	sed on MakeCreateNewSCPA.tmp added.
# 1/2/22.	wmk.	change to use USER instead of HOME in host test.
# 3/21/22.	wmk.	sed on MakeDiffsToNVenAll.tmp added.
#
P1=$1		# old month
P2=$2		# old day
P3=$3		# new month
P4=$4		# new day
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "DoSed <m1> <d1> <m2> <d2> missing parameter(s) - abandoned."
 read -p "Enter ctl-c to remain in Terminal:"
 exit 1
fi

if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
export TEMP_PATH=$HOME/temp
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
# this sed produces the sql that will actually do the update.
echo "{s/m2/$P3/g;s/d2/$P4/g;s/m2d2/$P3$P4/g}" > seddir.txt
sed -f seddir.txt DiffsToCongTerr.psq > DiffsToCongTerr.sql
#sed -f seddir.txt SetDiffAcctsTerrIDs.psq > SetDiffAcctsTerrIDs.sql
#sed '{s/m2/$P3/g;s/d2/$P4/g;s/m2d2/$P3$P4/g}' DiffsToNVenAll.sh > XDiffsToNVenAll.sh
#sed -f seddir.txt DiffsToNVenAll.sh > XDiffsToNVenAll.sh

# this sed modifies the template to create the final make file.
echo "s/mm-dd/$P3-$P4/g" > seddirs.txt
echo "s/mmdd/$P3$P4/g" >> seddirs.txt
echo "s/m1d1/$P1$P2/g" >> seddirs.txt
echo "s?m1?$P1?g" >> seddirs.txt
echo "s?d1?$P2?g" >> seddirs.txt
echo "s?mm?$P3?g" >> seddirs.txt
echo "s?dd?$P4?g" >> seddirs.txt
echo "s/YYYY-MM-DD/2023-$P3-$P4/g" >> seddirs.txt
echo "s?<congno>?$P5?g" >> seddirs.txt
sed -f seddirs.txt MakeUpdateCongTerr.tmp > MakeUpdateCongTerr

# this sed modfies SCNewVsCongTerr.psq > SCNewVsCongTerr.sql.
#				   MakeSCNewVsCongTerr.tmp > MakeSCNewVsCongTerr
#				   BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
#				   ReportOrphans.psq > ReportOrphans.sql
#				   MakeReportOrphans.tmp > MakeReportOrphans
echo "s?mm?$P3?g" > sedatives.txt
echo "s?dd?$P4?g" >> sedatives.txt
#echo "s?folderbase?$pathbase?g" >> sedatives.txt
sed -f sedatives.txt SCNewVsCongTerr.psq > SCNewVsCongTerr.sql
sed -f sedatives.txt MakeSCNewVsCongTerr.tmp > MakeSCNewVsCongTerr
sed -f sedatives.txt MakeReportOrphans.tmp > MakeReportOrphans
# this sed modifies BuildDiffAcctsTbl.sq > BuildDiffAcctsTbl.sql.
sed -f sedatives.txt BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
sed -f sedatives.txt MakeReportOrphans.psq > ReportOrphans.sql
#sed -f sedatives.txt DiffsToNVenAll.psq  >  DiffsToNVenAll.sql

# 5/27/22.  NOTE.
# the following sed has to edit the pre-SQL files, to correct m2 d2
# for the SQL.
# this sed modifies CreateNewSCPA.psq to create CreateNewSCPA.sql.
#  					MakeDiffsToCongTerr.psq to create MakeDiffsToCongTerr.sql
# 					MakeSetDiffAcctsTerrIDs.psq to create MakeSetDiffAcctsTerrIDs.sql.
echo "s?m2?$P3?g" > sedatives.txt
echo "s?d2?$P4?g" >> sedatives.txt
#echo "s?folderbase?$folderbase?g" >> sedatives.txt
sed -f sedatives.txt CreateNewSCPA.psq > CreateNewSCPA.sql
#sed -f sedatives.txt MakeDiffsToNVenAll.tmp > MakeDiffsToNVenAll
sed -f sedatives.txt MakeDiffsToCongTerr.tmp > MakeDiffsToCongTerr
sed -f sedatives.txt MakeBuildDiffAcctsTbl.tmp > MakeBuildDiffAcctsTbl
sed -f sedatives.txt ReportOrphans.psq > ReportOrphans.sql
sed -f sedatives.txt MakeReportOrphans.tmp > MakeReportOrphans
#sed -f sedatives.txt MakeSetDiffAcctsTerrIDs.tmp > MakeSetDiffAcctsTerrIDs

# 12/2/21.	NOTE.
# the following sed edits the MakeCreateNewSCPA.tmp, inserting the
# month and day from P3 and P4 into the makefile. It uses the
# sedatives.txt from the previous sed for CreateNewSCPA.psq.
#sed -f sedatives.txt MakeCreateNewSCPA.tmp > MakeCreateNewSCPA

# 12/3/21.	NOTE.
# the following sed edits the QSCPADiff.psq, inserting the month/day
# values from P1 through P4 into the SQL to produce the file
# QSCPADiff.sql for further processing.
echo "s?m1?$P1?g" >> sedatives.txt
echo "s?d1?$P2?g" >> sedatives.txt
sed  -f sedatives.txt $codebase/Procs-Dev/QSCPADiff.psq \
 > $codebase/Procs-Dev/QSCPADiff.sql

# 4/27/22.	NOTE.
# DoSed now builds DiffsToCongTerr.sh from the newly edited
# DiffsToCongTerr.sql
# end DoSed
otherproj=$codebase/Projects-Geany/AnySQLtoSH
thisproj=$codebase/Projects-Geany/UpdateCongTerr
pushd ./ > $TEMP_PATH/scratchfile
cd $otherproj
./DoSed.sh $thisproj DiffsToCongTerr
make -f $otherproj/MakeAnySQLtoSH
popd > $TEMP_PATH/scratchfile
# end DoSed.
