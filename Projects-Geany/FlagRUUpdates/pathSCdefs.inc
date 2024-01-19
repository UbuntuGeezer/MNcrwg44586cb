# pathSCdefs.i
#	4/25/22.	wmk.
#
# Modification History.
# ---------------------
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
 pathbase = $(folderbase)/FL/SARA/86777
endif

vpath %.db $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr104
vpath %.csv $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr104
dirbase = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr104/
bashpath = $(pathbase)/Procs-Dev
prepath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr104
postpath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr104
SCbase = $(pathbase)/RawData/SCPA/SCPA-Downloads/
SCQpath=$(pathbase)/Queries-SQL/SCPA-Queries
