#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
#DoSed.sh - perform sed modifications of MakeBuildSCDiff.
#	6/16/23.	wmk.
#
#	Usage.	bash DoSed.sh m1 d1 m2 d2
#		m1 d1 = month day of previous SCPA full download
#		m2 d2 = month day of current SCPA full download
#
#	Entry.
#		*terrdflt* environment var set.
#		DoSed1.sh needs to run in the project base folder BuildSCDiff
#		ExtractDownDiff.sql is the SQL source for extracting the differences
#		MakeBuildSCDiff.tmp is the makefile template
#		MakeBuildDiffAcctsTbl.tmp makefile template for BuildDiffAcctsTbl.sh
#		BuildDiffAcctsTbl.psq - SQL for BuildDiffAcctsTbl.sh
#
#	Exit.
#		preamble.sh is the initial portion of the build ExtractSCDiff.sh
#		  shell that performs the differenct extraction with the
#		  m1 d1 m2 d2 parameters substituted into the environment vars
#		MakeBuildSCDiff is the template MakeExtractDiff.tmp file
#		  modified with m1 d1 m2 d2 substituted in the build directives
#
# Modification History.
# ---------------------
# 6/16/23.	wmk.	MakeBuildSCDiff deactivated; SCNewVsCongTerr.psq,
#			 MakeSCNewVsCongTerr.tmp, MakeBuildDiffAcctsTbl, 
#			 BuildDiffAcctsTbl.psq editing added.
# Legacy mods.
# 4/27/22.	wmk.	modified for general use; FL/SARA/86777; *pathbase*
#			 support; *terrdflt* dependency added.
# 5/26/22.	wmk.	bug fix *terrdflt* bogus check; drop edit of MakeNewSCPAdb
#			 makefile; drop edit of SCDwnldToDB.psq.
# 5/27/22.	wmk.	add edit of SetDiffAcctsTerrIDs.psq, MakeSetDiffAcctsTerrIDs.tmp.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 6/19/21.	wmk.	original code.
# 1/2/22.	wmk.	use $ USER for host test.
# 3/19/22.	wmk.	add edit of SCDwnldToDB.psq > SCDwnldToDB.sql.
P1=$1
P2=$2
P3=$3
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ]; then
 echo " BuildSCDiff/DoSed m1 d1 m2 d2 missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$terrdflt" ];then
 echo "*terrdflt* not defined - DoSed abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else
  export folderbase="$HOME"
 fi
fi
echo "{s/m1/$P1/g;s/d1/$P2/g;s/m2/$P3/g;s/d2/$P4/g}" > sedative.txt
sed -f sedative.txt preamble.s > preamble.sh
#sed -f sedative.txt ExtractDownDiff.sql > ExtractDownDiff2.sql
#sed -f sedative.txt  MakeNewSCPAdb.tmp > MakeNewSCPAdb
#sed -f sedative.txt  MakeBuildSCDiff.tmp > MakeBuildSCDiff
sed -f sedative.txt SCNewVsCongTerr.psq > SCNewVsCongTerr.sql
sed -f sedative.txt MakeSCNewVsCongTerr.tmp > MakeSCNewVsCongTerr
sed -f sedative.txt SetDiffAcctsTerrIDs.psq > SetDiffAcctsTerrIDs.sql
sed -f sedative.txt  MakeBuildDiffAcctsTbl.tmp > MakeBuildDiffAccts
sed -f sedative.txt BuildDiffAcctsTbl.psq > BuildDiffAcctsTbl.sql
sed -f sedative.txt MakeSetDiffAcctsTerrIDs.tmp > MakeSetDiffAcctsTerrIDs
#echo "{s?MM?$P3?g;s?DD?$P4?g}" > sedative.txt
#sed -f sedative.txt  SCDwnldToDB.psq > SCDwnldToDB.sql
echo "  DoSed complete."

# end DoSed
