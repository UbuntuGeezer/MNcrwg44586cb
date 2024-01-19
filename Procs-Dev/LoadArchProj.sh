#!/bin/bash
echo " ** LoadArchProj.sh out-of-date **";exit 1
# LoadArchProj - Initial load of Projects-Geany/ArchivingBackups project.
#	7/31/22.	wmk.
#
# Usage. LoadArchProj <subsys> [-t]
#
#	<subsys> = subsystem name; if -t option present is <state><cong><congno>
#				otherwise subsystem root folder name (e.g. Accounting)
#	-t (optional) - Territories flag; if present LoadArchProj will search for filename
#		<state><county><congno> derived from *PWD folder name
#		(e.g. *PWD = *HOME/Territories/<state>/<county>/<congno> will trigger search for
#		 ./<state><county><congno>Geany.0.tar ArchivingBackups files
#
# Dependencies. MUST be run from susbystem root folder.
#
P1=$1
P2=${2,,}
if [ -z "$P1" ];then
 echo "LoadArchProj <subsys> [-t] missing parameter(s) - abaondoned."
 exit 1
fi
isTerr=0
if [ ! -z "$P2" ];then
 if [ "$P2" != "-t" ];then
  echo "LoadArchProj $P1 $P2  unrecognized option - abandoned."
  exit 1
 fi
 isTerr=1
fi
src_path=$PWD
if [ $isTerr -eq 0 ];then
 if [ "$HOME/$P1" != $PWD ];then
  echo $PWD
  echo "$HOME/$P1 does not match present working directory - abaondoned."
  exit 1
 fi
else
 ckname=${P1^^}
 state=${ckname:0:2}
 county=${ckname:2:4}
 congno=${ckname:6:10}
 if [ "$HOME/Territories/$state/$county/$congno" != "$PWD" ];then
  echo $PWD
  echo  "$HOME/Territories/$state/$county/$congno does not match present working directory - abandoned."
  exit
 fi
fi
# source path for .tar is always present working directory.
# .tar filename is Geany.0.tar
#  or <subsys>Geany.0.tar if -t
if [ $isTerr -eq 0 ];then
 src_file=Geany.0.tar
else
 geany=Geany
 src_file=$ckname$geany.0.tar
fi
# debugging code.
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "src_path = : '$src_path'"
echo "src_file = : '$src_file'"
echo "end parameter test"
#exit
#proc
tar --extract \
    --wildcards \
    -f $src_file Projects-Geany/ArchivingBackups*
#endproc
echo "LoadArchProj complete."
~/sysprocs/LOGMSG "  LoadArchProj $P1 $P2  complete."
# end LoadArchProj
