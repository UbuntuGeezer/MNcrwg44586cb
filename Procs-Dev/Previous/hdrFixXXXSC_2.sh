# hdrFixXXXSC_2 here--
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
bash $folderbase/Territories/Procs-Dev/SCTidyTerr_db.sh XXX
jumpto EndProc
EndProc:
#popd >> $TEMP_PATH/bitbucket.txt
notify-send "FixXXXsc.sh" "Terr XXX PostProcessing complete. $P1"
echo "~/sysprocs/LOGMSG \" FixXXXSC PostProcessing complete. $P1\" "
echo "  Terr XXX PostProcessing complete."
#end proc
