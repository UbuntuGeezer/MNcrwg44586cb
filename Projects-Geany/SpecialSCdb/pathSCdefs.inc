# specpathdefs.inc - /Special path defs for SpecialSCdb build.
#	11/26/22.	wmk.
#
# Dependencies. var folderbase set by calling module prior to include.
#
# Modification History.
# ---------------------
# 11/26/22.	wmk.	*codebase dependent paths corrected.
# Legacy mods.
# 6/5/22.	wmk.	original code; adapted from pathSCdefs.inc
# Legacy mods.
# ??		wmk.	original include.
# 6/17/21.	wmk.	multihhost support.
# 8/27/21.	wmk.	superfluous "s removed.

vpath %.db $(pathbase)/RawData/SCPA/SCPA-Downloads/Special
vpath %.csv $(pathbase)/RawData/SCPA/SCPA-Downloads/Special
bashpath = $(codebase)/Procs-Dev/
postpath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Special
RUQBpath = $(codebase)/Queries-SQL/SCPA-Build
TSBpath = $(codebase)/Procs-Build
