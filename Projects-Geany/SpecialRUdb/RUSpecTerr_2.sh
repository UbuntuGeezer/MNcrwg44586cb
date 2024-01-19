# begin RUSpecTerr_2.sh
echo " ** RUSpecTerr_2.sh out-of-date **";exit 1
echo " ** RUSpecTerr_2.sh out-of-date **";exit 1
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 3/1/23.	wmk.	notify-send removed; [true] jumpto,s removed.
jumpto TrySQL
TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
#  RUSpecTerr_db $1 (Dev) $TST_STR complete." >> $system_log #
~/sysprocs/LOGMSG "  RUSpecTerr_db $1 (Dev) $TST_STR complete."
echo "RUSpecTerr_db (Dev) $TST_STR complete."
# end RUSpecTerr_db.sh
# end RUSpecTerr_2.sh
