# preamble.sh - preamble for BridgesToTerr project .sh builds.
echo " ** preamble.sh out-of-date **";exit 1
echo " ** preamble.sh out-of-date **";exit 1
#	12/5/22.	wmk.
# 7/10/23.	wmk.	db environment vars exported.
debugit=0
P1=$1
TID=$P1
TN="Terr"
export NAME_BASE=Terr
export NAME_BASE1=Terr_
export SC_DB=_SC.db
export RU_DB=_RU.db
export SC_SUFFX=_SCBridge
export RU_SUFFX=_RUBridge
# 11/29/22.	wmk.	following env vars added.
export DB1=$NAME_BASE$TID
export DB_SUFX=$SC_DB
if [ $debugit -ne 0 ];then
 echo "in premable.. environment vars follow:"
 echo "NAME_BASE = '$NAME_BASE'"
 echo "NAME_BASE1 = '$NAME_BASE1'"
 echo "SC_DB = '$SC_DB'"
 echo "RU_DB = '$RU_DB'"
 echo "SC_SUFFX = '$SC_SUFFX'"
 echo "RU_SUFFX = '$RU_SUFFX'"
 echo "DB1 = '$DB_SUFX'"
 echo "DB_SUFX = '$DB_SUFX'"
fi	# debugit
