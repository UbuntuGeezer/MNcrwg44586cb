'// AddHdrToQBTerr.bas
'//--------------------------------------------------------------------
'// AddHdrToQBTerr - Add TerrxxxHdr sheet to biz QTerrxxx.ods workbook.
'//		12/23/21.	wmk.	16:30
'//--------------------------------------------------------------------

public sub AddHdrToQBTerr( psTerrID As String )

'//	Usage.	call AddHdrToQBTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.ods
'//				contains territory records for territory xxx, in sheet
'//				QTerrxxx.
'//			Territories/.../TerrData/Terrxxx/Working-Files/TerrxxxHdr.ods
'//				contains territory header information from TerrIDData.db
'//
'//	Exit.	QTerrxxx.ods has sheet TerrxxxHdr added as last sheet, from
'//			workbook TerrxxxHdr.ods
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/11/21.	wmk.	original code; adapted from abandoned code
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
