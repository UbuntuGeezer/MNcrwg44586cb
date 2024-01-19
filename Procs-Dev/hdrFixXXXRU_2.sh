#hdrFixXXXRU_2 here...
echo " ** hdrFixXXXRU_2.sh out-of-date **";exit 1
# 9/4/21. Note. jumptos eliminated; reactivate if debugging...
# 9/18/21. pushd/popd eliminated.
# 3/12/23. notify-send eliminated.
#end proc body

sqlite3 < SQLTemp.sql
# now run RUTidyTerr_db.sh to tidy up fixes.
#bash /media/ubuntu/Windows/Users/Bill/Territories/Procs-Dev/RUTidyTerr_db.sh XXX
echo "  Terr XXX PostProcessing complete."
bash ~/sysprocs/LOGMSG "   $FN$P1$RU complete."
echo "   $FN$P1$RU complete."
#end proc

