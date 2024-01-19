'// OpenZipHdr.bas
'//---------------------------------------------------------------
'// OpenZipHdr - Open zip code header workbook.
'//		11/21/21.	wmk. 06:40
'//---------------------------------------------------------------

public sub OpenZipHdr( psZipCode As String, oZipDoc As Object )

'//	Usage.	macro call or
'//			call OpenZipHdr(sZipCode, oZipHdrDoc)
'//
'//		sZipCode = zip code of header to open
'//		oZipHdrDoc = [returned] document
'//
'// Entry.	[Projects]/TerrPageHeader/TerrHdr<sZipCode>.ods exists and
'//			  contains Header/Footer header for zip code sZipCode
'//
'//	Exit.	oZipDoc = pointer to zip code header workbook
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.		wmk.	original code.
'//
'//	Notes. The zip code header workbook contains a Header/Footer header
'// that has the header information for territory zip code sZipCode. Since
'// the Header/Footer object is only accessible to Basic through the UNO
'// HeaderFooter frame, pre-storing the zip code header allows code to add
'// the proper zip code header without user intervention.
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler

	msgbox("Zip code = " & psZipCode & chr(13) & chr(10) _
	        & "In OpenZipHdr - code stubbed...")
'//********************************************************
if 1 = 0 then
	sTerrID = psTerrID
	sBaseName = "PubTerr"
	sBasePath = "Terr"
	sTargPath = sBasePath & sTerrID

'// open Terrxxx_PubTerr.ods
    sFullTargPath = csTerrBase & sBasePath & sTerrID & "/"_ 
		& sBasePath & sTerrID & "_PubTerr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())
    poNewDoc = oTestDoc2

'XRay oTestDoc2

if 1 = 1 then
	GoTo NormalExit
endif

'// at this point, focus is on oTestDoc2; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
'	oZipDoc = 
endif
'//**************************************************************

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenZipHdr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end OpenZipHdr		11/21/21.	06:40
