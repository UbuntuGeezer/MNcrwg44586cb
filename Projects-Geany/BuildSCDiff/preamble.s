#preamble.s - Preamble shell for setting up SQL converted shell.
#	3/19/22.	wmk.
#
# Modification History.
# ---------------------
# 4/17/21.	wmk.	original code.
# 6/19/21.	wmk.	folderbase added.
# 9/30/21.	wmk.	ensure m1 d1 m2 d2 used throughout.
# 3/19/22.	wmk.	HOME changed to USER in host test.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# m1
#P2=$2		# d1
#P3=$3		# m2
#P4=$4		# d2
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	folderbase = base path of host system for Territories
#-- *	SCPA_CSV = SCPA-Public_m1-d1.csv with m1 d1 substituted
#-- *	SCPA_DB1 = SCPA_m1-d1.db with m1 d1 substituted 
#-- * 	SCPA_TBL1 = Datam1d1 with m1d1 substituted
#-- *	SCPA_DB2 = SCPA_m2-d2.db with m2 d2 substituted
#-- *	SCPA_TBL2 = Datam2d2 with m2d2 substituted
#-- *	DIFF_DB = SCPADiff_m2-d2.db with m2 d2 substituted
#-- *	DIFF_TBL = Diffm2d2 with m2 d2 substituted
#-- *	M2D2 = "m2-d2" with m2 d2 substituted
#-- *
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else
  export folderbase="$HOME"
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
export SCPA_CSV="SCPA-Public_m1-d1.csv"
export SCPA_DB1="SCPA_m1-d1.db"
export SCPA_TBL1="Datam1d1"
export SCPA_DB2="SCPA_m2-d2.db"
export SCPA_TBL2="Datam2d2"
export DIFF_DB="SCPADiff_m2-d2.db"
export DIFF_TBL="Diffm2d2"
export M2D2="m2-d2"
echo "SCPA_DB1 : '$SCPA_DB1'"
# end preamble.s
