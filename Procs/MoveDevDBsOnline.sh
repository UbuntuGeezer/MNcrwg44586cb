#!/bin/bash
#MoveDevDBsOnline.sh - Move development DBs online.
#	11/9/20.	wmk.
#
# bash MoveDevDBsOnline -backup bupath
#
#	-backup = -b or -B - backup online DBs prior to moving Dev DBs
#
#	bupath = target path/drive for backup
#
#	Entry Dependencies.
#	user assumed to be on base path for Territories
#   base path for Territories DB access is assumed to be
#		/media/ubuntu/Windows/Users/Bill/Territories
#	path for online DBs is assumed to be
#		../DB
#	path for development DBs is assumed to be
#		../DB-Dev
#	bupath actively mounted if backups selected
#	.critical = file containing db list to backup
#
#	Exit Results.
#	The following databases will be [backed up and] copied
#
#	Modification History.
#	---------------------
#	11/9/20.	wmk.	original shell; adapted from BU-Critical.sh
#
#	Notes.
# include this boilerplate
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
date +%T >> $system_log #
echo "  MoveDevDBsToOnline initiated." >> $system_log #
echo "  MoveDevDBsToOnline initiated."
if [ -z $2 ]; then
 FD=''
else
 FD=$2
fi
if [ -z $1 ]; then
	echo "*** WARNING - Continuing will overwrite the exiting online DBs ***"
	read -p "Do you wish to continue (Y/N)? "
	if [ -z $REPLY ]; then
		echo "  MoveDevDBsOnline abandoned - user wants to backup first." >> $system_log
		echo "  MoveDevDBsOnline abaondoned - suggest backup DBs first."
		exit 0 
	fi
	if [ $REPLY == 'y' ] || [ $REPLY == 'Y' ]; then
		echo "  Proceeding with MoveDevDBsOnline..."
		jumpto NoBackup
	else
		echo "  MoveDevDBsOnline abandoned - user wants to backup first." >> $system_log
		echo "  MoveDevDBsOnline abandoned - suggest backup DBs first."
		exit 0 
	fi
else
  if [ $1 == '-b' ] || [ $1 == '-B' ]; then
	if [ -z $FD ]; then
	echo -e "Backup drive-spec not specified...BU-Critical abandoned." >> $system_log #
	echo -e "Backup drive-spec must be specified...\nBU-Critical abandoned."
	exit 1
fi

     jumpto Backup1
  else
		echo "  unrecognized parameter $1 - MoveDevDBsOnline abandoned." >> $system_log
		echo "  unrecognized parameter $1 - MoveDevDBsOnline abandoned.."
		exit 0 
  fi  
fi
	
Backup1:
#	begin cloned shell from BU-Critical.sh
#   note. all dollar1 references changed to dollar2
MY_PROJ='Critical'
date +%T >> $system_log #
echo "  BU-Critical initiated for $MY_PROJ." >> $system_log #
echo "  BU-Critical initiated for $MY_PROJ."
if [ -z $TEMP_PATH ]; then
  TEMP_PATH=$HOME/temp
fi
echo "TEMP_PATH = '$TEMP_PATH'"

error_counter=0		# set error counter to 0
IFS="&"			# set & as the word delimiter for read.
if [ -z $FD ]; then
  echo -e "Backup drive-spec not specified...BU-Critical abandoned." >> $system_log #
  echo -e "Backup drive-spec must be specified...\nBU-Critical abandoned."
  exit 1
fi
pushd ./   >> $TEMP_PATH/scratchfile
if cd $U_DISK/$FD/$PJ_BACK/$MY_PROJ ; then
 popd      >> $TEMP_PATH/scratchfile
else
 date +%T >> $system_log #
 echo -e "  BU-Critical:Backup path not found...\n  BU-Critical abandoned." >> $system_log #
 echo -e "Backup path not found...\nBU-Critical abandoned."
 exit 1
fi
echo -e "BU-Critical for $MY_PROJ...\n" >> $TEMP_PATH/scratchfile
file='.critical'
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]
  then			# skip comment
   echo >> $HOME/temp/scratchfile
  else
   filespec=${REPLY:0:len}
#   cp -r -u -v ./$filespec $FD     >> $TEMP_PATH/scratchfile
   echo " cp -r -u ./DB/$filespec $U_DISK/$FD/$PJ_BACK/$MY_PROJ" >> $system_log #
   echo " cp -r -u ./DB/$filespec $U_DISK/$FD/$PJ_BACK/$MY_PROJ"
   cp  -r -u  ./DB/$filespec $U_DISK/$FD/$PJ_BACK/$MY_PROJ #   
   # check for error and increment error counter
#   error_code=${?}
   if [ $? -eq 0 ]; then  
     echo " " >> $TEMP_PATH/scratchfile
   else
     error_counter=$((error_counter+1))
     date +%T >> $system_log #
     echo -e "  BU-Critical:Error  $error_code processing $REPLY " >> $system_log #
     echo -e "  BU-Critical:Error  $error_code processing $REPLY "
   fi

fi     # end is comment line conditional
i=$((i+1))
done < $file
echo " $i .critical lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
echo " BU-Critical complete." >> $system_log
echo " BU-Critical complete."
#	end cloned shell from BU-Critical.sh
NoBackup:
# copy .critical list from DB-Dev (development) to DB (online)
echo -e "MoveDevDBsOnlne start\n" >> $TEMP_PATH/scratchfile
file='.critical'
i=0
while read -e; do
  #reading each line
  echo -e " processing $REPLY " >> $TEMP_PATH/scratchfile
  len=${#REPLY}
  len1=$((len-1))
  firstchar=${REPLY:0:1}
#  echo -e "  $firstchar\n is first char of line." >> $HOME/temp/scratchfile
  #expr index $string $substring
  if [ "$firstchar" = "#" ]
  then			# skip comment
   echo >> $HOME/temp/scratchfile
  else
   filespec=${REPLY:0:len}
#   cp -r -u -v ./DB-Dev/$filespec ./DB     >> $TEMP_PATH/scratchfile
   echo " cp -r -u ./DB-Dev/$filespec ./DB" >> $system_log #
   echo " cp -r -u ./DB-Dev/$filespec ./DB"
   cp  -r -u  ./DB-Dev/$filespec ./DB #   
   # check for error and increment error counter
#   error_code=${?}
   if [ $? -eq 0 ]; then  
     echo " " >> $TEMP_PATH/scratchfile
   else
     error_counter=$((error_counter+1))
     date +%T >> $system_log #
     echo -e "  MoveDevDBsOnline  $error_code processing $REPLY " >> $system_log #
     echo -e "  MoveDevDBsOnline  $error_code processing $REPLY "
   fi

fi     # end is comment line conditional
i=$((i+1))
done < $file
echo " $i .critical lines processed."
if [ $error_counter = 0 ]; then
  rm $TEMP_PATH/scratchfile
else
  echo "  $error_counter errors encountered - check $TEMP_PATH/scratchfile "
fi
echo " MoveDBsOnline complete." >> $system_log
echo " MoveDBsOnline complete."
