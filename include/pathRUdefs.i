# pathdefs.i - template for pathRUdefs.inc via sed editing.
#	8/16/23.	wmk.
#
# Modification History.
# ---------------------
# 8/16/23.	wmk.	adapted for MN/CRWG/44586.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use FL/SARA/86777.
# 5/5/22.	wmk.	trailing '/' dropped from *bashpath* def.
# Legacy mods.
# 4/29/21.	wmk.	original include defs.
# 5/27/21.	wmk.	modified to use folderbase var.
# 6/6/21.	wmk.	bug fix ifeq check needing ".
# 6/19/21.	wmk.	whichsystem conditional replaced.
# 7/5/21.	wmk.	superfluous "s removed.
# 7/16/21.	wmk.	prepath var added for preprocessing support.

# check folderbase and set according to system.
ifndef folderbase
 ifeq ($(USER),ubuntu)
  folderbase = /media/ubuntu/Windows/Users/Bill
 else
  folderbase = $(HOME)
 endif
endif

ifndef pathbase
 pathbase = "$(folderbase)/MN/CRWG/44586
endif

vpath %.db $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
vpath %.csv $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
vpath %.sql $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
bashpath = $(pathbase)/Procs-Dev
prepath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
postpath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
RUQBpath = $(pathbase)/Queries-SQL/RefUSA-Build
TSBpath = $(pathbase)/Procs-Build
