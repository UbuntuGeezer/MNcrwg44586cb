'// SaveCsvToODS.bas
'//---------------------------------------------------------------
'// SaveCsvToODS - Save current sheet (.csv) to .ods sheet file.
'//		10/12/20.	wmk.	13:45
'//---------------------------------------------------------------

public sub SaveCsvToODS()

'//	Usage.	macro call or
'//			call SaveCsvToODS()
'//
'// Entry.	ThisComponent.URL = "file://&lt;filepath to this Doc&gt;
'//
'//	Exit.	file save to entry URL modified to '.ods'
'//			user focused in new workbook
'//			goCurrDocument set for return to this document
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/11/20.		wmk.	original code
'// 7/9/21.			wmk.	set up for return to goCurrDocument
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
dim sDocURL		As String	'// document URL
dim nURLlen		As Integer	'// URL length
dim sURLBase	As String	'// base of new URL
dim sNewURL		As String	'// new full URL for file save

	'// code.
	ON ERROR GOTO ErrorHandler
	sDocURL = ThisComponent.getURL()
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-4)
	sNewURL = sURLBase + ".ods"
	dim document   as object

dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
goCurrDocument = document							'// mod070921
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/csvs-Dev/Terr102.ods"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())



NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveCsvToODS - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveCsvToODS		10/12/20
