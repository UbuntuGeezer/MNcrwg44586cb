#!/bin/bash
echo " ** CopyXBAoverBAS.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# CopyXBAoverBAS - Copy project .bas code over /Basic .bas code.
#	4/24/22.	wmk.
#
# Usage.	bash CopyXBAoverBAS.sh <basfile>
#
#	<basfile> = filename of project source .bas to copy
#
# Exit.	/Basic/<basfile>.bas updated from EditBas/<basfile>.bas
#
# Modification History.
# ---------------------
# 3/7/22.	wmk.	original code.
# 3/8/22	wmk.	description clarified.
# 4/24/22.	wmk.	*pathbase* env var included.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
  export folderbase=/media/ubuntu/Windows/Users/Bill
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
P1=$1
if [ -z "$P1" ];then
 echo "** missing <basmodule> - CopyXBAoverBAS abandoned.**"
 exit 1
fi
cd $codebase/Projects-Geany/EditBas
if ! test -f $P1.bas;then
 echo "** file EditBas/$P1.bas not found for copy - CopyXBAoverBAS abandoned.**"
fi
if [ $P1.bas -nt $pathbase/Basic/$P1.bas ];then
 cp -u $P1.bas $pathbase/Basic/$P1.bas
 echo "$P1.bas udated in /Basic folder."
 ~/sysprocs/LOGMSG "  CopyXBAoverBAS - $P1.bas been updated in /Basic folder from EditBas project."
else
 echo "**EditBas/$P1.bas copy skipped - /Basic file is not older.**"
 ~/sysprocs/LOGMSG "**$ CopyXBAoverBAS EditBas/$P1.bas copy skipped - /Basic file is not older.**"
fi
# end CopyXBAoverBAS.
