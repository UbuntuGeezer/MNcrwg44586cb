'// ExportTerrAsPDF.bas
'//--------------------------------------------------------------------
'// ExportTerrAsPDF - Export territory workbook as PDF.
'//		12/23/21.	wmk.	23:04
'//--------------------------------------------------------------------

public sub ExportTerrAsPDF()

'// Entry.	user has _PubTerr sheet selected
'//
'//	Exit.	current sheet exported as PDF
'//
'// Usage.	macro call or
'//			call ExportTerrAsPDF()
'//
'// Entry.	user has worksheet selected
'//
'//	Exit.	copy of worksheet made to .pdf file
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 1/14/21.	wmk.	original code; cloned from macro recording.
'//	7/10/21.	wmk.	dispatch parameter list split for readability.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDataPath module-wide
'//				 constants for multihost support.
'//
'//	Notes.
'//

'//	constants.
'// const csTerrBase = "defined above"
'// const csTerrDataPath = "defined above"

'//	local variables.
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
args1(0).Value = "file://" &amp; csTerrBase &amp; "/Untitled.pdf"
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,_ 
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_ 
	Array("Quality",0,90,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ReduceImageResolution",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("MaxImageResolution",0,300,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("UseTaggedPDF",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SelectPdfVersion",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportNotes",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ViewPDFAfterExport",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportBookmarks",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SinglePageSheets",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("OpenBookmarkLevels",0,-1,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("UseTransitionEffects",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("IsSkipEmptyPages",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportPlaceholders",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("IsAddStream",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportFormFields",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("FormsType",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("AllowDuplicateFieldNames",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("HideViewerToolbar",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("HideViewerMenubar",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("HideViewerWindowControls",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ResizeWindowToInitialPage",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("CenterWindow",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("OpenInFullScreenMode",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("DisplayPDFDocumentTitle",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("InitialView",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Magnification",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Zoom",0,100,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("PageLayout",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("FirstPageOnLeft",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("InitialPage",0,1,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Printing",0,2,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Changes",0,4,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("EnableCopyingOfContent",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("EnableTextAccessForAccessibilityTools",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportLinksRelativeFsys",0,true,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("PDFViewSelection",0,0,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ConvertOOoTargetToPDFTarget",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("ExportBookmarksToPDFDestination",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignPDF",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("_OkButtonString",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Watermark",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("EncryptFile",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("PreparedPasswords",0,,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("RestrictPermissions",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("PreparedPermissionPassword",0,_
	Array(),_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("Selection",0,,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignatureLocation",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignatureReason",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignatureContactInfo",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignaturePassword",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignatureCertificate",0,,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("SignatureTSA",0,"",_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
	Array("UseReferenceXObject",0,false,_
	 com.sun.star.beans.PropertyState.DIRECT_VALUE))

dispatcher.executeDispatch(document, ".uno:ExportToPDF", "", 0, args1())

end sub			'// end ExportTerrAsPDF		12/23/21.	23:04
