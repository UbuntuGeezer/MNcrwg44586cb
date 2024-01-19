#!/bin/bash
echo " ** UpdateBasicFiles.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# UpdateBasicFiles - Copy newer .bas files from project to /Basic folder.
#	4/24/22.	wmk.
#
# Modification History.
# ---------------------
# 3/8/22.	wmk.	original code; adapted from PutXBAModule.
# 4/24/22.	wmk.	*pathbase*, *congterr env vars included;*conglib*
#			 env var introduced.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  exportfolderbase=/media/ubuntu/Windows/Users/Bill
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
projbase=$codebase/Projects-Geany/EditBas
gitbase=$folderbase/GitHub/Libraries-Project/Territories
echo "**WARNING - all .bas files in EditBas/ folder will be copied over older files"
read -p "  in /Basic folder... Do you wish to proceed (Y/N)? "
yn=${REPLY,,}
if [ "$yn" == "n" ];then
 echo "UpdateBasicFiles abandoned."
 exit
else
 cp -uv $projbase/*.bas $folderbase/Territories/Basic 
 echo "EditBas/*.bas copied to /Basic folder."
 ~/sysprocs/LOGMSG "  UpdateBasicFiles - EditBas/*.bas copied to /Basic folder."
fi
read -p "Do you wish to remove all .bas files from /EditBas (y/n)?"
yn=${REPLY,,}
if [ "$yn" == "y" ];then
 rm *.bas;rm *.ba1
 echo " *.bas files removed from /EditBas."
 ~/sysprocs/LOGMSG " UpdateBasicFiles - *.bas files removed from /EditBas."
else
 echo " *.bas files in /EditBas retained."
 ~/sysprocs/LOGMSG " UpdateBasicFiles - *.bas files in /EditBas retained."
fi
# end UpdateBasicFiles.sh.
