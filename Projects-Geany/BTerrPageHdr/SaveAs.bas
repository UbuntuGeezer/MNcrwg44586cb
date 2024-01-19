'// Save.bas.
'//---------------------------------------------------------------
'// SaveAs - Save workbook As filename.typ .
'//		5/12/22.	wmk.	18:44
'//---------------------------------------------------------------

public sub SaveAs(poDoc As Object, psURL As String)

'//	Usage.	macro call or
'//			call SaveAs(oDoc, sURL )
'//
'//		oDoc = workbook to save
'//		sURL = URL for workbook; either .ods or .xlsx
'//
'// Entry.	workbook open
'//
'//	Exit.	oDoc saved to specified URL
'//			 if sURL was .odf, then to .odf file type,
'//			  .xlsx file type otherwise.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	5/12/22.	wmk.	original code; adapted from AddPubTerrHdr.ods;
'//				 better file type documentation.
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
	
end sub		'// end SaveAs		5/12/22.
'/**/
