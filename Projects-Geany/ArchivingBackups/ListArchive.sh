#!/bin/bash
# ListArchive.sh - Update IncDump* files where .sh and (no extension) differ.
#	5/5/22.	wmk.
#
# Usage. bash  ListArchive.sh <mountname> [index]
#
#	<mountname> = flashdrive mount name ($U_DISK)/ prefix assumed)
#	index	= (optional) A/B index where duplicate mount names are possible
#
# Exit. ls of all folders/files on <mountname>
#			> *U_DISK/<mountname>/<mountname><index>FullList
#			> /ArchivingBackups/<mountname><index>FullList
#
# Modification History.
# ---------------------
# 5/5/22.	wmk.	original code.
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "ListArchive <mountname> [index] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if ! test -d $U_DISK/$P1;then
 echo "Flash drive $P1 not mounted..."
 read -p "Mount then enter 'Y' to continue: "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  echo "ListArchive abandoned at user request."
  exit 0
 fi
fi
if [ "$P1" == "Lexar" ];then
 read -p "Lexar name not unique - specify which one (A/B): "
 abspec=${REPLY^^}
 if [ "$abspec" != "A" ] && [ "$abspec" != "B" ];then
   echo "** WARNING Lexar $abspec not a known drive... **"
 fi
 P2=$abspec
fi
listname0=$P1$P2
fulllist=FullList
listname=$listname0$fulllist
# do it twice to pick up the full list file in the list..
ls -R $U_DISK/$P1 > $pathbase/Projects-Geany/ArchivingBackups/$listname
cp -p $pathbase/Projects-Geany/ArchivingBackups/$listname $U_DISK/$P1
ls -R $U_DISK/$P1 > $pathbase/Projects-Geany/ArchivingBackups/$listname
cp -pv $pathbase/Projects-Geany/ArchivingBackups/$listname $U_DISK/$P1
echo "ListArchive $P1 $P2 complete."
#end ListArchive
