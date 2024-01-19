#!/bin/bash
# TarFileDate.sh - List file modified date from tar archive.
# 8/16/23.	wmk.
#
# Usage. bash  TarFileDate.sh <tarchive> <filespec> [<mount-name>]
#
#	<tarchive> = tar archive name (e.g. *congterr/tarfile)
#	<filespec> = filespec to list dates for
#	<mount-name> = (optional) USB drive mount name
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MNcrwg44586.
# Legacy mods.
# 11/22/22.	wmk.	mod to support system-resident .tar files.
# 11/24/22.	wmk.	missing paramter(s) handled with improved message.
# Legacy mods.
# 10/12/22.	wmk.	original code.
# 10/13/22.	wmk.	parameter checking; join templist.txt lines.
# 10/30/22.	wmk.	bug fix forgot -i in *sed* joining lines.
# 11/14/22.	wmk.	optional <mount-name> parameter support; Lexar default.
#tar -x -f /mnt/chromeos/removable/Lexar/FLSARA86777/CBTerr111.0.tar --to-command='date -d @$TAR_MTIME > #tdate; echo "$TAR_FILENAME" > tfile; cat tfile  tdate'  -- TerrData/Terr111/Terr111_PubTerr.pdf
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "TarFileDate <tarchive> <filespec> <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$folderbase" ];then
 export folderbase=$HOME
fi
if [ -z "$pathbase" ];then
 export folderbase=$HOME/Terrritories/MN/CRWG/44586
fi
if [ -z "$codebase" ]; then
 export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
fi
dump_path=$U_DISK/$P3
tar -x -f $dump_path/$P1 --to-command='date -d @$TAR_MTIME > tdate; echo "$TAR_FILENAME  " > tfile;cat tfile  tdate'  -- $P2 > templist.txt
sed -i '1{N;s/\n//;}' templist.txt
cat templist.txt
# end TarFileDate.sh
