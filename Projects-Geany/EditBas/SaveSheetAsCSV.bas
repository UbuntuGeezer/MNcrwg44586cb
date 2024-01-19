'// SaveSheetAsCSV.bas
'//---------------------------------------------------------------
'// SaveSheetAsCSV - Save current sheet as .csv file.
'//		10/12/20.	wmk.	20:40
'//---------------------------------------------------------------

public sub SaveSheetAsCSV()

'//	Usage.	macro call or
'//			call SaveSheetAsCSV()
'//
'// Entry.	user has sheet selected that desires saved as .csv file
'//			Note: best if save with only row headings, then data
'//			as opposed to more heading information rows
'//
'//	Exit.	sheet saved on current URL path as &lt;sheet-name&gt;.csv
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.		wmk.	original code; cloned from macro recording
'//
'//	Notes.
'//

'//	constants.

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
	sDocURL = ThisComponent.getURL()
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-11)
	sNewURL = sURLBase + sSheetName + ".csv"
	
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
	msgbox("SaveSheetAsCSV - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveSheetAsCSV		10/12/20
