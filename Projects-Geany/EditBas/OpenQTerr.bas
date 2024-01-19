'//				 in OpenQTerr.bas.
'// 12/23/21.	wmk.	modified to use module-wide constant
'//				 csTerrDataPath.		
'//
'//	Notes. This is the second step in processing a QTerrxxx.csv file
'// into a PubTerr workbook. The first step openend the .csv file and
'// saved it as QTerrxxx.ods, closing it. This step re-opens the
'// QTerxxx.ods workbook, opens a second workbook TerrxxxHdr.ods, and
'// adds its TerxxxHdr sheet to the end of the QTerrxx.ods workbook,
'// closing both when finished.
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defiend above"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object
dim oTestDoc2		As Object	'// 2nd document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent
	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID

	'// open QTerrxxx.ods
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())

	'// open TerrxxxHdr.ods
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBasePath &amp; sTerrID &amp; "Hdr.ods"

dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args2(1).name = "FilterName"
	Args2(1).Value = "calc8"
	Args2(0).name = "Hidden"
	Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()
	
if 1 = 0 then
xray oTestDoc	
endif

	oTestDoc.Store

CloseFiles:
	'// close the workbooks and cleanup.
	oTestDoc2.close(1)
	oTestDoc.close(1)
	
	'// Now ready to process territory....

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("AddHdrToQTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end AddHdrToQTerr	12/23/21.	16:21
'//				 in OpenQTerr.bas.
'// 12/23/21.	wmk.	csTerrBase, csBTerrDataPath module-wide vars
'//				 used for multi-host support.		
'//
'//	Notes. This is the second step in processing a QTerrxxx.csv file
'// into a PubTerr workbook. The first step openend the .csv file and
'// saved it as QTerrxxx.ods, closing it. This step re-opens the
'// QTerxxx.ods workbook, opens a second workbook TerrxxxHdr.ods, and
'// adds its TerxxxHdr sheet to the end of the QTerrxx.ods workbook,
'// closing both when finished.
'//

'//	constants.
'const csTerrBase = "defined above"
'const csBTerrDataPath = "defined above"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object
dim oTestDoc2		As Object	'// 2nd document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent
	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID
if 1 = 0 then

	'// open QTerrxxx.ods
    sFullTargPath = csBTerrPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
endif

	'// open TerrxxxHdr.ods
    sFullTargPath = csBTerrPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBasePath &amp; sTerrID &amp; "Hdr.ods"

dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args2(1).name = "FilterName"
	Args2(1).Value = "calc8"
	Args2(0).name = "Hidden"
	Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()
	
if 1 = 0 then
xray oTestDoc	
endif

	oTestDoc.Store

CloseFiles:
	'// close the workbooks and cleanup.
	oTestDoc2.close(1)
'	oTestDoc.close(1)
	
	'// Now ready to process territory....

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("AddHdrToQBTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end AddHdrToQBTerr	12/23/21	16:30
'// OpenQTerr.bas - Open QTerrxxx.csv for territory xxx.
'//---------------------------------------------------------------
'// OpenQTerr - Open QTerrxxx.csv for territory xxx.
'//		12/23/21.	wmk.	22:45
'//---------------------------------------------------------------

public sub OpenQTerr( psTerrID As String )

'//	Usage.	call OpenQTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.csv
'//				contains territory records for territory xxx, delimited
'//				by "|"
'//
'//	Exit.	QTerrxxx.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/9/21.		wmk.	original code.
'//	7/10/21.	wmk.	bug fixes to meet OPTION EXPLICIT; conditional
'//						msgbox; remove QToPubTerr3 call.
'// 7/11/21.	wmk.	functionality simplified to just open QTerrxxx.csv
'//				 and save as QTerrxxx.ods.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDatapPath module-wide
'//				 constants for multihost support.
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening QTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif

	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID
REM edit the file name as needed
'    Target = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr240/Working-Files"_
'      &amp; "/QTerr240.csv"

'    sFullTargPath = csTerrBase &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
'		&amp; sBaseName &amp; sTerrID &amp; ".csv"
'    TargetURL = convertToURL(sFullTargPath)

'// open QTerrxxx.csv
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".csv"
		
if 1 = 1 then
	sTargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
dim Args(1)	As new com.sun.star.beans.PropertyValue 
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
   Args(0).name = "Hidden"
   Args(0).value = False
    oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
endif

	SaveQcsvODS(oTestDoc)
	oTestDoc.Close(1)
if 1 = 1 then
 GoTo NormalExit
endif

if 0 = 1 then
  xray oTestDoc
endif
'// open TerrxxxHdr.ods
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBasePath &amp; sTerrID &amp; "Hdr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

if 1 = 0 then
dim iResp as integer
	iResp = msgbox("Both .ods files opened..." &amp; chr(13) &amp; chr(10)_
	  &amp; "  Drop 1st file?", MB_OKCANCEL+ MB_ICONQUESTION)
	if iResp = IDOK then
	   oTestDoc.close(1)
	endif
endif

	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()	

	'// move to header sheet just exported.
	'// Now close the TerrxxxHdr.ods workbook.
	oTestDoc2.close(1)

'	SaveQCsvODS	'// save as .ods

	'// exit with QTerrxxx.csv still open.
if 1 = 1 then
	GoTo NormalExit
endif

'// Now ready to process territory.
'	QToPubTerr3()
'	oDoc = ThisComponent
'dim oSel	As Object
'	oSel = oDoc.getCurrentSelection()
'	oTestDoc = oDoc.CurrentController.Frame
if 1 = 1 then	
	msgbox( "Moving to " &amp; oTestDoc.getURL &amp; "." &amp; sBaseName &amp; sTerrID )
	MoveToDocSheet( oTestDoc, sBaseName &amp; sTerrID )
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBasePath &amp; sTerrId &amp; "Hdr")
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBaseName &amp; sTerrID)
endif

'// at this point, focus is on oTestDoc; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenQTerr - unprocessed error")
	GoTo NormalExit

end sub		'// end OpenQTerr	12/23/21. 22:45
'// OpenQTerr.bas - Open QTerrxxx.csv for territory xxx.
'//---------------------------------------------------------------
'// OpenQTerr - Open QTerrxxx.csv for territory xxx.
'//		7/11/21.	wmk.	17:31
'//---------------------------------------------------------------

public sub OpenQTerr1( psTerrID As String )

'//	Usage.	call OpenQTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.csv
'//				contains territory records for territory xxx, delimited
'//				by "|"
'//
'//	Exit.	QTerrxxx.ods opened in new spreadsheet (visible)
'//			TerrxxxHdr.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/9/21.		wmk.	original code.
'//	7/10/21.	wmk.	bug fixes to meet OPTION EXPLICIT; conditional
'//						msgbox; remove QToPubTerr3 call.
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening QTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif
	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "Terr"
	sTargPath = sBasePath &amp; sTerrID
REM edit the file name as needed
'    Target = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr240/Working-Files"_
'      &amp; "/QTerr240.csv"

'    sFullTargPath = csTerrBase &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
'		&amp; sBaseName &amp; sTerrID &amp; ".csv"
'    TargetURL = convertToURL(sFullTargPath)

'// open QTerrxxx.csv
    sFullTargPath = csTerrBase &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".csv"
		
if 1 = 1 then
	sTargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
dim Args(1)	As new com.sun.star.beans.PropertyValue 
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
   Args(0).name = "Hidden"
   Args(0).value = False
    oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
endif

SaveQcsvODS(oTestDoc)

if 1 = 1 then
 GoTo NormalExit
endif

if 0 = 1 then
  xray oTestDoc
endif
'// open TerrxxxHdr.ods
    sFullTargPath = csTerrBase &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBasePath &amp; sTerrID &amp; "Hdr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

if 1 = 0 then
dim iResp as integer
	iResp = msgbox("Both .ods files opened..." &amp; chr(13) &amp; chr(10)_
	  &amp; "  Drop 1st file?", MB_OKCANCEL+ MB_ICONQUESTION)
	if iResp = IDOK then
	   oTestDoc.close(1)
	endif
endif

	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()	

	'// move to header sheet just exported.
	'// Now close the TerrxxxHdr.ods workbook.
	oTestDoc2.close(1)
	oTestDoc.close(1)
	
'	SaveQCsvODS	'// save as .ods

	'// exit with QTerrxxx.csv still open.
if 1 = 1 then
	GoTo NormalExit
endif

'// Now ready to process territory.
'	QToPubTerr3()
'	oDoc = ThisComponent
'dim oSel	As Object
'	oSel = oDoc.getCurrentSelection()
'	oTestDoc = oDoc.CurrentController.Frame
if 1 = 1 then	
	msgbox( "Moving to " &amp; oTestDoc.getURL &amp; "." &amp; sBaseName &amp; sTerrID )
	MoveToDocSheet( oTestDoc, sBaseName &amp; sTerrID )
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBasePath &amp; sTerrId &amp; "Hdr")
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBaseName &amp; sTerrID)
endif

'// at this point, focus is on oTestDoc; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenQTerr - unprocessed error")
	GoTo NormalExit

end sub		'// end OpenQTerr1	7/11/21. 17:31
'//	9/25/21.	wmk.	original code; adapted from OpenQTerr.bas.
'// 9/26/21.	wmk.	all workbook/sheet objects closed, since
'//						the pointers get lost anyway.
'// 9/29/21.	wmk.	gbKillProcess used to alert caller of error.
'// 12/23/21.	wmk.	modified to use csTerrBase, csBTerrDataPath module-wide
'//				 constants for multihost support.
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening QTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "defined above"
'const csBTerrDataPath = "defined above"

'//	local variables.
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif

	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID
REM edit the file name as needed
'    Target = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr240/Working-Files"_
'      &amp; "/QTerr240.csv"

'    sFullTargPath = csTerrBase &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
'		&amp; sBaseName &amp; sTerrID &amp; ".csv"
'    TargetURL = convertToURL(sFullTargPath)

'// open QTerrxxx.csv
    sFullTargPath = csBTerrPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".csv"
		
	sTargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	Args(1).name = "FilterName"
	Args(1).Value = "Text - txt - csv"
	Args(0).name = "Hidden"
	Args(0).value = False
    oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())

if 0 = 1 then
  xray oTestDoc
endif
'// open TerrxxxHdr.ods
    sFullTargPath = csBTerrPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBasePath &amp; sTerrID &amp; "Hdr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args2(1).name = "FilterName"
	Args2(1).Value = "calc8"
	Args2(0).name = "Hidden"
	Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

if 0 = 1 then
dim iResp as integer
	iResp = msgbox("Both .ods files opened..." &amp; chr(13) &amp; chr(10)_
	  &amp; "  Drop 1st file?", MB_OKCANCEL+ MB_ICONQUESTION)
	if iResp = IDOK then
	   oTestDoc.close(1)
	endif
endif
	
	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()	

'	msgbox( "Moving to " &amp; oTestDoc.getURL &amp; "." &amp; sBaseName &amp; sTerrID )
	'// Now close the TerrxxxHdr.ods workbook.
	oTestDoc2.close(1)

	'// move to header sheet just exported.
'	MoveToDocSheet( oTestDoc, sBaseName &amp; sTerrID )
'	oTestDoc = ThisComponent
	SaveQcsvODS( oTestDoc )
	oTestDoc.Close(1)
		
'// Now ready to process territory.	
'	DkLimeTab()
'	ProtectSheet()
'	MoveToSheet(sBasePath &amp; sTerrId)
'	DkLimeTab()
'	ProtectSheet()
'	MoveToDocSheet(oTestDoc,sBaseName &amp; sTerrID)
	
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenBQTerr - unprocessed error")
	gbKillProcess = true
	GoTo NormalExit
	
end sub		'// end OpenBQTerr	12/23/21. 22:49
