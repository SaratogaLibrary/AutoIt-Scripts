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

Example_1__XML_SelectNodes()

#Region XML__Examples.au3 - Function

Func Example_1__XML_SelectNodes()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)
	If @error Then
		MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
	Else
		; Load file to $oXmlDoc
		Local $sXML_Content = "" & _
				"<Checkin>" & _
				"<Item CatalogID='ID_15674'>" & _
				"        <SUPPLIER_NAME_STRING id='ID1014_161'/>" & _
				"        <BRANDNAME_STRING id='ID1043_111'/>" & _
				"        <QRYTEXT_STRING id='ID1082_8519'/>" & _
				"        <RARITY_STATUS id='ID1164_2'/>" & _
				"        <ARTID value='27700'/>" & _
				"        <SUPPLIER_NUMBER value='127700'/>" & _
				"        <OFFSET_ID value='ID_22265'/>" & _
				"        <STAMP value='256/350'/>" & _
				"        <STYLE value='1'/>" & _
				"        <IS_PROMOTIONAL value='0'/>" & _
				"</Item>" & _
				"<Item CatalogID='ID_15675'>" & _
				"        <SUPPLIER_NUMBER value='389844'/>" & _
				"        <OFFSET_ID value='ID_15674'/>" & _
				"        <IS_COMPLETED/> " & _
				"</Item>" & _
				"</Checkin>" & _
				""
		_XML_LoadXml($oXMLDoc, $sXML_Content)
		If @error Then
			MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
		Else
			; selecting nodes
			_XML_SelectNodes($oXMLDoc, "//Item")
			If @error Then
				MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
			Else
				Local $iNodesCount = @extended
				For $iItem_idx = 1 To $iNodesCount
					Local $oChilds_Coll = _XML_SelectNodes($oXMLDoc, '//Checkin/Item[' & $iItem_idx & ']/*')
					Local $aNodesColl = _XML_Array_GetNodesProperties($oChilds_Coll)
					If @error Then
						MsgBox(0, '', _XML_ErrorParser_GetDescription($oXMLDoc))
					Else
						; display array
						_ArrayDisplay($aNodesColl, 'Example_1__XML_SelectNodes ' & $iItem_idx)
					EndIf
				Next
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Example_1__XML_SelectNodes
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
