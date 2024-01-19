#hdrFixXXXRU_2 here...
# 9/4/21. Note. jumptos eliminated; reactivate if debugging...
# 9/18/21. pushd/popd eliminated.
#end proc body

sqlite3 < SQLTemp.sql
# now run RUTidyTerr_db.sh to tidy up fixes.
#bash /media/ubuntu/Windows/Users/Bill/Territories/Procs-Dev/RUTidyTerr_db.sh XXX
notify-send "FixXXXRU.sh" "Terr XXX PostProcessing complete. $P1"
echo "  Terr XXX PostProcessing complete."
bash ~/sysprocs/LOGMSG "   $FN$P1$RU complete."
echo "   $FN$P1$RU complete."
#end proc

