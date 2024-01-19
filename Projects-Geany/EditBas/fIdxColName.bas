'// fIdxColName.bas
'//-----------------------------------------------------------
'// fIdxColName - convert numerical index to column letter(s).
'//		wmk. 9/1/20.	14:45
'//-----------------------------------------------------------
function fIdxColName( plColIndex ) as string

'//	Usage.	sColumn = fIdxColName( lColIndex )
'//
'//			lColIndex = 0-based column index (long)
'//
'//	Exit.	sColumn = "A" .. "ZZ"
'//
'//	Modification history.
'//	---------------------
'//	5/13/20		wmk.	original code
'//	5/15/20.	wmk.	docuentation and name change from fIdxCol to fIdxColName
'//	9/1/20.		wmk.	returned valu misspelling corrected
'//
'//	Notes.	method:
'// subtract 25, if 0 or less in A-Z
'// else [A..Z][A..Z]
'//     divide by 26; (whole amount-1)+chr(65)is left half
'//                   remainder + chr(65) is right half


'//	local variables.

dim sColumn as string
dim lColIndex as long
dim iLftIndex as integer
dim iRightOffset as integer

	'// code.

	lColIndex = plColIndex

	sColumn = "You gotta be kidding"

	If plColIndex &lt;= 25 Then
		sColumn = CHR(65+plColIndex)
	Elseif plColIndex &gt; 625 then
		sColumn "ZZ"		'// only up to 625 for now...
	Else
		iLftIndex = lColIndex/26
		iRightOffset = lColIndex - 26*(iLftIndex)
		sColumn = CHR(65+iLftIndex-1) + CHR(65+iRightOffset)
	Endif

	fIdxColName = sColumn
end	function	'// end fIdxColNam function		9/1/20
