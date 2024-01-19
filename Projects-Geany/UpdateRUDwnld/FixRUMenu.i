# FixRUMenu.i - FixyyyRU.sql, FixyyyRU.sh recipe definitions template.
#	6/2/21.	wmk.
#
# Dependencies.
# -------------
# 'make' vars:
#	postpath = filepath for folder containing FixyyyRU.sh, FixyyyRU.sql
#				(typically ~/RawData../RefUSA-Downloads/Terryyy)
# Modification History.
# ---------------------
# 6/2/21.	wmk.	original code.
# 4/25/22.	wmk.	*..path* vars assumed to have no '/' trailer.
#
# Notes.
# ------
# FixRUMenu.i provides the make recipe for FixyyyRU.sh.
# FixyyyRU.sh will be considered out-of-date if FixyyyRU.sql is newer.

$(postpath)/FixyyyRU.sh : $(postpath)/FixyyyRU.sql
	$(bashpath)/FixAnyRU.sh yyy

$(postpath)/FixyyyRU.sql : ; 

