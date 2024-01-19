#!/bin/bash
echo " ** AnySQtoSH.sh out-of-date **";exit 1
# AnySQtoSH.sh - Convert any .sq to .sh shell.
#	5/12/23.    wmk.
#
#	Usage. bash AnySQLtoSQ <path> <filename-base> [<preamble>] [<postscript>]
#		<path> = path to <filename-base>.sql file
#		<filename-base> = filename without .sql type-suffix
#		[<preamble>] = (optional) shell preamble for SQL must be ' ' if
#			no preamble, but postscript is needed.
#		[<postscript>] = (optional) shell postscript for SQL
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/12/23.	wmk.	<postscript> support (see Notes.).
# Legacy mods.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	*bashpath corrected; comments tidied.
# 4/26/23.	wmk.	bug fix *codebase support missing.
# Legacy mods.
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 6/26/22.	wmk.	"preamble" feature; if <path>/<preamble> exists, it
#			 is considered to be *bash shell statements that should be
#			 inserted just prior to the SQLTemp generation statements.
# 6/27/22.	wmk.	PRAMB misspelling corrected to PREAMB.
# 7/19/22.	wmk.	remove trailing '/' from P1 if present.
# Legacy mods.
# 11/27/21.	wmk.	original shell; adapted from AnySQLtoSQ.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# 4/23/22.	wmk.	minor code cleanup.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
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
P3=$3
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "AnySQtoSH <path> <filename-base> [<preamble>] [<postscript>] missing parameter(s) - abandoned."
 exit 1
fi
len=${#P1}
len1=$((len-1))
len2=$((len-2))
lastchar=${srcpath:len1:1}
if [ "$lastchar" == "/" ];then
 src=${P1:0:len2}
else
 src=$P1
fi
if [ -z "$P3" ];then
 PREAMB=
elif [ "$P3" == "nofile" ];then
 PREAMB=$P3
else
 PREAMB=$src/$P3
 if ! test -f $PREAMB;then
  echo "preamble = '$PREAMB'"
  echo "AnySQtoSH <path> <filename-base> [<preamble>] [<postscript>] preamble not found - abandoned."
  exit 1
 fi
fi
if [ -z "$P4" ];then
 PSCRIPT=
else
 PSCRIPT=$src/$P4
 if ! test -f $PSCRIPT;then
  echo "postscript = '$PSCRIPT'"
  echo "AnySQtoSH <path> <filename-base> [<preamble>] [<postscript>] postscript not found - abandoned."
  exit 1
 fi
fi
echo "PREAMB = '$PREAMB'"
echo "PSCRIPT = '$PSCRIPT'"
FSRC=.sq
FTARG=.sh
srcpath=$src/$P2$FSRC
targpath=$P1/$P2$FTARG
bashpath=$codebase/Procs-Dev
if [ ! -z "$PREAMB" ];then
	cat $bashpath/hdrAnySQL_1.sh   $PREAMB \
      $srcpath $bashpath/hdrAnySQL_2.sh > $targpath
else
	cat $bashpath/hdrAnySQL_1.sh   \
      $srcpath $bashpath/hdrAnySQL_2.sh > $targpath
fi
sed -i "s?<filename>?$P2?g" $targpath
# if postscript present, insert after "sqlite3 <" statement.
if [ "$P4" != "" ];then
 sed -i "/sqlite3 </r $src/$P4" $targpath
fi
echo "AnySQtoSH" "$P2.sh generated"
#end proc
bash ~/sysprocs/LOGMSG "  AnySQtoSH $P1/$P2 complete."
echo "   AnySQtoSH complete."
