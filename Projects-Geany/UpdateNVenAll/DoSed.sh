#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#DoSed.sh - performs sed(s) for UpdateNVenAll build.
#	4/26/22.	wmk.
#
# Usage.	DoSed.sh m1 d1 m2 d2
#	m2 = month of most recent download/differences .db
#
# Exit. DiffsToNVenAll.sh > XDiffsToNVenAll.sh
#		SCNewVsNVenall.sql > SCNewVsNVenall.sq
#		MakeUpdateNVenAll.tmp > MakeUpdateNVenAll
#		CreateNewSCPA.psq > CreateNewSCPA.sql
#		BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
#		MakeCreateNewSCPA.tmp > MakeCreateNewSCPA
#
# Modification History.
# ---------------------
# 4/26/22.	wmk.	*pathbase* support.
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
# this sed produces the shell that will actually do the update.
echo "{s/m2/$P3/g;s/d2/$P4/g;s/m2d2/$P3$P4/g}" > seddir.txt
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
echo "s/YYYY-MM-DD/2021-$P3-$P4/g" >> seddirs.txt
sed -f seddirs.txt MakeUpdateNVenAll.tmp > MakeUpdateNVenAll

# this sed modfies SCNewVsNVenall.psq > SCNewVsNVenall.sql.
#				   BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
echo "s?mm?$P3?g" > sedatives.txt
echo "s?dd?$P4?g" >> sedatives.txt
#echo "s?folderbase?$pathbase?g" >> sedatives.txt
sed -f sedatives.txt SCNewVsNVenall.psq > SCNewVsNVenall.sql
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
sed  -f sedatives.txt $folderbase/Territories/Procs-Dev/QSCPADiff.psq \
 > $folderbase/Territories/Procs-Dev/QSCPADiff.sql
# end DoSed

