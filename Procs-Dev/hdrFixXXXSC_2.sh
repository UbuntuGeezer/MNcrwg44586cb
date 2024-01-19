# hdrFixXXXSC_2 here--
echo " ** hdrFixXXXSC_2.sh out-of-date **";exit 1
# 3/12/23. wmk. notify-send eliminated.
popd   > $TEMP_PATH/bitbucket.txt
#end proc body

# conditional to skip SQL execution.
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
# now run SCTidyTerr_db.sh to tidy up fixes.
bash $folderbase/Territories/Procs-Dev/SCTidyTerr_db.sh XXX
jumpto EndProc
EndProc:
#popd >> $TEMP_PATH/bitbucket.txt
echo "~/sysprocs/LOGMSG \" FixXXXSC PostProcessing complete. $P1\" "
echo "  Terr XXX PostProcessing complete."
#end proc
