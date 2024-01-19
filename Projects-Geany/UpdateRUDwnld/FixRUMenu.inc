# FixRUMenu.i - Fix314RU.sql, Fix314RU.sh recipe definitions template.
#	6/2/21.	wmk.
#
# Dependencies.
# -------------
# 'make' vars:
#	postpath = filepath for folder containing Fix314RU.sh, Fix314RU.sql
#				(typically ~/RawData../RefUSA-Downloads/Terr314)
# Modification History.
# ---------------------
# 6/2/21.	wmk.	original code.
# 4/25/22.	wmk.	*..path* vars assumed to have no '/' trailer.
#
# Notes.
# ------
# FixRUMenu.i provides the make recipe for Fix314RU.sh.
# Fix314RU.sh will be considered out-of-date if Fix314RU.sql is newer.

$(postpath)/Fix314RU.sh : $(postpath)/Fix314RU.sql
	$(bashpath)/FixAnyRU.sh 314

$(postpath)/Fix314RU.sql : ; 

