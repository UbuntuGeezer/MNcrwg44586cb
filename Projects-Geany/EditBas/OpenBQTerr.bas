'// OpenBQTerr.bas - Open QTerrxxx.csv for business territory xxx.
'//---------------------------------------------------------------
'// OpenBQTerr - Open QTerrxxx.csv for territory xxx.
'//		`12/23/21.	wmk.	22:49
'//---------------------------------------------------------------

public sub OpenBQTerr( psTerrID As String )

'//	Usage.	call OpenBQTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../BTerrData/Terrxxx/Working-Files/QTerrxxx.csv
'//				contains territory records for territory xxx, delimited
'//				by "|"
'//
'//	Exit.	QTerrxxx.ods opened in new spreadsheet (visible)
'//			TerrxxxHdr.ods opened in new spreadsheet (visible)
'//		On exit, all workbooks and sheets will be closed, since
'//		the objects pointing to them are not guaranteed to be
'//		intact for the next process in line.
'//
'// Calls. ExportTerrHdr, SaveQcsvODS.
'//
'//	Modification history.
'//	---------------------
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
