#!/bin/bash
# 5/7/22.	wmk.
# Modification History.
# ---------------------
# 10/??/21.	wmk.	original code.
# 5/7/22.	wmk.	*pathbase* support; output path changed to ReleaseData.
cd $pathbase/RawData/RefUSA/RefUSA-Downloads
find -iname "PUB_NOTES*.html" \
 > $pathbase/Projects-Geany/ReleaseData/NotesTIDList.txt
# end BldNotesTIDList.sh
