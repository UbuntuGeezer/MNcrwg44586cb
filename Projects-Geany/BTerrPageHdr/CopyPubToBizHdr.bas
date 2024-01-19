'// CopyPubToBizHdr.bas
'//--------------------------------------------------------------------------
'// CopyPubToBizHdr.bas - Copy Terrxxx_PubTerr sheet to TerrHdr<zipcode>.ods.
'//		5/12/22.	wmk.	20:51
'//--------------------------------------------------------------------------

public sub CopyPubToBizHdr(poPubDoc As Object, poZipHdrDoc As Object)

'//	Usage.	call CopyPubToBizHdr( oPubDoc, oZipHdrDoc )
'//
'//		oPubDoc = workbook from which to copy sheet 0 (Terrxxx_PubTerr)
'//		oZipHdrDoc = target workbook, oPubDoc.Sheets(0) copied to end
'//
'// Entry.	
'//
'//	Exit.	oZipHdrDoc.Sheets(end) = copy of oPubDoc.Sheets(0)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.	wmk.	original code.
'// 11/22/21.	wmk.	rewrite using UNO calls.
'// 11/24/21.	wmk.	use global csTerrBase.
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sTerrID			As String	'// passed territory ID
dim sDocName 		as String	'// target document name

'// UNO variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------

	'// code.
	ON ERROR GOTO ErrorHandler
'	MoveToDocSheet(poPubDoc, poPubDoc.Sheets(0).Name)
'	PickACell()
dim sSheetName as String
	sSheetName = poPubDoc.Sheets(0).Name
'	MoveToSheet(poPubDoc, sSheetName)
'	PickACell()
	
rem get access to the document
document   = poPubDoc.CurrentController.Frame
'document = poPubDoc
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

dim sZipTitle	As String
	sZipTitle = poZipHdrDoc.Title
	sDocName = left(sZipTitle,len(sZipTitle)-4)

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
'args1(0).Value = "Untitled 1"
args1(0).Value = sDocName
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyPubToBizHdr - unprocessed error")
	GoTo NormalExit


end sub		'// end CopyPubToBizHdr		5/12/22.
'/**/
