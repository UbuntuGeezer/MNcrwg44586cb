'// AddUpdateMaster.bas
'//---------------------------------------------------------------
'// AddUpdateMaster - Add UpdateMaster sheet to current workbook.
'//		7/15/21.	wmk.	09:53
'//---------------------------------------------------------------

sub AddUpdateMaster

'//	Usage.	macro call or
'//			call AddUpdateMaster()
'//
'// Entry.	UpdateMaster sheet selected by user
'//
'//	Exit.	UpdateMaster sheet removed from workbook
'//
'// Calls.	fbSheetExists.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.	wmk.	original code; cloned from Record Macro.
'// 7/21/21.	wmk.	add fbSheetExists check.
'//
'//	Notes. Specifically for ProcessQTerr12.ods; Adds sheet UpdateMaster
'// to workbook. (See also RmvUpdateMaster).
'//

'//	constants.

'//	local variables.
dim bSheetExists	As Boolean	'// UpdateMaster already exists flag

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	bSheetExists = fbSheetExists("UpdateMaster")
	if bSheetExists then
		MoveToSheet("UpdateMaster")
		GoTo NormalExit
	else
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Name"
args1(0).Value = "UpdateMaster"

dispatcher.executeDispatch(document, ".uno:Add", "", 0, args1())
	endif	
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("AddUpdateMaster - unprocessed error")
	GoTo NormalExit
	
end sub		'// end AddUpdateMaster	7/15/21.	09:53
'/**/
