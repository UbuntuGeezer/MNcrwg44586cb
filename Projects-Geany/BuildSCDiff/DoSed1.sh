#!/bin/bash
echo " ** DoSed1.sh out-of-date **";exit 1
echo " ** DoSed1.sh out-of-date **";exit 1
#DoSed1.sh - perform sed modifications of MakeExtractDiff.
#	6/16/23.	wmk.
#	Usage.	bash DoSed1.sh m1 d1 m2 d2
#		m1 d1 = month day of previous SCPA full download
#		m2 d2 = month day of current SCPA full download
#
#	Entry.
#		DoSed1.sh needs to run in the project base folder BuildSCDiff
#		ExtractDownDiff.sql is the SQL source for extracting the differences
#		MakeExtractDiff.tmp is the makefile template
#
#	Exit.
#		preamble.sh is the initial portion of the build ExtractSCDiff.sh
#		  shell that performs the differenct extraction with the
#		  m1 d1 m2 d2 parameters substituted into the environment vars
#		MakeExtractDiff is the template MakeExtractDiff.tmp file
#		  modified with m1 d1 m2 d2 substituted in the build directives
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 4/25/23.	wmk.	*terrdflt set to FL/SARA/86777.
# 6/16/23.	wmk.	error messages improved.
# Legacy mods.
# 4/27/22.	wmk.	modified for general use; FL/SARA/86777; *pathbase*
#			 support; *terrdflt* dependency added; HOME changed to USER
#			 in host check.
# 5/26/22.	wmk.	*sed* Extract Diff Build menu item documented; host
#			 check bug fixed.
# Legacy mods.
# 6/19/21.	wmk.	original code.
# 6/26/21.	wmk.	minor corrections.
#
# Notes. DoSed1 is the "executable" for the "sed ExtractDiff Build" Build
# menu item. None of the *sed* Build menu items edit any of the ExtractDownDiff
# files. They are edited by the MakeExtractDiff makefile.
P1=$1
P2=$2
P3=$3
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ]; then
 echo " BuildSCDiff/DoSed1 m1 d1 m2 d2 missing parameter(s) - abandoned."
 exit 1
fi
export terrdflt=FL/SARA/86777
if [ -z "$terrdflt" ];then
 echo "*terrdflt* not defined - DoSed1 abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
echo "{s/m1/$P1/g;s/d1/$P2/g;s/m2/$P3/g;s/d2/$P4/g}" > sedative.txt
sed -f sedative.txt preamble.s > preamble.sh
sed -f sedative.txt  MakeExtractDiff.tmp > MakeExtractDiff
sleep 1
echo "  DoSed1 complete."

# end DoSed1
