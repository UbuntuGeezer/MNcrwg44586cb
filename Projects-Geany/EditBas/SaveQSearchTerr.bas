'// SaveQSearchTerr.bas
'//---------------------------------------------------------------
'// SaveQSearchTerr - Save current territory sheet to search file.
'//		2/6/21.	wmk.	16:00
'//---------------------------------------------------------------

public sub SaveQSearchTerr()

'//	Usage.	macro call or
'//			call SaveQSearchTerr()
'//
'// Entry.	ThisComponent.URL = "file://&lt;filepath to this Doc&gt;
'//			filename assumed to be "QTerrxxx.ods"
'//
'//	Exit.	file save to entry URL modified to 'Terrxxx_Search.ods'
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/13/20.		wmk.	original code
'//
'//	Notes.

'//	constants.

'//	local variables.
dim document   as object
dim dispatcher as object
dim sDocURL		As String	'// document URL
dim nURLlen		As Integer	'// URL length
dim sURLBase	As String	'// base of new URL
dim sNewURL		As String	'// new full URL for file save

	'// code.
	ON ERROR GOTO ErrorHandler
	sDocURL = ThisComponent.getURL()
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-4)
	sNewURL = sURLBase + "_PubSearch.ods"

rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/csvs-Dev/QTerr102.ods"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())


NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveQSearchTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveQSearchTerr		2/6/21
