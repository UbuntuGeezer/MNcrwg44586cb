# pathdefs.i - template for pathSCdefs.inc via sed editing.
#	8/27/21.	wmk.
#
# Dependencies. var folderbase set by calling module prior to include.
#
# Modification History.
# ---------------------
# ??		wmk.	original include.
# 6/17/21.	wmk.	multihhost support.
# 8/27/21.	wmk.	superfluous "s removed.

vpath %.db $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Terrxxx
vpath %.csv $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Terrxxx
bashpath = $(folderbase)/Territories/Procs-Dev/
postpath = $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Terrxxx/
RUQBpath = $(folderbase)/Territories/Queries-SQL/SCPA-Build/
TSBpath = $(folderbase)/Territories/Procs-Build/
