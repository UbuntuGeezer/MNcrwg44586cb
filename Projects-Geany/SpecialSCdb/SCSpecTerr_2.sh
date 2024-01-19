# begin SCSpecTerr_2.sh
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
if [ 1 -eq 1 ]; then
  jumpto TrySQL
fi
if [ true ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
echo "starting sqlite3..."
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
~/sysprocs/LOGMSG "  SCSpecTerr_db $P1 (Dev) $TST_STR complete."
echo "SCSpecTerr_db $P1 (Dev) $TST_STR complete."
# end SCSpecTerr_2.sh
