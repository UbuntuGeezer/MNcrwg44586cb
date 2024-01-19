#!/bin/bash
echo " ** DoSed.sh out-of-date **";exit 1
echo " ** DoSed.sh out-of-date **";exit 1
# DoSed.sh - perform sed modifications of MakeSCNewTerritory.
#	5/23/23.	wmk.
#
#	Usage.	bash DoSed.sh <terrid> [ m2 d2 ]
#		<terrid> = territory ID
#		m2 = (optional) latest SC download month
#		d2 = (optional) lastest SC download day
#
# 	Exit.	MakeSCNewTerritory modified with territory ID and download date.
#		pathSCdefs.i modified with territory ID.
#
# Modification History.
# --------------------
# 1/14/23.	wmk.	add m 2, d 2 parameters back in and edit SCNewImport.psq > .sql.
# 5/23/23.	wmk.	bug fix add *P2=, *P3= missing statements; update defaults
#			 to 04 04.
# Legacy mods.
# 4/25/22.	wmk.	checked for FL/SARA/86777
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# Legacy mods.
# 5/8/21.	wmk.	original code.
# 8/10/21.	wmk.	comments added.
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ]; then
 echo " DoSed <terrid> [ m2 d2 ] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 echo " m2 d2 not specified - defaulting to 01 13..."
 read -p "  accept defaults (Y/N)? "
 yn=${REPLY^^}
 if [ "$yn" == "Y" ];then
  echo "  continuing with m2=01 d2=13..."
  P2=04
  P3=04
 else
  echo "DoSed terminated at user request."
  exit 1
 fi
fi
echo "{s/yyy/$P1/g;s/@@/$P2/g;s/zz/$P3/g}" > sedative.txt
sed -f sedative.txt MakeSCNewTerritory.tmp > MakeSCNewTerritory
sed -f sedative.txt SCNewImport.psq > SCNewImport.sql
echo "s/xxx/$P1/g" > sedative.txt
sed -f sedative.txt pathSCdefs.i > pathSCdefs.inc

