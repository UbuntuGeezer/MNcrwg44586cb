'// Save.bas.
'//---------------------------------------------------------------
'// SaveAs - Save workbook As filename.typ .
'//		11/23/21.	wmk.	12:50
'//---------------------------------------------------------------

public sub SaveAs(poDoc As Object, psURL As String)

'//	Usage.	macro call or
'//			call SaveAs(oDoc, sURL )
'//
'//		oDoc = workbook to save
'//		sURL = URL for workbook
'//
'// Entry.	workbook open
'//
'//	Exit.	oDoc saved to specified URL
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	1/1/21.		wmk.	original code
'//
'//	Notes. <Insert notes here>
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
oDocument   = poDoc.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr235/" _
'	& psFileName & ".ods"
args1(0).Value = psURL
args1(1).Name = "FilterName"
if strcmp(right(psUrl,4),".ods") = 0 then
 args1(1).Value = "calc8"
else
 args1(1).Value = "Calc MS Excel 2007 XML"
endif

oDispatcher.executeDispatch(oDocument, ".uno:SaveAs", "", 0, args1())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveAs - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveAs		11/23/21.	12:50
