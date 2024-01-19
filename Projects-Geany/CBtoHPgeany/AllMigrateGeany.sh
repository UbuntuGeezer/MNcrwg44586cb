#!/bin/bash
echo " ** AllMigrateGeany.sh out-of-date **";exit 1
echo " ** AllMigrateGeany.sh out-of-date **";exit 1
# AllMigrateGeany.sh = Migrate all projects in ProjList.txt records.
# 4/1/22.	wmk.
#
# Usage.	bash AllMigrateGeany.sh <host>
#
# Entry. ($)folderbase/Projects-Geany/CBtoHPgeany project defined.
#        ./CBtoHPgeany/ProjList.txt has list of territories to run
#		 MigrateGeany against.
#
# Modification History.
# ---------------------
# 4/1/22.	wmk.	original code; adapted from *MigrateGeany* project.
#
# This shell migrates .geany files from a ChromeBook Linux environment
# to the HP environment running a non-persistent Linux/Ubuntu.
# The root folder assumptions are that the ChromeBook root is
# */home/vncwmk3* and the HP root is */media/ubuntu/Windows/Users/Bill*.
#
# Notes. If the user wants to include a comment in the ProjList.txt file, (i.e. line
# begins with '#'), the entire comment will be read as one word by "read", since 
# IFS is set to "&" by this script. This implies that none of the "ignore" specs,
# nor comments, contain the "&" character.
#
# This script uses the directory $TEMP_FILES to store temporary files. At the end of
# the script, all temporary files in $TEMP_FILES are removed. Temporary files are
# useful for writing information that would normally be output to the terminal, but
# that is considered irrelevant. If the bash scripts are set up so that if they terminate
# abnormally and they do not remove the temporary files, these can prove useful for
# debugging where the script failed.
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ "$USER" == "ubuntu" ]; then
 folderbase="/media/ubuntu/Windows/Users/Bill"
else 
 folderbase=$HOME
fi
if [ -z "$pathbase" ];then
 echo "** Environment var *pathbase* not set - AllMigrateGeany.sh abandoned."
 exit 0
fi
P1=$1
if [ -z "$P1" ];then
 P1=HP
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$HOME/temp"
  ~/sysprocs/LOGMSG "   AllMigrateGeany initiated from Make."
else
  ~/sysprocs/LOGMSG "   AllMigrateGeany initiated from Terminal."
fi
TEMP_PATH=$HOME/temp
#
P1=$1
#local_debug=0	# set to 1 for debugging
local_debug=1
#
if [ $local_debug = 1 ]; then
 pushd ./ > $TEMP_PATH/bitbucket.txt
 cd ~/Documents		# write files to Documents folder
fi
#proc body here
pushd ./ >> $TEMP_PATH/bitbucket.txt
cd $pathbase/Projects-Geany/CBtoHPgeany
MY_PROJ='Territories'
echo "  AllMigrateGeany beginning processing."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
#echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
file='ProjList.txt'
if ! test -f $file;then
 echo "** Cannot find file $file - AllMigrateGeany abandoned. **"
 ~/sysprocs/LOGMSG "** Cannot find file $file - AllMigrateGeany abandoned. **"
 exit 1
fi
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]; then			# skip comment
   echo $REPLY >> $HOME/temp/scratchfile
  else
   pname=${REPLY:0:len}
   bash ~/sysprocs/LOGMSG "  MigrateGeany $pname $P1 initiated."
   ./DoSed.sh $pname $P1
   make -f MakeMigrateGeany
  fi     # end is comment line conditional

i=$((i+1))
done < $file
echo " $i ProjList.txt lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
bash ~/sysprocs/LOGMSG " AllMigrateGeany $P1 complete."
echo " 	AllMigrateGeany $P1 complete."
#end AllMigrateGeany proc.
