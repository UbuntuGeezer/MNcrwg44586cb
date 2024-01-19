
echo " ** hdrAnySQL_2.sh out-of-date **";exit 1
#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  <filename> complete."
~/sysprocs/LOGMSG "  <filename> complete."
#end proc
