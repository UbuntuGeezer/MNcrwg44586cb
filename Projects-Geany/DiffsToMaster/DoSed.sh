#!/bin/bash
#DoSed.sh - perform sed modifications of MakeDiffsToMaster.
#	1/23/23.	wmk.
#
#	Usage.	bash DoSed.sh m2 d2
#		m2 d2 = month day of current SCPA full download
#
#	Entry.
#		*terrdflt* environment var set.
#		DoSed1.sh needs to run in the project base folder BuildSCDiff
#		ExtractDownDiff.sql is the SQL source for extracting the differences
#		MakeBuildSCDiff.tmp is the makefile template
#
#	Exit.
#		preamble.sh is the initial portion of the build ExtractSCDiff.sh
#		  shell that performs the differenct extraction with the
#		  m1 d1 m2 d2 parameters substituted into the environment vars
#		MakeBuildSCDiff is the template MakeExtractDiff.tmp file
#		  modified with m1 d1 m2 d2 substituted in the build directives
#		BuildDiffAccts.sql is the BuildDiffAccts.psq file with the
#		  m1 d1 m2 d2 parameters substituted into the SQL statements.
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 1/14/23.	wmk.	NoTerrIDs.psq added to edit list.
# Legacy mods.
# 4/27/22.	wmk.	modified for general use; FL/SARA/86777; *pathbase*
#			 support; *terrdflt* dependency added.
# 4/30/22.	wmk.	BuildDiffAccts.psq >  BuildDiffAccts.sql added.
# 5/1/22.	wmk.	ExtractDownDiffs0426.psq added to *sed* list.
# 6/30/22.	wmk.	bug fix *terrdflt check; bug fix *sed not editing
#			 MakeExtractDiff.tmp > MakeExtractDiff; add MakeBuildDiffAccts.tmp
#			 > MakeBuildDiffAccts to edit list.
# Legacy mods.
# 6/19/21.	wmk.	original code.
# 1/2/22.	wmk.	use $ USER for host test.
# 3/19/22.	wmk.	add edit of SCDwnldToDB.psq > SCDwnldToDB.sql.
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ]; then
 echo " Must specify m2 d2.. DoSed terminated."
 exit 1
fi
if [ -z "${terrdflt}" ];then
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
echo "{s/m2/$P1/g;s/d2/$P2/g}" > sedative.txt
#sed -f sedative.txt preamble.s > preamble.sh
sed -f sedative.txt DiffsToMaster.psq > DiffsToMaster.sql
if test -f ExtractDownDiff.psq;then
 sed -f sedative.txt DiffsToMaster.psq > DiffsToMaster.sql
 echo "*sed* built DiffsToMaster.sql..."
fi
echo "  DoSed complete."

# end DoSed
