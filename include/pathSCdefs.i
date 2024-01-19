# pathSCdefs.i
#	8/16/23.	wmk.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adpated for MN/CRWG/44586.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use FL/SARA/86777.
# Legacy mods.
# 5/27/21.	wmk.	modified for multihost use.
# 6/18/21.	wmk.	added folderbase var set.
# 6/19/21.	wmk.	comments standardized.
# 6/27/21.	wmk.	superfluous "s removed.
# 7/2/21.	wmk.	SCQpath added.
# 7/3/21.	wmk.	prepath added for build preprocessing support.

ifndef folderbase
 ifeq ($(USER),ubuntu)
  folderbase = /media/ubuntu/Windows/Users/Bill
 else
  folderbase = $(HOME)
 endif
endif

ifndef pathbase
 pathbase = $(folderbase)/MN/CRWG/44586
endif

vpath %.db $(pathbase)/RawData/SCPA/SCPA-Downloads/Terryyy
vpath %.csv $(pathbase)/RawData/SCPA/SCPA-Downloads/Terryyy
dirbase = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terryyy/
bashpath = $(pathbase)/Procs-Dev
prepath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terryyy
postpath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terryyy
SCbase = $(pathbase)/RawData/SCPA/SCPA-Downloads/
SCQpath=$(pathbase)/Queries-SQL/SCPA-Queries
