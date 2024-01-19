#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - performs sed(s) for ImportSCPA build.
#	6/26/22.	wmk.
#
# Usage.	DoSed.sh m2 d2
#
#	m2 = month of most recent download
#	d2 = day of most recent download
#
# Entry. *pathbase* = Territory system base path
#
# Exit. 
#		MakeImportSCPA.tmp > MakeImpordSCPA
#		CreateNewSCPA.psq > CreateNewSCPA.sql
#		PopulateCongTerr.psq > PopulateCongTerr.sql
#
# Modification History.
# ---------------------
# 4/27/22.	wmk.	original code.
# 4/29/22.	wmk.	MakePopulateAllAccts copy added.
# 5/1/22.	wmk.	<congno> added to sedatives.
# 5/26/22.	wmk.	add echo for CreateNewSCPA.sql.
# 6/30/22.	wmk.	empty parameters check added.
#
P3=$1		# new month
P4=$2		# new day
if [ -z "$P3" ] || [ -z "$P4" ];then
 echo "DoSed <mm> <dd> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
# this sed produces the sql that will actually do the update.
#echo "{s/m2/$P3/g;s/d2/$P4/g;s/m2d2/$P3$P4/g}" > seddir.txt
echo "s/m2/$P3/g;s/d2/$P4/g" > sedatives.txt
echo "s?<congno\>?86777?g" >> sedatives.txt
sed -f sedatives.txt PopulateCongTerr.psq > PopulateCongTerr.sql
sed -f sedatives.txt CreateNewSCPA.psq > CreateNewSCPA.sql
echo "CreateNewSCPA.psq --> CreateNewSCPA.sql"
sed -f sedatives.txt MakeCreateNewSCPA.tmp > MakeCreateNewSCPA
sed -f sedatives.txt MakePopulateCongTerr.tmp > MakePopulateCongTerr
sed -f sedatives.txt MakeImportSCPA.tmp > MakeImportSCPA
cp -pv PopulateAllAccts.psq PopulateAllAccts.sql
cp -pv MakePopulateAllAccts.tmp MakePopulateAllAccts


if [ 1 -eq 1 ];then
 echo "DoSed complete."
 exit 0
fi

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
echo "s/YYYY-MM-DD/2022-$P3-$P4/g" >> seddirs.txt
echo "s?<congno>?$P5?g" >> seddirs.txt
sed -f seddirs.txt MakeUpdateCongTerr.tmp > MakeUpdateCongTerr

# this sed modfies SCNewVsCongTerr.psq > SCNewVsCongTerr.sql.
#				   BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
echo "s?mm?$P3?g" > sedatives.txt
echo "s?dd?$P4?g" >> sedatives.txt
#echo "s?folderbase?$pathbase?g" >> sedatives.txt
sed -f sedatives.txt SCNewVsCongTerr.psq > SCNewVsCongTerr.sql
# this sed modifies BuildDiffAcctsTbl.sq > BuildDiffAcctsTbl.sql.
sed -f sedatives.txt BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
sed -f sedatives.txt DiffsToNVenAll.psq  >  DiffsToNVenAll.sql

# 11/3/21.  NOTE.
# the following sed has to edit the pre-SQL file, to correct m2 d2
# for the SQL.
# this sed modifies CreateNewSCPA.psq to create CreateNewSCPA.sql.
echo "s?m2?$P3?g" > sedatives.txt
echo "s?d2?$P4?g" >> sedatives.txt
#echo "s?folderbase?$folderbase?g" >> sedatives.txt
sed -f sedatives.txt CreateNewSCPA.psq > CreateNewSCPA.sql
sed -f sedatives.txt MakeDiffsToNVenAll.tmp > MakeDiffsToNVenAll

# 12/2/21.	NOTE.
# the following sed edits the MakeCreateNewSCPA.tmp, inserting the
# month and day from P3 and P4 into the makefile. It uses the
# sedatives.txt from the previous sed for CreateNewSCPA.psq.
sed -f sedatives.txt MakeCreateNewSCPA.tmp > MakeCreateNewSCPA

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
