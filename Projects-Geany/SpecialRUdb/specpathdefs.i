# specpathdefs.i - template for specpathdefs.inc via sed editing.
#	5/31/22.	wmk.
#
# Modification History.
#
# 5/31.22.	wmk.	original code for rebuilding /Special/vvvvv.db
#
# Note. Although DoSed will edit this file with v vvvv and y yy changed
# to P1 and P2, since there are no occurrences (yet) the file is simply
# copied to specpathdefs.inc.

# check folderbase and set according to system.
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

vpath %.db $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Special
vpath %.csv $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Special
vpath %.sql $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Special
bashpath = $(pathbase)/Procs-Dev
prepath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Special
postpath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Special
RUQBpath = $(pathbase)/Queries-SQL/RefUSA-Build
TSBpath = $(pathbase)/Procs-Build
