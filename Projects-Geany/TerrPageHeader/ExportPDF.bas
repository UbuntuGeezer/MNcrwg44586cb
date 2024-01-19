'// ExportPDF.bas
'//---------------------------------------------------------------
'// ExportPDF - Export PubTerr to PDF.
'//		11/23/21.	wmk.	17:43
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
'//	11/23/21.		wmk.	original code.
'//
'//	Notes. This exports the current Terrxxx_PubTerr.ods to a PDF.
'//

'//	constants.

'//	local variables.

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

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr235/Terr235_PubTerr.pdf"
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
	
end sub		'// end ExportPDF		11/23/21.	17:43
