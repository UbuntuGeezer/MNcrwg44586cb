# pathdefs.i - template for pathRUdefs.inc via sed editing.
#	7/16/21.	wmk.
#
# Modification History.
# ---------------------
# 4/29/21.	wmk.	original include defs.
# 5/27/21.	wmk.	modified to use folderbase var.
# 6/6/21.	wmk.	bug fix ifeq check needing ".
# 6/19/21.	wmk.	whichsystem conditional replaced.
# 7/5/21.	wmk.	superfluous "s removed.
# 7/16/21.	wmk.	prepath var added for preprocessing support.

# check folderbase and set according to system.
ifeq ($(HOME),/home/ubuntu)
 folderbase = /media/ubuntu/Windows/Users/Bill
else
 folderbase = $(HOME)
endif

vpath %.db $(folderbase)/Territories/RawData/RefUSA/RefUSA-Downloads/Terr244
vpath %.csv $(folderbase)/Territories/RawData/RefUSA/RefUSA-Downloads/Terr244
vpath %.sql $(folderbase)/Territories/RawData/RefUSA/RefUSA-Downloads/Terr244
bashpath = $(folderbase)/Territories/Procs-Dev/
prepath = $(folderbase)/Territories/RawData/RefUSA/RefUSA-Downloads/Terr244/
postpath = $(folderbase)/Territories/RawData/RefUSA/RefUSA-Downloads/Terr244/
RUQBpath = $(folderbase)/Territories/Queries-SQL/RefUSA-Build/
TSBpath = $(folderbase)/Territories/Procs-Build/
