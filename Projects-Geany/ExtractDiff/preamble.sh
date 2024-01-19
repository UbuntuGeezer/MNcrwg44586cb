#preamble.s - Preamble shell for setting up SQL converted shell.
#	11/21/22.	wmk.
#
# Modification History.
# ---------------------
# 11/21/22.	wmk.	*codebase support.
# Legacy mods.
# 4/17/21.	wmk.	original code.
# 6/19/21.	wmk.	folderbase added.
# 9/30/21.	wmk.	ensure 01 13 04 04 used throughout.
# 3/19/22.	wmk.	HOME changed to USER in host test.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# 01
#P2=$2		# 13
#P3=$3		# 04
#P4=$4		# 04
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	folderbase = base path of host system for Territories
#-- *	SCPA_CSV = SCPA-Public_01-13.csv with 01 13 substituted
#-- *	SCPA_DB1 = SCPA_01-13.db with 01 13 substituted 
#-- * 	SCPA_TBL1 = Data0113 with 0113 substituted
#-- *	SCPA_DB2 = SCPA_04-04.db with 04 04 substituted
#-- *	SCPA_TBL2 = Data0404 with 0404 substituted
#-- *	DIFF_DB = SCPADiff_04-04.db with 04 04 substituted
#-- *	DIFF_TBL = Diff0404 with 04 04 substituted
#-- *	M2D2 = "04-04" with 04 04 substituted
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
export SCPA_CSV="SCPA-Public_01-13.csv"
export SCPA_DB1="SCPA_01-13.db"
export SCPA_TBL1="Data0113"
export SCPA_DB2="SCPA_04-04.db"
export SCPA_TBL2="Data0404"
export DIFF_DB="SCPADiff_04-04.db"
export DIFF_TBL="Diff0404"
export M2D2="04-04"
echo "SCPA_DB1 : '$SCPA_DB1'"
# end preamble.s
