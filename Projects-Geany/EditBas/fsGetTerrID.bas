'// fsGetTerrID.bas
'//---------------------------------------------------------------
'// fsGetTerrID - Get territory ID from sheet information.
'//		3/16/21.	wmk.
'//---------------------------------------------------------------

public function fsGetTerrID() as String

'//	Usage.	&lt;target&gt; = fsGetTerrID()
'//
'//		&lt;target&gt; = string to receive territory ID.
'//
'// Entry.	user in any territory sheet
'//			A1 contains .String = 'Terr..xxxx' where xxxx is territory ID
'//
'//	Exit.	&lt;target&gt; = trim(xxxx) from A1.String
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 3/16/21.		wmk.	original code
'//
'//	Notes. This code provides a stopgap for generating anything that is
'//	dependent upon the territory id.
'//

'//	constants.
const	COL_A=0
const	ROW_1=0

'//	local variables.
dim sRetValue 		As String
dim oDoc			As Object
dim oSel			As Object
dim oRange			As Object
dim	oCell			As Object
dim iSheetIX		As Integer
dim oSheet			As Object
dim sSheetTitle		As String
dim sTerrID			As String

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""

	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIX)

	'// extrapolate territory ID from right 4 of Sheet title in A1-C1.
	oCell = oSheet.getCellByPosition(COL_A,ROW_1)
	sSheetTitle = oCell.String
	sTerrID = trim(right(sSheetTitle,4))
	sRetValue = sTerrID
	
NormalExit:
	fsGetTerrID = sRetValue
	exit function
	
ErrorHandler:
	msgbox("fsGetTerrID - unprocessed error")
	GoTo NormalExit

end function 	'// end fsGetTerrID	3/16/21.	11:47
