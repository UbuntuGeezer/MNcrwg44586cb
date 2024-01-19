# hdrFixXXXSC_2 here--
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
popd   > $TEMP_PATH/bitbucket.txt
#end proc body

# conditional to skip SQL execution.
if [ not = true ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
# now run SCTidyTerr_db.sh to tidy up fixes.
$codebase/Projects-Geany/FixAnySC/SCTidyTerr_db.sh XXX
jumpto EndProc
EndProc:
#popd >> $TEMP_PATH/bitbucket.txt
~/sysprocs/LOGMSG " FixXXXSC PostProcessing complete."
echo "  Terr XXX PostProcessing complete."
#end proc
