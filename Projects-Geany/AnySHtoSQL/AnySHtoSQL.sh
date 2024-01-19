#/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#AnySHtoSQL.sh - Convert any SQL query to shell program.
# 12/26/21.	wmk.
#	Usage. bash AnySHtoSQL <filepath> <filename>
#		<filepath> = path of .sh file to convert
#		<filename> = base name file to convert (.sh assumed)
#               target file is <filename>.sq
#
# Dependencies.
#	source for <filename>.sql must be folder ~/Queries-SQL/Utilities-DB-SQL
#	file2 will have header.sh lines 1-33 copied to front,
#		34-end copied to back with appropriate editing convering sql
#		source lines to echoed batch commands.
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell
# 5/30/21.	wmk.	modified for multihost system support.
# 12/26/21.	wmk.	bug fixes with folderbase.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ "$USER" = "ubuntu" ]; then
 folderbase=$folderbase
else 
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
P2=$2
SUFX1=".sh"
SUFX2=".sq"
TER="Terr"
local_debug=0	# set to 1 for debugging
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  bash ~/sysprocs/LOGMSG "   AnySHtoSQL initiated from Make."
  echo "   AnySHtoSQL initiated."
else
  bash ~/sysprocs/LOGMSG "   AnySHtoSQL initiated from Terminal."
  echo "   AnySHtoSQL initiated."
fi
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories
 else
  export pathbase=$folderbase/Territories
 fi
fi
# end pathbase block.
TEMP_PATH="$HOME/temp"

if [ -z "$P1" ]; then
  echo "  AnySHtoSQL ignored.. must specify <file>." >> $system_log #
  echo "  AnySHtoSQL ignored.. must specify <file>."
  exit 1
fi 

#procbodyhere
# change all quote surrounded fields to have escapes
# change all ^ to 'echo "'
# change 1st endline to '" > SQLTemp.sql'
# change subsequent endlines to '" >> SQLTemp.sql'
# change all ^ to 'echo "'
sql_base=$P1
proc_path=$codebase/Procs-Dev
projpath=$codebase/Projects-Geany/AnySHtoSQL
echo "#!/bin/bash" > $projpath/DoSed1.sh
echo "s/$P2/<filename>/g" > $projpath/sedatives.tmp
echo 's/\\\"/\"/g' >> $projpath/sedatives.tmp
echo "{s/echo \"//g;s/\" >> SQLTemp.sql//g;1 s/> SQLTemp.sql//;}" >> sedatives.tmp
echo "sed -f sedatives.tmp $sql_base/$P2$SUFX1 > $proc_path/$P2$SUFX2" >> DoSed1.sh
bash $projpath/DoSed1.sh
#sed -i '1i\#!/bin/bash\'  $sql_base$P1/$P2$SUFX2
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
 notify-send "AnySHtoSQL" "complete - $P1"
fi~/sysprocs/LOGMSG "  AnySHtoSQL complete."
echo "  AnySHtoSQL complete."
#end AnySHtoSQL
