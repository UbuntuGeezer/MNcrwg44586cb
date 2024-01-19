#!/bin/bash
echo " ** AnySQLtoSQ.sh out-of-date **";exit 1
# AnySQLtoSQ.sh - Fix any .sql file making it a shell with suffix .sq.
#	10/5/22.	wmk.
#	Usage. bash AnySQLtoSQ <path> <filename-base>
#		<path> = path to <filename-base>.sql file
#		<filename-base> = filename without .sql type-suffix
#	Note: <path> is a path WITHOUT '/' at ending
#
# Dependencies.
#
# Modification History.
# ---------------------
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied.
# Legacy mods.
# 4/25/22.	wmk.	modified for use with FL/SARA/86777;*pathbase* included.
# 4/26/22.	wmk.	bug fix -z in folderbase check;HOME changed to USER.
# 5/17/22.	wmk.	notify-send eliminated.
# Legacy mods.
# 8/29/21.	wmk.	original shell.
# 9/15/21.	wmk.	superfluous "s removed.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#echo "in FixAnyRU; systemlog: '$system_log'"
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "AnySQLtoSQ <path> <filename-base> missing parameter - abandoned."
 exit 1
fi
FSRC=.sql
FTARG=.sq
srcpath=$P1/$P2$FSRC
targpath=$P1/$P2$FTARG
#	echo "targpath = '$targpath'"
if test -f $targpath/$FN$P1.tmp;then
 rm $targpath/$FN$P1.tmp
fi
sed 's?\"?\\\"?g' $srcpath > $targpath
sed -i 's?^?echo \"?g' $targpath
sed -i 's?$?\"  >> SQLTemp.sql?g' $targpath
sed -i '1s?>>?>?g' $targpath
echo "AnySQLtoSQ" "$P2.sq generated"
#end proc
bash ~/sysprocs/LOGMSG "  AnySQLtoSQ $P1/$P2 complete."
echo "   AnySQLtoSQ complete."
