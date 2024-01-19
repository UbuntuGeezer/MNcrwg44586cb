# specpathdefs.inc - /Special path defs for SpecialSCdb build.
#	6/5/22.	wmk.
#
# Dependencies. var folderbase set by calling module prior to include.
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	original code; adapted from pathSCdefs.inc
# Legacy mods.
# ??		wmk.	original include.
# 6/17/21.	wmk.	multihhost support.
# 8/27/21.	wmk.	superfluous "s removed.

vpath %.db $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Special
vpath %.csv $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Special
bashpath = $(folderbase)/Territories/Procs-Dev/
postpath = $(folderbase)/Territories/RawData/SCPA/SCPA-Downloads/Special
RUQBpath = $(folderbase)/Territories/Queries-SQL/SCPA-Build
TSBpath = $(folderbase)/Territories/Procs-Build
