'// OpenBizHdr.bas
'//---------------------------------------------------------------
'// OpenBizHdr - Open zip code header workbook.
'//		5/12/22.	wmk. 18:31
'//---------------------------------------------------------------

public sub OpenBizHdr( psZipCode As String, poHdrDoc As Object )

'//	Usage.	macro call or
'//			call OpenBizHdr(sZipCode, oHdrDoc)
'//
'//		sZipCode = (ignored for business territory)
'//		oZipHdrDoc = [returned] document
'//
'// Entry.	[Projects]/BTerrPageHdr/BizTerrHdr.ods exists and
'//			  contains Header/Footer header for business territory
'//
'//	Exit.	oHdrDoc = pointer to zip code header workbook
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.	wmk.	original code.
'// 12/24/21.	wmk.	csProjBase redefined to match chromeos
'//
'//	Notes. The zip code header workbook contains a Header/Footer header
'// that has the header information for territory zip code sZipCode. Since
'// the Header/Footer object is only accessible to Basic through the UNO
'// HeaderFooter frame, pre-storing the zip code header allows code to add
'// the proper zip code header without user intervention.
'//

'//	constants.
'const csProjBase = "/media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/TerrPageHeader"
'const csProjBase = "/home/vncwmk3/Territories/Projects-Geany/TerrPageHeader"

'//	local variables.
dim sBasePath		As String
dim sFullTargPath	As String

	'// code.
	ON ERROR GOTO ErrorHandler

if 1 = 0 then
'//********************************************************
	msgbox("Zip code = " & psZipCode & chr(13) & chr(10) _
	        & "In OpenBizHdr - code stubbed...")
'//**************************************************************
endif

	sBasePath = "TerrHdr"

'// open BizTerrHdr.ods
    sFullTargPath = csProjPath & "/" & "BizTerrHdr.ods"
dim oTestDoc2	as Object
'	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())
    poHdrDoc = oTestDoc2

'XRay oTestDoc2

if 1 = 1 then
	GoTo NormalExit
endif

'// at this point, focus is on oTestDoc2; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
'	oZipDoc = 

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenBizHdr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end OpenBizHdr		5/12/22.
'/**/
