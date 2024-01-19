#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# AnySQtoSQL.sh - Convert any SQ bash query to SQL.
# 6/18/22.	wmk.
#	Usage. bash AnySQtoSQL <filepath> <filename>
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
# 6/18/22.	wmk.	bug fix sedatives.txt unqualified in *sed* command.
# Legacy mods.
# 4/6/21.	wmk.	original shell.
# 5/30/21.	wmk.	modified for multihost system suppor
# 12/26/21.	wmk.	folderbase fixed for multihost; notify-send conditional.
# 3/19/22.	wmk.	also correct "  >>" and "  >" SQLTemp.txt lines.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase="$folderbase"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1			# <sqfilepath> 
P2=$2			# <filebase>
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "AnySQtoSQL <sqfilepath> <filebase> missing parameter(s) - abandoned."
 exit 1
fi
SUFX1=".sq"
SUFX2=".sql"
TER="Terr"
local_debug=0	# set to 1 for debugging
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  bash ~/sysprocs/LOGMSG "   AnySQtoSQL $P2 initiated from Make."
  echo "   AnySQtoSQL $P2 initiated."
else
  bash ~/sysprocs/LOGMSG "   AnySQtoSQL $P2 initiated from Terminal."
  echo "   AnySQtoSQL initiated."
fi
  TEMP_PATH="$HOME/temp"
#procbodyhere
#sed -i '1i\#!/bin/bash\'  $sql_base$P1/$P2$SUFX2
sql_base=$P1
proc_path=$codebase/Procs-Dev
proj_path=$codebase/Projects-Geany/AnySHtoSQL
echo "s/$P2/<filename>/g" > $proj_path/sedatives.txt
echo 's/\\\"/\"/g' >> $proj_path/sedatives.txt
echo "{s/echo \"//g;s/\"  >> SQLTemp.sql//g;1 s/> SQLTemp.sql//;}" >> $proj_path/sedatives.txt
echo 's?\" >> SQLTemp.sql??g' >> $proj_path/sedatives.txt
echo "s?\"  > SQLTemp.sql??g" >> $proj_path/sedatives.txt
echo "s?\" > SQLTemp.sql??g" >> $proj_path/sedatives.txt
sed -f $proj_path/sedatives.txt $sql_base/$P2$SUFX1 > $sql_base/$P2$SUFX2
#endprocbody
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
~/sysprocs/LOGMSG "  AnySQtoSQL $P2 complete."
echo "  AnySQtoSQL $P2 complete."
#end AnySQtoSQL
exit 0
#  dead code removed from above.
# change all quote surrounded fields to have escapes
# change all ^ to 'echo "'
# change 1st endline to '" > SQLTemp.sql'
# change subsequent endlines to '" >> SQLTemp.sql'
# change all ^ to 'echo "'
# end AnySQtoSQL.sh
