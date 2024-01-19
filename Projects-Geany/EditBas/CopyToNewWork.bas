'// CopyToNewWork.bas
'//---------------------------------------------------------------
'// CopyToNewWork - Copy selected sheet to new workbook.
'//		12/23/21.	wmk.	21:26
'//---------------------------------------------------------------

public sub CopyToNewWork(psDocName As String)

'//	Usage.	macro call or
'//			call CopyToNewWork(sDocName)
'//
'//		sDocName = name of new workbook
'//
'// Entry.	user has sheet selected that will be copied to new workbook
'//
'//	Exit.	selected sheet copied into new workbook
'//			goNewWorkdoc = document pointer
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/14/20.	wmk.	original code.
'// 7/10/21.	wmk.	record new workbook selection.
'// 7/12/21.	wmk.	add inline code to save with sheet name, add
'//						inlilne code to save as .xlsx and export to pdf.
'// 7/14/21.	wmk.	save path corrected to add in missing TerrData;
'//				 remove superfluous "." when saving to xlsx and pdf.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDataPath module-wide
'//				 constants for multihost support.
'//
'//	Notes.
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above"

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = ""
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())
dim oDoc	As Object
dim oSel	As Object
oDoc = ThisComponent.CurrentController.Frame
goNewWorkDoc = oDoc

'// include SaveAs code here.
'// now focus is on Untitled x.ods new workbook; save it
'// there is no URL for it, so will have to generate a SaveAs
'// uno request...
dim sPubTerrURL		As String
dim sPubTargPath	As String
dim sPubTerrBase	As String
dim sPubTargURL		As String
dim oPubTerrDoc		As Object
dim sTerrID			As String
dim sBasePath		As String
	sBasePath = "/Terr"
	sTerrID = mid(psDocName,5,3)
	oPubTerrDoc = ThisComponent.CurrentController.Frame
	sPubTerrBase = "_PubTerr"
    sPubTargPath = csTerrDataPath &amp; sBasePath + sTerrID _ 
		+ sBasePath + sTerrID + sPubTerrBase + ".ods"
	sPubTargURL = convertToURL(sPubTargPath)
	
	'// inline SaveAs to save Terrxxx_PubTerr.ods

rem ----------------------------------------------------------------------
rem get access to the document
'dim document   as object
'dim dispatcher as object

'document   = ThisComponent.CurrentController.Frame
'dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args2(1) as new com.sun.star.beans.PropertyValue
args2(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories
'                    /TerrData/Terrxxx/TerrData/Terrxxx_PubTerr.ods"
args2(0).Value = sPubTargURL
args2(1).Name = "FilterName"
args2(1).Value = "calc8"

dispatcher.executeDispatch(oPubTerrDoc, ".uno:SaveAs", "", 0, args2())
oPubTerrDoc = ThisComponent.CurrentController.Frame

'// now save it as .xlsx...
dim sXlsxURL	As String
	sXlsxURL = left(sPubTargURL, len(sPubTargURL)-3) + "xlsx"
dim args3(1) as new com.sun.star.beans.PropertyValue
args3(0).Name = "URL"
'// args2(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories" _
'//   || "/TerrData/Terr241/Terr241_PubTerr.xlsx"
args3(0).Value = sXlsxURL
args3(1).Name = "FilterName"
args3(1).Value = "Calc MS Excel 2007 XML"

dispatcher.executeDispatch(oPubTerrDoc, ".uno:SaveAs", "", 0, args3())

'// now export it as .pdf...

dim sPDFurl		As String
	sPDFurl = left(sPubTargURL,len(sPubTargURL)-3) + "pdf"
dim args4(2) as new com.sun.star.beans.PropertyValue
args4(0).Name = "URL"
args4(0).Value = sPDFurl
args4(1).Name = "FilterName"
args4(1).Value = "calc_pdf_Export"
args4(2).Name = "FilterData"
args4(2).Value = Array(Array("UseLosslessCompression",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ReduceImageResolution",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableTextAccessForAccessibilityTools",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ConvertOOoTargetToPDFTarget",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarksToPDFDestination",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPermissionPassword",0,Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

dispatcher.executeDispatch(oPubTerrDoc, ".uno:ExportToPDF", "", 0, args4())

'dim args5
'dispatcher.executeDispatch(oPubTerrDoc, ".uno:Close", "", 0, args5())

'oPubTerrDoc = ThisComponent.CurrentController.Frame
oPubTerrDoc.Close(1)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyToNewWork - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyToNewWork	12/23/21	21:26
