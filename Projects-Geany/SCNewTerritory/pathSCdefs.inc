# pathdefs.i - template for pathSCdefs.inc via sed editing.
#	1/14/23.	wmk.
#
# Dependencies. var folderbase set by calling module prior to include.
#
# Modification History.
# ---------------------
# 1/14/23.	wmk.	*codebase support.
# Legacy mods.
# 4/25/22.	wmk.	modified for FL/SARA/86777
# Legacy mods.
# ??		wmk.	original include.
# 6/17/21.	wmk.	multihhost support.
# 8/27/21.	wmk.	superfluous "s removed.

vpath %.db $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr807
vpath %.csv $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr807
bashpath = $(codebase)/Procs-Dev
postpath = $(pathbase)/RawData/SCPA/SCPA-Downloads/Terr807
RUQBpath = $(codebase)/Queries-SQL/SCPA-Build
TSBpath = $(codebase)/Procs-Build
