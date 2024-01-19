#!/bin/bash
echo " ** AddNVenAllRec.sh out-of-date **";exit 1
echo " ** AddNVenAllRec.sh out-of-date **";exit 1
echo ""  AddNVenAllRec 0405050027  03 19 initiated."" 
~/sysprocs/LOGMSG '  AddNVenAllRec 0405050027  03 19 initiated.'
sqlite3 < /media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/AddNVenAllRecord/AddNVenAllRec.sql
echo ""  AddNVenAllRec 0405050027  03 19 complete."" 
~/sysprocs/LOGMSG '  AddNVenAllRec 0405050027  03 19 complete.'
