'// GreenRow.bas - Set green background color on specified row.
'//---------------------------------------------------------------
'// GreenRow - Set green background color on specified row.
'//		3/21/21.	wmk.	23:28
'//---------------------------------------------------------------

public sub GreenRow( plRow AS Long )

'//	Usage.	macro call or
'//			call GreenRow( lRow )
'//
'//		lRow = row to set green background on
'//
'// Entry.	user in sheet where row is resident
'//
'//	Exit.	columns A - I will be set with a green background in the row
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/15/21.	wmk.	original code; cloned from macro recording
'// 3/21/21.	wmk.	color change to lighter green
'//
'//	Notes. This sub is useful when wanting to distinguish boundary
'// rows within a spreadsheet. e.g. when groups of rows have similar
'// information, this enables the user to visually group the rows.


'//	constants.
const LT_LIME=12313405		'// xbbe33d

'//	local variables.
dim lThisRow 	As Long
dim dispatcher	As Object		'// uno dispatcher object
dim document	As Object		'// uno frame reference
dim sRangeSel	As String		'// string for selected range
dim sThisRow	As String		'// local copy of row parameter
dim args1(0) as new com.sun.star.beans.PropertyValue	'// Dispatch property arrays
dim args9(3) as new com.sun.star.beans.PropertyValue

	'// code.
	ON ERROR GOTO ErrorHandler
	lThisRow = plRow
	sThisRow = trim(str(lThisRow+1))
	
	'// set up uno objects.
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// select range Ax:Ix.
'	dim args1(0) as new com.sun.star.beans.PropertyValue
	sThisRow = trim(str(lThisRow+1))
	args1(0).Name = "ToPoint"
	sRangeSel = "$A$" + sThisRow + ":$I$" + sThisRow
	args1(0).Value = sRangeSel

	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args1())

	'// now set background cell color green across selection.
	'dim args9(3) as new com.sun.star.beans.PropertyValue
	args9(0).Name = "BackgroundPattern.Transparent"
	args9(0).Value = false
	args9(1).Name = "BackgroundPattern.BackColor"
	args9(1).Value = LT_LIME
	args9(2).Name = "BackgroundPattern.Filtername"
	args9(2).Value = ""
	args9(3).Name = "BackgroundPattern.Position"
	args9(3).Value = com.sun.star.style.GraphicLocation.NONE

	dispatcher.executeDispatch(document, ".uno:BackgroundPattern", "",_
								0, args9())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("GreenRow - unprocessed error")
	GoTo NormalExit
	
end sub		'// end GreenRow	3/21/21.	23:28
