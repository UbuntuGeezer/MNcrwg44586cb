'// ExportTerrHdr.bas
'//---------------------------------------------------------------
'// ExportTerrHdr - Export territory header to QTerrxxx.ods.
'//		2/12/21.	wmk.
'//---------------------------------------------------------------

public sub ExportTerrHdr()

'//	Usage.	macro call or
'//			call ExportTerrHdr()
'//
'//		&lt;parameters description&gt;
'//
'// Entry.	User in workbook TerrxxxHdr (either .csv or ods)
'//
'//	Exit.	Workbook saved as .ods if not already
'//			Sheet TerrxxxHdr copied to workbook QTerrxxx at end sheet
'//			TerrxxxHdr tab dark lime
'//			Sheet protected
'//
'// Calls.	DkLimeTab, ProtectSheet
'//
'//	Modification history.
'//	---------------------
'//	2/12/21.		wmk.	original code
'//
'//	Notes. This macro takes the TerrxxxHdr sheet and copies it to the
'// end sheet of the QTerrxxx workbook. This sets up QTerrxxx for 
'// running the QtoPubTerr macro building the territory workbook.
'//

'//	constants.

'//	local variables.
dim sDocURL		As String	'// document URL
dim nURLlen		As Integer	'// URL length
dim sURLBase	As String	'// base of new URL
dim sNewURL		As String	'// new full URL for file save
dim sFileBase	As String	'// current filename sans leading Q
dim sQTerrFile	As String	'// extrapolated QTerr filename QTerrxxx.
	'// code.
	ON ERROR GOTO ErrorHandler
	sDocURL = ThisComponent.getURL()
	'// expected URL = ../TerrData/Working-Files/QTerrxxx.csv
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-12)	'// up to last '/'
	sFileBase = right(sDocURL,14)	'// TerrxxxHdr.ods
	'// transform TerrxxxHdr.ods to QTerrxxx
	sQTerrFile = "Q" + left(sFileBase,7)
	
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
'args1(0).Value = "QTerr287"
args1(0).Value = sQTerrFile
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	sDocURL = ThisComponent.getURL()

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ExportTerrHdr - unprocessed error")
	GoTo NormalExit
rem ----------------------------------------------------------------------
rem define variables
'dim document   as object
'dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
'dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = "QTerr287"
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	
end sub		'// end ExportTerrHdr
