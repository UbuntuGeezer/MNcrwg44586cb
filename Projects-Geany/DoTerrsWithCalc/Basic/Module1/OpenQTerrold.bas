'// OpenQTerrold.bas
'// legacy code.
'//---------------------------------------------------------------
'// OpenQTerr - Open QTerrxxx.csv for territory xxx.
'//		8/12/23.	wmk.
'//---------------------------------------------------------------

public sub OpenQTerrold( psTerrID As String )

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
'//	7/9/21.		wmk.	original code
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening QTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"
'const csTerrDataFolder = csTerrBase & "/Territories/TerrData"

'//	local variables.
dim sQBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim TargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As Object	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif
	sTerrID = psTerrID
	sQBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath & sTerrID
REM edit the file name as needed
'    Target = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr240/Working-Files"_
'      & "/QTerr240.csv"

'    sFullTargPath = csTerrDataPath & sBasePath & sTerrID & "/Working-Files/"_ 
'		& sBaseName & sTerrID & ".csv"
'    TargetURL = convertToURL(sFullTargPath)

'// open QTerrxxx.csv
    sFullTargPath = csTerrDataPath & sTargPath & "/Working-Files/"_ 
		& sQBaseName & sTerrID & ".csv"
		
if 1 = 1 then
	TargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
dim Args(1)	As new com.sun.star.beans.PropertyValue 
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
   Args(0).name = "Hidden"
   Args(0).value = False
    oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())
endif

if 0 = 1 then
  xray oTestDoc
endif
'// open TerrxxxHdr.ods; sTargPath = "Terrxxx"
    sFullTargPath = csTerrDataPath & "/Working-Files/"_ 
		& sTargPath & "Hdr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	TargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args2())
dim iResp as integer
	iResp = msgbox("Both .ods files opened..." & chr(13) & chr(10)_
	  & "  Drop 1st file?", MB_OKCANCEL+ MB_ICONQUESTION)
	if iResp = IDOK then
	   oTestDoc.close(1)
	endif
	
	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()	

	'// move to header sheet just exported.
	'// Now close the TerrxxxHdr.ods workbook.
	oTestDoc2.close(1)
	
'// Now ready to process territory.
	QToPubTerr3()
if 0 = 1 then	
	msgbox( "Moving to " & oTestDoc.getURL & "." & sBaseName & sTerrID )
	MoveToDocSheet( oTestDoc, sBaseName & sTerrID )
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBasePath & sTerrId)
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBaseName & sTerrID)
endif
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenQTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end OpenQTerrold	8/12/23.
'/**/
