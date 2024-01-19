'// SaveUMSheetAsCSV.bas
'//---------------------------------------------------------------
'// SaveUMSheetAsCSV - Save UpdateMaster sheet as .csv file.
'//		10/15/20.	wmk.	20:40
'//---------------------------------------------------------------

public sub SaveUMSheetAsCSV()

'//	Usage.	macro call or
'//			call SaveUMSheetAsCSV()
'//
'// Entry.	user has sheet UpdateMaster selected saved as .csv file
'//			Note: best if save without headihgs, then data
'//			as opposed to more heading information rows
'//
'//	Exit.	sheet saved on URL path csTerrBase/Territories/RawData/Tracking
'//			 as <sheet-name>.csv
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/1520.		wmk.	original code; adapted from SaveSheetAsCSV.
'//
'//	Notes.
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/RawData/Tracking/"
'const csTrackingPath = csTerrBase & "/RawData/Tracking"

'//	local variables.
dim oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// current selection
dim oRange		As Object	'// selection RangeAddress
dim iSheetIx	As Integer	'// selected sheet index
dim oSheet		As Object	'// sheet object
dim sSheetName	As String	'// name of this sheet
dim sDocURL	As String		'// URL this string
dim sNewURL		As String		'// new URL to save under
dim nURLLen		As Integer		'// URL length
dim sURLBase	As String		'// URL base string

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	sSheetName = oDoc.Sheets(iSheetIx).Name
	
	'// set up for save as .csv
	'// it is known that the URL will end in "Terrxxx.ods" (11 chars)
	sURLBase = csTrackingPath & "/" & sSheetName + ".csv"
	sNewURL = convertToURL(sURLBase)
	
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/csvs-Dev/Terr102_Bridge.csv"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "Text - txt - csv (StarCalc)"
args1(2).Name = "FilterOptions"
args1(2).Value = "44,34,76,1,,0,false,true,true,false,false"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveUMSheetAsCSV - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveUMSheetAsCSV		10/15/20.	20:40
'/**/
