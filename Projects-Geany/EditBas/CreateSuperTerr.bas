'// CreateSuperTerr.bas
'//---------------------------------------------------------------
'// CreateSuperTerr - Create SuperTerr from territory.
'//		12/23/21.	wmk.	16:34
'//---------------------------------------------------------------

public sub CreateSuperTerr( psTerrID As String )

'//	Usage.	macro call or
'//			call CreateSuperTerr( sTerrID )
'//
'//		sTerrID = territory ID
'//
'// Entry.	~/Territories/TerrData/Terrxxx/Terrxxx_PubTerr.ods exists
'//			  as generated territory xxx.
'//			~/Territories/.../Working-Files/QTerrxxx.ods exists with
'//			  up-to-date territory records in Bridge table,  in
'//			  Terrxxx_Bridge sheet
'//
'//	Exit.	~/Territories/.../Terrxxx/Terrxxx_SuperTerr.ods created
'//				and Terrxxx_SuperTerr.xlsx created
'//
'// Calls. BridgeToSuper.
'//
'//	Modification history.
'//	---------------------
'//	7/12/21.	wmk.	original code.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDataPath for
'//				 multihost support.
'//				
'//	Notes. CreateSuperTerr takes an existing workbook with sheet
'//	Terrxxx_Bridge and creates a SuperTerritory
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above"

'//	local variables.
dim sTerrID				As string
'// uno document vars.
dim oTestDoc	As Object			'// QTerrxxx.ods
dim oTestDoc2	As Object			'// Terrxxx_PubTerr.ods
dim sBaseName	As String
dim sBasePath	As String
dim sTargPath	As String
dim sFullTargPath	As String
dim sTargetURL	As String

	'// code.
	ON ERROR GOTO ErrorHandler
	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID

	'// open QTerrxxx.ods (contains Terrxxx_Bridge table)
	'// open QTerrxxx.ods to process.

    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())

	'// QTerrxxx.ods is active workbook, process Bridge to Super territory.
	BridgeToSuper()
	'// at this point, should be in PubTerr with Search sheet added...
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CreateSuperTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CreateSuperTerr	12/23/21.	16:34
