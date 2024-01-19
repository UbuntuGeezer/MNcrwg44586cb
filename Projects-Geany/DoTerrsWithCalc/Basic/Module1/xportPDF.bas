'// ExportPDF.bas
'//---------------------------------------------------------------
'// ExportPDF - Export PubTerr to PDF.
'//		8/12/23.	wmk.
'//---------------------------------------------------------------

public sub ExportPDF( poDocPubTerr As Object )

'//	Usage.	macro call or
'//			call ExportPDF( oDocPubTerr )
'//
'//		oDocPubTerr = publisher territory workbook
'//
'// Entry.
'//
'//	Exit.	oDocPubTerr workbook saved as PDF
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 8/12/23.	wmk.	csURLBase dependency fixed in header.
'// Legacy mods.
'//	11/23/21.	wmk.	original code.
'// 12/17/21.	wmk.	bug fix in target URL always exporting to terr 235;
'//				 Module-wide var gsTerrID set.
'// 12/24/21.	wmk.	csURLBase set for chromeos host.
'//
'//	Notes. This exports the current Terrxxx_PubTerr.ods to a PDF.
'//

'//	constants.
'const csURLBase = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr"
'const csURLBase = "file:///home/vncwmk3/Territories/TerrData/Terr"
const csURLEnd = "_PubTerr.pdf"

'//	local variables.
dim sDocTitle	as String
dim sTerrID		AS String
dim sURLFull	AS String

	'// code.
	ON ERROR GOTO ErrorHandler
	
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
oDocument   = poDocPubTerr.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

sDocTitle = oDocument.Title
sTerrID = mid(sDocTitle,5,3)
gsTerrID = sTerrID
sURLFull = csURLBase & sTerrID & "/Terr" & sTerrID & csURLEnd

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr235/Terr235_PubTerr.pdf"
args1(0).Value = sURLFull
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ReduceImageResolution",0,true,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EnableTextAccessForAccessibilityTools",0,true,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ConvertOOoTargetToPDFTarget",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportBookmarksToPDFDestination",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PreparedPermissionPassword",0,_
 Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

oDispatcher.executeDispatch(oDocument, ".uno:ExportToPDF", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ExportPDF - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ExportPDF		8/12/23.
'/**/
'// xportPDF.bas
sub xportPDF

'// Modification History.
'// ---------------------
'// 8/12/23.	wmk.	export path modified for MNcrwg44586.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
args1(0).Value = "file:///home/vncwmk3/GitHub/TerritoriesCB/MNcrwg44586/Projects-Geany/DoTerrsWithCalc/ProcessQTerrs12.pdf"
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ReduceImageResolution",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFUACompliance",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableTextAccessForAccessibilityTools",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ConvertOOoTargetToPDFTarget",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarksToPDFDestination",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPermissionPassword",0,Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

dispatcher.executeDispatch(document, ".uno:ExportToPDF", "", 0, args1())


end sub		'// end xportPDF
'/**/
