#
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#preQGet.sh
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
NAME_PRFX="QTerr$TID"
DB_END=".db"
CSV_END=".csv"
DB_NAME="$NAME_PRFX$DB_END"
CSV_NAME="$NAME_PRFX$CSV_END"
TBL_NAME1="$NAME_PRFX"
#echo $DB_NAME
#end preQGet.sh
#
