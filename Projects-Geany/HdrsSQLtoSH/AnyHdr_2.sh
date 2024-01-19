#endprocbody.
echo " ** AnyHdr_2.sh out-of-date **";exit 1
echo " ** AnyHdr_2.sh out-of-date **";exit 1
# begin SCSpecTerr_db.hd2
#jumpto TrySQL
#TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
#jumpto TestEnd
#TestEnd:
~/sysprocs/LOGMSG "  SCSpecTerr_db $P1 (Dev) $TST_STR complete."
echo "SCSpecTerr_db $P1 (Dev) $TST_STR complete."
# end SCSpecTerr_db.hd2
