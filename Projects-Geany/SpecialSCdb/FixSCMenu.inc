# FixSCMenu.i - FixWatersideDrSC.sql, FixWatersideDrSC.sh recipe definitions template.
#	7/2/21.	wmk.
#
# Dependencies.
# -------------
# 'make' vars:
#	postpath = filepath for folder containing FixWatersideDrSC.sh, FixWatersideDrSC.sql
#				(typically ~/RawData../SCPA-Downloads/TerrWatersideDr)
# Notes.
# ------
# FixSCMenu.i provides the make recipe for FixWatersideDrSC.sh.
# FixWatersideDrSC.sh will be considered out-of-date if FixWatersideDrSC.sql is newer.

$(postpath)FixWatersideDrSC.sh : $(postpath)FixWatersideDrSC.sql
	$(bashpath)FixAnySC.sh WatersideDr

$(postpath)FixWatersideDrSC.sql : ; 

