'// DoTerrWithCalc.bas - Process territory from .csv to PubTerr.
'//---------------------------------------------------------------
'// DoTerrWithCalc - Process territory from .csv to PubTerr.
'//		8/28/21.	wmk.	09:15
'//---------------------------------------------------------------

public sub DoTerrWithCalc( psTerrID )

'//	Usage.	macro call or
'//			call DoTerrWithCalc( sTerrID )
'//
'//		sTerrID = territory ID to do with Calc
'//
'// Dependencies. This sub must be resident in Territories Library.
'//
'// Entry.	goTerrODSdoc = (reserved) component for territory ODS 
'//			  workbook	
'//
'//	Exit.	goTerrODSdoc = territory ODS workbook component
'//
'// Calls.	OpenQTerr, AddHdrToQTerr
'// 	SaveCsvToODS, QToPubTerr3, MoveToDocSheet,SaveTerrAsODS,
'//		FreezeView.
'//
'//	Modification history.
'//	---------------------
'//	7/10/21.	wmk.	original code; goTerrODSdoc global var
'//							dependency added.
'// 7/11/21.	wmk.	code advanced to point of saving territory
'//						workbook as	.ods file; SaveQsvODS moved to
'//						QOpenCSV
'// 8/28/21.	wmk.	comments corrected; FreezeView call added.
'//
'//	Notes. DoTerrWithCalc will eventually completely process a territory
'// from its QTerrxxx.csv file all the way through to formatting and
'// saving the PubTerr and SuperTerr versions.
'// SetGridLand dialog gets in the way of frame focusing... figure out
'// where to put it..
'//

'//	constants.

'//	local variables.
dim sTerrID			As	String			'// copy of passed territory ID
dim oDoc			As	Object			'// ThisComponent to save to gs
dim oUntitledDoc	As 	Object			'// untitled PubTerr
dim oParentDoc		As	Object			'// parent document of PubTerr workbook

	'// code.
	ON ERROR GOTO ErrorHandler
	sTerrID = psTerrID
	OpenQTerr( sTerrID )
	AddHdrToQTerr(sTerrID)
	QodsToPubTerr(sTerrID)

if 1 = 1 then
  GoTo NormalExit
endif

	oDoc = ThisComponent
'	goCurrDocument = ThisComponent
'	SaveQCsvODS
	oDoc.Close(1)			'// close the newly saved QTerrxxx.ods
	

dim oSel		As Object
	oParentDoc = ThisComponent	'// set doc to current component
'	goTerrODSdoc = oDoc
	QToPubTerr
	oUntitledDoc = ThisComponent
	oSel = oUntitledDoc.getCurrentSelection()
	MoveToDocSheet(oUntitledDoc, "Terr240_PubTerr")
	
'	SetGridLand			'// set Grid on, landscape format
'	MoveToDocSheet(oUntitledDoc, "Terr240_PubTerr")		'// reset focus
'	oDoc = goNewWorkdoc
	oSel = oUntitledDoc.getCurrentSelection()
	MoveToDocSheet(oDoc, "Terr240_PubTerr")
	FreezeView()
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()	
	SaveTerrAsODS(oUntitledDoc,oParentDoc.getURL())		'// save new workbook Untitled n.ods as ods
if 1 = 0 then
	SaveXlsx			'// save for Excel
	ExportTerrAsPDF		'// export PDF file
endif

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("DoTerrWithCalc - unprocessed error")
	GoTo NormalExit
	
end sub		'// end DoTerrWithCalc	7/11/21.	22:09
