;~ https://www.autoitscript.com/forum/topic/176895-xmlau3-v-11110-formerly-xmlwrapperexau3-beta-support-topic/?do=findComment&comment=1315663

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
#Tidy_Parameters=/sort_funcs /reel

#include <array.au3>
#include <date.au3>
#include <MsgBoxConstants.au3>
#include "XML.au3"

; This COM Error Hanlder will be used globally (excepting inside UDF Functions)
Global $oErrorHandler = ObjEvent("AutoIt.Error", ErrFunc_CustomUserHandler_MAIN)
#forceref $oErrorHandler

; This is SetUp for the transfer UDF internal COM Error Handler to the user function
_XML_ComErrorHandler_UserFunction(ErrFunc_CustomUserHandler_XML)

Example_Shrapnel()

#Region XML__Examples.au3 - Function

Func Example_Shrapnel()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)
	If @error Then
		MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
	Else
		; Load file to $oXmlDoc
		Local $sXML_Content = _
				'<?xml version="1.0" encoding="utf-8" ?> ' & @CRLF & _
				'<MagellanClient>' & @CRLF & _
				'	<Version Current="1.5.1.7e" Previous="1.5.1.7d" Updated="05/17/2016" ZipFile="Magellan.zip"/>' & @CRLF & _
				'</MagellanClient>'
		_XML_LoadXml($oXMLDoc, $sXML_Content)
		If @error Then
			MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
		Else
			_XML_SetAttrib($oXMLDoc, '/MagellanClient/Version', 'Current', '1.5.1.7f')
			If @error Then MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
			_XML_SetAttrib($oXMLDoc, '/MagellanClient/Version', 'Previous', '1.5.1.7e')
			If @error Then MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))

			; TIDY xml and save result back to object
			$oXMLDoc.loadXML(_XML_TIDY($oXMLDoc))

			; View in default System Viewer
			_XML_Misc_Viewer($oXMLDoc)
		EndIf
	EndIf
EndFunc   ;==>Example_Shrapnel
#EndRegion XML__Examples.au3 - Function

#Region XML__Examples.au3 - XML DOM Error/Event Handling

Func ErrFunc_CustomUserHandler_MAIN($oError)

	ConsoleWrite(@ScriptName & " (" & $oError.scriptline & ") : MainScript ==> COM Error intercepted !" & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>ErrFunc_CustomUserHandler_MAIN

Func ErrFunc_CustomUserHandler_XML($oError)

	; here is declared another path to UDF au3 file
	; thanks to this with using _XML_ComErrorHandler_UserFunction(ErrFunc_CustomUserHandler_XML)
	;  you get errors which after pressing F4 in SciTE4AutoIt you goes directly to the specified UDF Error Line
	ConsoleWrite(@ScriptDir & '\XML.au3' & " (" & $oError.scriptline & ") : UDF ==> COM Error intercepted ! " & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>ErrFunc_CustomUserHandler_XML
#EndRegion XML__Examples.au3 - XML DOM Error/Event Handling
