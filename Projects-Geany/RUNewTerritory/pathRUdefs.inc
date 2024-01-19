# pathdefs.i - template for pathRUdefs.inc via sed editing.
# 2/20/23.	wmk.
# Modification History.
# ---------------------
# 4/25/22.	wmk.	modified to use *pathbase* env var; *..path* vars
#			 trailing / dropped.
# 2/20/23.	wmk.	*codebase support.
# Legacy mods.
# 6/1/21.	wmk.	original code
# 8/27/21.	wmk.	superfluous "s removed.
# 2/26/22.	wmk.	change to use $ folderbse var.
vpath %.db $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terr642
vpath %.csv $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terr642
bashpath = $(codebase)/Procs-Dev
postpath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terr642
RUQBpath = $(codebase)/Queries-SQL/RefUSA-Build
TSBpath = $(codebase)/Procs-Build
