'// ExportTerrAsPDF1.bas
'//---------------------------------------------------------------
'// ExportTerrAsPDF1 - Export territory sheet as PDF file.
'//		7/12/21.	wmk.	00:17
'//---------------------------------------------------------------

public sub ExportTerrAsPDF1()

'//	Usage.	macro call or
'//			call ExportTerrAsPDF()
'//
'// Entry.	user has _PubTerr sheet selected
'//
'//	Exit.	current sheet exported as PDF
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	1/14/21.		wmk.	original code; cloned from Record Macro
'//
'//	Notes. This sub allows the user to export a _PubTerr sheet as
'// a PDF file. This file will usually be part of a set for a given
'// territory consisting of .ods, .xlsx and .pdf files. This will allow
'// users to select whichever format they are comfortable working with.
'//

'//	constants.

'//	local variables.

dim oDoc	AS Object
dim sTitle	AS String
dim sTerrID AS String
dim sFile	AS String
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object


	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	sTitle = oDoc.getTitle()
	sTerrID = mid(sTitle,5,3)
	
	sFile = "file:///media/ubuntu/Windows/Users/Bill/Territories" _
   + "/TerrData/Terr" + sTerrID + "/" + "Terr" + sTerrID + "_PubTerr.pdf"
	

rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
args1(0).Value = sFile
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ReduceImageResolution",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableTextAccessForAccessibilityTools",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ConvertOOoTargetToPDFTarget",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarksToPDFDestination",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPermissionPassword",0,Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

dispatcher.executeDispatch(document, ".uno:ExportToPDF", "", 0, args1())

if 1 = 0 then
msgbox("Terr" + sTerrID + "_PubTerr.pdf created successfully",0,"ExportTerrAsPDF")
endif
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ExportTerrAsPDF1 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ExportTerrAsPDF1	7/12/21	00:17
