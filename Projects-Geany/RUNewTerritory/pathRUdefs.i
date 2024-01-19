# pathdefs.i - template for pathRUdefs.inc via sed editing.
# 2/20/23.	wmk.
# Modification History.
# ---------------------
# 4/25/22.	wmk.	modified to use *pathbase* env var; *..path* vars
#			 trailing / dropped.
# 2/20/23.	wmk.	appropriate paths changed to use *codebase.
# Legacy mods.
# 6/1/21.	wmk.	original code.
# 8/27/21.	wmk.	superfluous "s removed.
vpath %.db $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
vpath %.csv $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
bashpath = $(codebase)/Procs-Dev
postpath = $(pathbase)/RawData/RefUSA/RefUSA-Downloads/Terrxxx
RUQBpath = $(codebase)/Queries-SQL/RefUSA-Build
TSBpath = $(codebase)/Procs-Build
