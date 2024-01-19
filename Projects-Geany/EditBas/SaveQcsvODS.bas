'// SaveQcsvODS.bas
'//---------------------------------------------------------------
'// SaveQcsvODS - Save current workbook as .ods file.
'//		9/26/21.	wmk.	16:32
'//---------------------------------------------------------------

public sub SaveQcsvODS(poDoc As Object)

'//	Usage.	macro call or
'//			call SaveQcsvODS(oDoc)
'//
'//		oDoc = document object
'//
'// Entry.	ThisComponent.URL = "file://&lt;filepath to this Doc&gt;
'//			filename assumed to be "Terrxxx.ods"
'//
'//	Exit.	QTerrxxx.csv saved as QTerrxxx.ods with Hdr tab.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/11/21		wmk.	original code; cloned from SaveBridgeODS
'// 9/26/21.	wmk.	bug fix where focus lost on current frame; set from
'//						passed parameter.
'//
'//	Notes. 
'//

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
	document   = poDoc.CurrentController.Frame
	sDocURL = poDoc.getURL()
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-4)
	sNewURL = sURLBase + ".ods"

rem ----------------------------------------------------------------------
rem get access to the document
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
	msgbox("SaveQcsvODS - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveQcsvODS		9/26/21.	16:32
