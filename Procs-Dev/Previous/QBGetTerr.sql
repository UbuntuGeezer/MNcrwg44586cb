#procbodyhere
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
NAME_PRFX="QTerr$TID"
RU_NAME=Terr$TID
RU_SUFX=_RU.db
BR_SUFX=_RUBridge
DB_END=.db
CSV_END=.csv
DB_NAME=$NAME_PRFX$DB_END
CSV_NAME=$NAME_PRFX$CSV_END
TBL_NAME1=$NAME_PRFX
TBL_NAME2=$RU_NAME$BR_SUFX
#echo $DB_NAME
-- * QBGetTerr query as batch run.
.cd ""$pathbase""
.cd './BTerrData/Terr$TID/Working-Files'
#echo ".trace 'Procs-Dev/SQLTrace.txt'
#-- insert new code here...
# ATTACH Terrxxx_RU.db;
ATTACH '$pathbase/BRawData/RefUSA/RefUSA-Downloads'
||		'/Terr$TID/$RU_NAME$RU_SUFX'
 AS db12;
.headers ON
.mode csv
.separator ,
.output '$pathbase/BTerrData/Terr$TID/Working-Files/$TBL_NAME1.csv'
SELECT * FROM $RU_NAME$BR_SUFX
ORDER BY TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress,' '))),
  CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')-1) AS INTEGER);
#echo " ORDER BY UnitAddress;
.quit
#endprocbody
