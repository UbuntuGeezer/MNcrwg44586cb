#preamble.s - Preamble shell for setting up SQL converted shell.
echo " ** preamble.sh out-of-date **";exit 1
echo " ** preamble.sh out-of-date **";exit 1
#	3/19/22.	wmk.
#
# Modification History.
# ---------------------
# 4/17/21.	wmk.	original code.
# 6/19/21.	wmk.	folderbase added.
# 9/30/21.	wmk.	ensure 04 04 05 28 used throughout.
# 3/19/22.	wmk.	HOME changed to USER in host test.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# 04
#P2=$2		# 04
#P3=$3		# 05
#P4=$4		# 28
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	folderbase = base path of host system for Territories
#-- *	SCPA_CSV = SCPA-Public_04-04.csv with 04 04 substituted
#-- *	SCPA_DB1 = SCPA_04-04.db with 04 04 substituted 
#-- * 	SCPA_TBL1 = Data0404 with 0404 substituted
#-- *	SCPA_DB2 = SCPA_05-28.db with 05 28 substituted
#-- *	SCPA_TBL2 = Data0528 with 0528 substituted
#-- *	DIFF_DB = SCPADiff_05-28.db with 05 28 substituted
#-- *	DIFF_TBL = Diff0528 with 05 28 substituted
#-- *	M2D2 = "05-28" with 05 28 substituted
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
export SCPA_CSV="SCPA-Public_04-04.csv"
export SCPA_DB1="SCPA_04-04.db"
export SCPA_TBL1="Data0404"
export SCPA_DB2="SCPA_05-28.db"
export SCPA_TBL2="Data0528"
export DIFF_DB="SCPADiff_05-28.db"
export DIFF_TBL="Diff0528"
export M2D2="05-28"
echo "SCPA_DB1 : '$SCPA_DB1'"
# end preamble.s
