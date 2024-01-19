'// RmvUpdateMaster.bas
'//---------------------------------------------------------------
'// RmvUpdateMaster - Remove UpdateMaster worksheet from workbook.
'//		7/15/21.	wmk.	7/15/21.	09:50
'//---------------------------------------------------------------

sub RmvUpdateMaster

'//	Usage.	macro call or
'//			call RmvUpdateMaster()
'//
'// Entry.	<entry conditions>
'//
'//	Exit.	<exit conditions>
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.		wmk.	original code; cloned from Record Macro.
'//
'//	Notes. Specifically for ProcessQTerr12.ods; Removes sheet UpdateMaster
'// from workbook. (See also AddUpdateMaster).
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
dim oDoc		As Object
dim oSel		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oSheet		As Object
dim sSheetName	As String

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	sSheetName = oSheet.Name
	
	'// check if in UpdateMaster sheet...
	if strcomp(sSheetName, "UpdateMaster") <> 0 then
		msgbox("** Not in UpdateMaster sheet...cannot remove! **")
		GoTo NormalExit
	endif

rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:Remove", "", 0, Array())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RmvUpdateMaster - unprocessed error")
	GoTo NormalExit
	
end sub		'// end RmvUpdateMaster		7/15/21.	09:50
'/**/
