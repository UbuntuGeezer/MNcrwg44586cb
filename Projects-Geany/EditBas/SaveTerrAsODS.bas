'// SaveTerrAsODS.bas
'//---------------------------------------------------------------
'// SaveTerrAsODS - Save current sheet as .ods file.
'//		7/11/21.	wmk.	08:14
'//---------------------------------------------------------------

public sub SaveTerrAsODS(poDocument As Object, psURL As String)

'//	Usage.	call SaveTerrAsODS(oDocument As Object, sURL)
'//
'//		poDocument = ThisComponent of worksheet to be saved
'//			Sheets().Name = sheet name/file name to save
'//		psURL = URL to "parent" worksheet and its folder
'//		 (e.g. "file:///media/ubuntu../Working-Files/QTerrxxx.ods")
'//
'// Entry.	user has sheet selected that desires saved as .ods file
'//			URL of current workbook assumed to be of form:
'//			  ..Territories/TerrData/Terrxxx/Working-Files/Untitled x.ods
'//
'//	Exit.	sheet saved on path ../ as &lt;sheet-name&gt;.ods
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/11/21.		wmk.	original code; adapted from SaveSheetAsODS
'//
'//	Notes. When you pass a "new" workbook (e.g. "Untitled x") into this
'// sub, there is no URL associated with it, since it has not been stored
'// in any file system. This sub must create a URL to save with the workbook
'// using the "parent" URL passed in along with the file base name. The
'// .ods suffix will be added by this sub.
'// The difference between SaveTerrAsODS and SaveSheetAsODS is that the
'// parent URL when saving a territory has the folder "Workiing-Files/"
'// at the end that needs to be removed to save the territory in the
'// TerrData folder. SaveSheetAsODS saves to the parent folder.
'//

'//	constants.

'//	local variables.
dim oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// current selection
dim oRange		As Object	'// selection RangeAddress
dim iSheetIx	As Integer	'// selected sheet index
dim oSheet		As Object	'// sheet object
dim sSheetName	As String	'// name of this sheet/filename
dim sParentURL	As String		'// URL of parent workbook
dim sNewURL		As String		'// new URL to save under
dim nURLLen		As Integer		'// URL length
dim sURLBase	As String		'// URL base string
dim nWFlength	As	Integer		'// "Working-Files/" string length

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
'	oDoc = poDocument
'	oDoc = ThisComponent
	sParentURL = psURL
	oSel = poDocument.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	sSheetName = poDocument.Sheets(iSheetIx).Name
	
	'// now construct a new URL for the target file
	'// parent URL up through the last '/' (all except last 11 chars)
	'// &amp; sheet name &amp; .ods
'dim sNewURL		As	String	
dim sOldURLpath	As	String
	nWFlength = len("Working-Files/")
	sOldURLPath = left(sParentURL, len(sParentURL)-11-nWFlength)	'// sans QTerrxxx.ods
	sNewURL = sOldURLpath &amp; sSheetName &amp; ".ods"

if 1 = 1 then
  GoTo NormalExit
endif

if 1 = 0 then	
	'// set up for save as .csv
	'// need to save "Untitled x"
	'// it is known that the URL will end in "Terrxxx.ods" (11 chars)
	nURLlen = len(sDocURL)
	'// URL length -11 (filename) - Working-Files/
	nWFlength = len("Working-Files/")
	sURLBase = left(sDocURL, nURLLen-11-nWFlength)
	sNewURL = sURLBase + sSheetName + ".ods"
endif
	
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories
'                    /TerrData/Terrxxx/TerrData/Terrxxx_PubTerr.ods"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())


NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveTerrAsODS - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveTerrAsODS		7/11/21.	08:14
