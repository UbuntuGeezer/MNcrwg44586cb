# pathSCdefs.inc
#	8/16/23.	wmk.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MN/CRWG/44586; bug fix in SCbase definition.
# Legacy mods.
# ??		wmk.	original code.
# 6/19/21.	wmk.	multihost support added.
# 9/3/21.	wmk.	superfluous "s removed.


ifeq ($(HOME),/home/ubuntu)
 folderbase = /media/ubuntu/Windows/Users/Bill
else
 folderbase = $(HOME)
endif

vpath %.db $(folderbase)/Territories/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/Terryyy
vpath %.csv $(folderbase)/Territories/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/Terryyy
dirbase = $(folderbase)/Territories/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/Terryyy/
bashpath = $(folderbase)/Territories/MN/CRWG/44586/Procs-Dev/
postpath = $(folderbase)/Territories/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/Terryyy/
SCbase = $(folderbase)/Territories/MN/CRWG/44586/RawData/SCPA/SCPA-Downloads/
