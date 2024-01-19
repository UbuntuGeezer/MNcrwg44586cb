'// CopySuperToPub.bas
'//---------------------------------------------------------------
'// CopySuperToPub - Copy PubTerr sheet to super territory.
'//		11/24/21.	wmk.	20:09
'//---------------------------------------------------------------

public sub CopySuperToPub(poPubTerrDoc As object)

'//	Usage.	macro call or
'//			call CopySuperToPub(oPubTerrDoc)
'//
'//		oPubTerrDoc = publisher territory workbook (.ods)
'//
'// Entry.	gsTerrID = (global) territory ID working on
'//			TerrData/Terr<gsTerrID>/Terr<gsTerrID>_SuperTerr.xlsx exists
'//
'//	Exit.	Terr<gsTerrID>_PubTerr.xlsx sheet Terr<gsTerrID>_Search added
'//			and written to Terr<gsTerrID>_SuperTerr.xlsx.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/23/21.	wmk.	original code; gsTerrID stubbed.
'// 11/24/21.	wmk.	use globals gsTerrID, csTerrBase; change to copy
'//						search sheet from super back into pub terr.
'//
'//	Notes. To preserve header info, need to copy Terrxxx_Search from
'// super territory into Terrxxx_PubTerr, then re-save as SuperTerr.
'//
'// Method. poPubTerrDoc on entry is workbook Terrxxx_PubTerr.ods.
'//		Save poPubTerrDoc As .xlsx
'//		open Terrxxx_SuperTerr.xlsx
'//		copy Terxxx_Search sheet from oSuperTerrDoc to end of poPubTerrDoc
'//		
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sTerrID			As String	'// passed territory ID
dim sDocName 		as String	'// target document name

	ON ERROR GOTO ErrorHandler
'dim gsTerrID	As String
'	gsTerrID = "235"

'// Save PubTerr.ods as .xlsx.
dim sXLsxPath	As String
dim sXlsxURL	As String
	sXlsxPath = csTerrBase & "/Terr" & gsTerrID & "/Terr" & gsTerrID _
	  & "_PubTerr.xlsx"
	sXlsxURL = convertToURL(sXlsxPath)
	SaveAs(poPubTerrDoc, sXlsxURL)

if 1 = 0 then
 GoTo NormalExit
endif

'// UNO variables.
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------

	'// code.
	ON ERROR GOTO ErrorHandler
'	MoveToDocSheet(poPubDoc, poPubDoc.Sheets(0).Name)
'	PickACell()

'// open Terrxxx_SuperTerr.xlsx.
dim oSuperTerrDoc	As Object
	OpenSuperTerr(gsTerrID, oSuperTerrDoc)

if 1 = 0 then
 GoTo NormalExit
endif

'// jump to Terrxxx_Search in super territory.
	MoveToDocSheet(oSuperTerrDoc, "Terr" & gsTerrID & "_Search")
if 1 = 0 then
 GoTo NormalExit
endif


'// copy Terrxxx_Search to pub territory.	
rem get access to the document
oDocument   = oSuperTerrDoc.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

'// document to copy to is Terrxxx_PubTerr.xlsx
'//  original document is Terrxxx_SuperTerr.xlsx
dim sPubTitle	As String
	sPubTitle = poPubTerrDoc.Title
'	sDocName = left(sPubTitle,len(sPubTitle)-4)	'// everything but .ods
	sDocName = "Terr" & gsTerrID & "_PubTerr"

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
'args1(0).Value = "Untitled 1"
args1(0).Value = sDocName
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

oDispatcher.executeDispatch(oDocument, ".uno:Move", "", 0, args1())


NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopySuperToPub - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopySuperToPub		11/24/21.	22:09
