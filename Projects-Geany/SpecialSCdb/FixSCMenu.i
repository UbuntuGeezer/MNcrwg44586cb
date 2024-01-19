# FixSCMenu.i - FixyyySC.sql, FixyyySC.sh recipe definitions template.
#	7/2/21.	wmk.
#
# Dependencies.
# -------------
# 'make' vars:
#	postpath = filepath for folder containing FixyyySC.sh, FixyyySC.sql
#				(typically ~/RawData../SCPA-Downloads/Terryyy)
# Notes.
# ------
# FixSCMenu.i provides the make recipe for FixyyySC.sh.
# FixyyySC.sh will be considered out-of-date if FixyyySC.sql is newer.

$(postpath)FixyyySC.sh : $(postpath)FixyyySC.sql
	$(bashpath)FixAnySC.sh yyy

$(postpath)FixyyySC.sql : ; 

