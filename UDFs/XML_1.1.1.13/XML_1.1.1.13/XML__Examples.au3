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

;Example_1__XML_SelectNodes()

;~ Example_2__XML_CreateChildWAttr()
;~ If @error Then MsgBox(0, 'Example_2__XML_CreateChildWAttr(): @error:', XML_My_ErrorParser(@error, @extended))

;~ Example_2a__XML_CreateChildWAttr()

;~ Example_3__XML_ErrorParser_GetDescription()
;~ If @error Then MsgBox(0, 'Example_3__XML_ErrorParser_GetDescription(): @error:', XML_My_ErrorParser(@error, @extended))

;Example_4__XML_RemoveAttribute()
;If @error Then MsgBox(0, 'Example_4__XML_RemoveAttribute(): @error:', XML_My_ErrorParser(@error, @extended))

;Example_5__XML_ReplaceChild()
;If @error Then MsgBox(0, 'Example_5__XML_ReplaceChild(): @error:', XML_My_ErrorParser(@error, @extended))

;~ Example_6__XML_GetChildNodes()
;~ If @error Then MsgBox(0, 'Example_6__XML_GetChildNodes(): @error:', XML_My_ErrorParser(@error, @extended))

;~ Example_7__XML_GetAllAttribIndex()
;~ If @error Then MsgBox(0, 'Example_7__XML_GetAllAttribIndex(): @error:', XML_My_ErrorParser(@error, @extended))

;~ Example_8__XML_GetNodeAttributeValue()
;~ Example_8a__XML_GetNodeAttributeValue()
;~ If @error Then MsgBox(0, 'Example_8__XML_GetNodeAttributeValue(): @error:', XML_My_ErrorParser(@error, @extended))

;~ Example_9__XML_CreateFile()

;~ Example_9__XML_CreateFile()

Example_MSDN_1__setAttributeNode()
;~ TODO: Example_MSDN_2__Atribute_Vale(); https://msdn.microsoft.com/en-us/library/ms757007(v=vs.85).aspx

#Region XMLWrapperEx__Examples.au3 - Function

Func Example_1__XML_SelectNodes()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)
	If @error Then
		MsgBox(0, '_XML_CreateDOMDocument @error:', XML_My_ErrorParser(@error))
	Else
		; now you can add EVENT Handler
		Local $oXMLDOM_EventsHandler = ObjEvent($oXMLDoc, "XML_DOM_EVENT_")
		#forceref $oXMLDOM_EventsHandler

		; Load file to $oXmlDoc
		Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
		_XML_Load($oXMLDoc, $sXmlFile)
		If @error Then
			MsgBox(0, '_XML_Load @error:', XML_My_ErrorParser(@error))
		Else

			; simple display $oXmlDoc - for checking only
			Local $sXmlAfterTidy = _XML_TIDY($oXMLDoc)
			If @error Then
				MsgBox(0, '_XML_TIDY @error:', XML_My_ErrorParser(@error))
			Else
				MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Example_1__XML_SelectNodes', $sXmlAfterTidy)
			EndIf

			; selecting nodes
			Local $oNodesColl = _XML_SelectNodes($oXMLDoc, "//price")
			If @error Then
				MsgBox(0, '_XML_SelectNodes @error:', XML_My_ErrorParser(@error))
			Else
				; change Nodes Collection to array
				Local $aNodesColl = _XML_Array_GetNodesProperties($oNodesColl)
				If @error Then
					MsgBox(0, '_XML_Array_GetNodesProperties @error:', XML_My_ErrorParser(@error))
				Else
					; display array
					_ArrayDisplay($aNodesColl, 'Example_1__XML_SelectNodes : ' & 'Length=' & $oNodesColl.length & '   XPath=' & $oNodesColl.expr)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc    ;==>Example_1__XML_SelectNodes

Func Example_2__XML_CreateChildWAttr()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Before Example_2__XML_CreateChildWAttr()', _XML_TIDY($oXMLDoc))

	Local $aAttributeList[2][2] = [['First', '1'], ['Second', '2']]
	_XML_CreateChildWAttr($oXMLDoc, "//book", 'Language', $aAttributeList, "English")

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'After Example_2__XML_CreateChildWAttr()', _XML_TIDY($oXMLDoc))

	$oXMLDoc.loadXML(_XML_TIDY($oXMLDoc))

	; View in default System Viewer
	_XML_Misc_Viewer($oXMLDoc)

EndFunc    ;==>Example_2__XML_CreateChildWAttr

Func Example_2a__XML_CreateChildWAttr()

	; this following line is only for testing
	ConsoleWrite(@ScriptLineNumber & @CRLF)

	Local $oXMLDoc = _XML_CreateFile("settings2.xml", "Settings", True)
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		Return 0
	EndIf

	; this following line is only for testing
	ConsoleWrite(@ScriptLineNumber & @CRLF)

	Local $aAttr[2][2] = [["type", "name"], ["Menu", "Test"]]
	_XML_CreateChildWAttr($oXMLDoc, "//Settings", "Node0", $aAttr)
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '_XML_ErrorParser_GetDescription', _XML_ErrorParser_GetDescription($oXMLDoc))
		Return 0
	EndIf

	_XML_LoadXML($oXMLDoc, _XML_TIDY($oXMLDoc))

	; this following line is only for testing
	ConsoleWrite(@ScriptLineNumber & @CRLF)

	_XML_SaveToFile($oXMLDoc, "settings2.xml")
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '', _XML_ErrorParser_GetDescription($oXMLDoc))

		; normaly should return with 0
		; Return 0
		; but for this example I want to show that that you can not save to the same file
		; as this is for data (file) security you should manage it by your own
	EndIf

	; this following line is only for testing
	ConsoleWrite(@ScriptLineNumber & @CRLF)

	_XML_SaveToFile($oXMLDoc, "settings3.xml")
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '', _XML_ErrorParser_GetDescription($oXMLDoc))
		Return 0
	EndIf

	; finally Function reach the end , and THIS IS SUCCESS --> Return 1
	Return 1

EndFunc    ;==>Example_2a__XML_CreateChildWAttr

Func Example_3__XML_ErrorParser_GetDescription()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)
	If @error = $XML_ERR_XPATH Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
	EndIf

	; now we fires COM Error
	; selecting nodes with incorrect XPath expression
	Local $oNodesColl = _XML_SelectNodes($oXMLDoc, "/1/price")
	#forceref $oNodesColl
	If @error = $XML_ERR_XPATH Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '_XML_ErrorParser_GetDescription', _XML_ErrorParser_GetDescription($oXMLDoc))
	EndIf

	; now we try fires $oXmlDoc.parseError.errorCode - wrong XML file
	; again create a new clean $oXmlDoc object
	$oXMLDoc = _XML_CreateDOMDocument()

	; Load file to $oXmlDoc
	$sXmlFile = @ScriptFullPath
	_XML_Load($oXMLDoc, $sXmlFile)
	If @error = $XML_ERR_PARSE Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '_XML_ErrorParser_GetDescription', _XML_ErrorParser_GetDescription($oXMLDoc))
	EndIf

EndFunc    ;==>Example_3__XML_ErrorParser_GetDescription

Func Example_4__XML_RemoveAttribute()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	Local $aAttributeList[2][2] = [['First', '1'], ['Second', '2']]
	_XML_CreateChildWAttr($oXMLDoc, "//book", 'MyNewNode', $aAttributeList, "SomeText")

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Befor Example_4__XML_RemoveAttribute()', _XML_TIDY($oXMLDoc))

	_XML_RemoveAttribute($oXMLDoc, "//MyNewNode[1]", 'Second')
	If @error Then MsgBox($MB_ICONERROR, 'Example_4__XML_RemoveAttribute', _
			'@error = ' & @error & @CRLF & '@extended = ' & @extended)

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'After Example_4__XML_RemoveAttribute()', _XML_TIDY($oXMLDoc))

	; TIDY xml and save result back to object
	$oXMLDoc.loadXML(_XML_TIDY($oXMLDoc))

	; View in default System Viewer
	_XML_Misc_Viewer($oXMLDoc)

EndFunc    ;==>Example_4__XML_RemoveAttribute

Func Example_5__XML_ReplaceChild()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	_XML_ReplaceChild($oXMLDoc, '//price', 'TextBook')

	; TIDY xml and save result back to object
	$oXMLDoc.loadXML(_XML_TIDY($oXMLDoc))

	; View in default System Viewer
	_XML_Misc_Viewer($oXMLDoc)

EndFunc    ;==>Example_5__XML_ReplaceChild

Func Example_6__XML_GetChildNodes()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Example_6__XML_GetChildNodes', _XML_TIDY($oXMLDoc))

	; selecting nodes
	Local $oNodesColl = _XML_GetChildNodes($oXMLDoc, "//book")

	; change Nodes Collection to array
	Local $aNodesColl = _XML_Array_GetNodesProperties($oNodesColl)
	_ArrayDisplay($aNodesColl, 'Example_6__XML_GetChildNodes: ' & 'Length=' & $oNodesColl.length & '   XPath=' & $oNodesColl.expr)

EndFunc    ;==>Example_6__XML_GetChildNodes

Func Example_7__XML_GetAllAttribIndex()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	Local $aAttributeList[2][2] = [['First', '1'], ['Second', '2']]
	_XML_CreateChildWAttr($oXMLDoc, "//book", 'MyNewNode', $aAttributeList, "SomeText")

	_XML_RemoveAttribute($oXMLDoc, "//MyNewNode[1]", 'Second')

	; TIDY xml and save result back to object
	$oXMLDoc.loadXML(_XML_TIDY($oXMLDoc))

	; View in default System Viewer
	_XML_Misc_Viewer($oXMLDoc)

	Local $oAttriubtes = _XML_GetAllAttribIndex($oXMLDoc, '//MyNewNode', 0)
	Local $aAttributesList = _XML_Array_GetAttributesProperties($oAttriubtes)

	_ArrayDisplay($aAttributesList, '$aAttributesList')

EndFunc    ;==>Example_7__XML_GetAllAttribIndex

Func Example_8__XML_GetNodeAttributeValue()
	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	Local $aAttributeList[2][2] = [['First', '1a'], ['Second', '2b']]
	_XML_CreateChildWAttr($oXMLDoc, "//book", 'MyNewNode', $aAttributeList, "SomeText")
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	Local $oAttriubtes = _XML_GetAllAttribIndex($oXMLDoc, '//MyNewNode', 0)
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	Local $aAttributesList = _XML_Array_GetAttributesProperties($oAttriubtes)
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	Local $oNode_Selected_SingleOne = _XML_SelectSingleNode($oXMLDoc, '//MyNewNode[1]')
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	Local $sAttribute_Value = _XML_GetNodeAttributeValue($oNode_Selected_SingleOne, 'First')
	If @error Then Return SetError(@error, @extended, $XML_RET_FAILURE)

	_ArrayDisplay($aAttributesList, '$sAttribute_Value = ' & $sAttribute_Value)

EndFunc    ;==>Example_8__XML_GetNodeAttributeValue

Func Example_8a__XML_GetNodeAttributeValue()
	Local $oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc_CustomUserHandler")
	#forceref $oErrorHandler

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument()

	; load XML data to the object
	_XML_LoadXML($oXMLDoc, '<?xml version="1.0" encoding="Windows-1258" standalone="no"?><Settings>' & @CRLF & '<node0 type="menu0"/>' & @CRLF & '</Settings>')

	; Tidy XML
	_XML_LoadXML($oXMLDoc, _XML_TIDY($oXMLDoc))

;~ 	MsgBox(64, "", _XML_NodeExists($oXMLDoc, "Settings/node0")) ; Return 1 ok

	; selecting single node
	Local $oNode = _XML_SelectSingleNode($oXMLDoc, "Settings/node0")
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
	EndIf

	; get single atribute from single node
	Local $sAtributeValue = _XML_GetNodeAttributeValue($oNode, "type")
	If @error Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
	Else
		MsgBox(0, '$sAtributeValue', $sAtributeValue)
	EndIf

EndFunc    ;==>Example_8a__XML_GetNodeAttributeValue

Func Example_9__XML_CreateFile()
	Local $oXMLDoc = _XML_CreateFile(@ScriptDir & "\XML_Example_XML_Files\settings.xml", "SETTINGS", True)
	#forceref $oXMLDoc

EndFunc    ;==>Example_9__XML_CreateFile

Func Example_MSDN_1__setAttributeNode()

	; first you must create $oXmlDoc object
	Local $oXMLDoc = _XML_CreateDOMDocument(Default)

	; Load file to $oXmlDoc
	Local $sXmlFile = @ScriptDir & "\XML_Example_XML_Files\MSDN\books.xml"
	_XML_Load($oXMLDoc, $sXmlFile)

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Example_MSDN_1__setAttributeNode', _XML_TIDY($oXMLDoc))

	;MSDN; https://msdn.microsoft.com/en-us/library/ms762235(v=vs.85).aspx

	;MSDN; nodePublishDate = xmlDoc.createAttribute("PublishDate");
	Local $oNodePublishDate = $oXMLDoc.createAttribute("PublishDate") ;

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Temp', _XML_TIDY($oXMLDoc)) ; Hmmm... Nothing happend

	;MSDN; nodePublishDate.value = String(Date());
	$oNodePublishDate.value = String(_Now()) ;

	;MSDN; nodeBook = xmlDoc.selectSingleNode("//book");
	Local $oNodeBook = $oXMLDoc.selectSingleNode("//book") ;

	;MSDN; nodeBook.setAttributeNode(nodePublishDate);
	$oNodeBook.setAttributeNode($oNodePublishDate) ;

	;MSDN; WScript.Echo(nodeBook.getAttribute("PublishDate"));
	ConsoleWrite($oNodeBook.getAttribute("PublishDate") & @CRLF)

	; simple display $oXmlDoc - for checking only
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Result', _XML_TIDY($oXMLDoc))

	; this following part is not related to MSDN but is usefull to show how _XML_Array_GetNodesProperties display attributes
	Local $oNodesColl = _XML_SelectNodes($oXMLDoc, "//book")

	; change Nodes Collection to array
	Local $aNodesColl = _XML_Array_GetNodesProperties($oNodesColl)
	_ArrayDisplay($aNodesColl, 'Example_1__XML_SelectNodes : ' & $oNodesColl.expr)

EndFunc    ;==>Example_MSDN_1__setAttributeNode
#EndRegion  XMLWrapperEx__Examples.au3 - Function

#Region XMLWrapperEx__Examples.au3 - XML DOM Error/Event Handling

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
EndFunc    ;==>ErrFunc_CustomUserHandler_MAIN

Func ErrFunc_CustomUserHandler_XML($oError)

	; here is declared another path to UDF au3 file
	; thanks to this with using _XML_ComErrorHandler_UserFunction(ErrFunc_CustomUserHandler_XML)
	;  you get errors which after pressing F4 in SciTE4AutoIt you goes directly to the specified UDF Error Line
	ConsoleWrite(@ScriptDir & '\XMLWrapperEx.au3' & " (" & $oError.scriptline & ") : UDF ==> COM Error intercepted ! " & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc    ;==>ErrFunc_CustomUserHandler_XML

Func XML_DOM_EVENT_ondataavailable()
	#CS
		ondataavailable Event
		https://msdn.microsoft.com/en-us/library/ms754530(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "ondataavailable"' & @CRLF
	ConsoleWrite($sMessage)
EndFunc    ;==>XML_DOM_EVENT_ondataavailable

Func XML_DOM_EVENT_onreadystatechange()
	#CS
		onreadystatechange Event
		https://msdn.microsoft.com/en-us/library/ms759186(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "onreadystatechange" : ReadyState = ' & $oEventObj.ReadyState & @CRLF
	ConsoleWrite($sMessage)

EndFunc    ;==>XML_DOM_EVENT_onreadystatechange

Func XML_DOM_EVENT_ontransformnode($oNodeCode_XSL, $oNodeData_XML, $bBool)
	#forceref $oNodeCode_XSL, $oNodeData_XML, $bBool
	#CS
		ontransformnode Event
		https://msdn.microsoft.com/en-us/library/ms767521(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "ontransformnode"' & @CRLF
	ConsoleWrite($sMessage)

EndFunc    ;==>XML_DOM_EVENT_ontransformnode

; #FUNCTION# ====================================================================================================================
; Name ..........: XML_My_ErrorParser
; Description ...: Changing $XML_ERR_ ... to human readable description
; Syntax ........: XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended)
; Parameters ....: $iXMLWrapper_Error	- an integer value.
;                  $iXMLWrapper_Extended           - an integer value.
; Return values .: description as string
; Author ........: mLipok
; Modified ......:
; Remarks .......: This function is only example of how user can parse @error and @extended to human readable description
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended = 0)
	Local $sErrorInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_SUCCESS
			$sErrorInfo = '$XML_ERR_SUCCESS=' & $XML_ERR_SUCCESS & @CRLF & 'All is ok.'
		Case $XML_ERR_GENERAL
			$sErrorInfo = '$XML_ERR_GENERAL=' & $XML_ERR_GENERAL & @CRLF & 'The error which is not specifically defined.'
		Case $XML_ERR_COMERROR
			$sErrorInfo = '$XML_ERR_COMERROR=' & $XML_ERR_COMERROR & @CRLF & 'COM ERROR OCCURED. Check @extended and your own error handler function for details.'
		Case $XML_ERR_ISNOTOBJECT
			$sErrorInfo = '$XML_ERR_ISNOTOBJECT=' & $XML_ERR_ISNOTOBJECT & @CRLF & 'No object passed to function'
		Case $XML_ERR_INVALIDDOMDOC
			$sErrorInfo = '$XML_ERR_INVALIDDOMDOC=' & $XML_ERR_INVALIDDOMDOC & @CRLF & 'Invalid object passed to function'
		Case $XML_ERR_INVALIDATTRIB
			$sErrorInfo = '$XML_ERR_INVALIDATTRIB=' & $XML_ERR_INVALIDATTRIB & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_INVALIDNODETYPE
			$sErrorInfo = '$XML_ERR_INVALIDNODETYPE=' & $XML_ERR_INVALIDNODETYPE & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_OBJCREATE
			$sErrorInfo = '$XML_ERR_OBJCREATE=' & $XML_ERR_OBJCREATE & @CRLF & 'Object can not be created.'
		Case $XML_ERR_NODECREATE
			$sErrorInfo = '$XML_ERR_NODECREATE=' & $XML_ERR_NODECREATE & @CRLF & 'Can not create Node - check also COM Error Handler'
		Case $XML_ERR_NODEAPPEND
			$sErrorInfo = '$XML_ERR_NODEAPPEND=' & $XML_ERR_NODEAPPEND & @CRLF & 'Can not append Node - check also COM Error Handler'
		Case $XML_ERR_PARSE
			$sErrorInfo = '$XML_ERR_PARSE=' & $XML_ERR_PARSE & @CRLF & 'Error: with Parsing objects, .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_PARSE_XSL
			$sErrorInfo = '$XML_ERR_PARSE_XSL=' & $XML_ERR_PARSE_XSL & @CRLF & 'Error with Parsing XSL objects .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_LOAD
			$sErrorInfo = '$XML_ERR_LOAD=' & $XML_ERR_LOAD & @CRLF & 'Error opening specified file.'
		Case $XML_ERR_SAVE
			$sErrorInfo = '$XML_ERR_SAVE=' & $XML_ERR_SAVE & @CRLF & 'Error saving file.'
		Case $XML_ERR_PARAMETER
			$sErrorInfo = '$XML_ERR_PARAMETER=' & $XML_ERR_PARAMETER & @CRLF & 'Wrong parameter passed to function.'
		Case $XML_ERR_ARRAY
			$sErrorInfo = '$XML_ERR_ARRAY=' & $XML_ERR_ARRAY & @CRLF & 'Wrong array parameter passed to function. Check array dimension and conent.'
		Case $XML_ERR_XPATH
			$sErrorInfo = '$XML_ERR_XPATH=' & $XML_ERR_XPATH & @CRLF & 'XPath syntax error - check also COM Error Handler.'
		Case $XML_ERR_NONODESMATCH
			$sErrorInfo = '$XML_ERR_NONODESMATCH=' & $XML_ERR_NONODESMATCH & @CRLF & 'No nodes match the XPath expression'
		Case $XML_ERR_NOCHILDMATCH
			$sErrorInfo = '$XML_ERR_NOCHILDMATCH=' & $XML_ERR_NOCHILDMATCH & @CRLF & 'There is no Child in nodes matched by XPath expression.'
		Case $XML_ERR_NOATTRMATCH
			$sErrorInfo = '$XML_ERR_NOATTRMATCH=' & $XML_ERR_NOATTRMATCH & @CRLF & 'There is no such attribute in selected node.'
		Case $XML_ERR_DOMVERSION
			$sErrorInfo = '$XML_ERR_DOMVERSION=' & $XML_ERR_DOMVERSION & @CRLF & 'DOM Version: ' & 'MSXML Version ' & $iXMLWrapper_Extended & ' or greater required for this function'
		Case $XML_ERR_EMPTYCOLLECTION
			$sErrorInfo = '$XML_ERR_EMPTYCOLLECTION=' & $XML_ERR_EMPTYCOLLECTION & @CRLF & 'Collections of objects was empty'
		Case $XML_ERR_EMPTYOBJECT
			$sErrorInfo = '$XML_ERR_EMPTYOBJECT=' & $XML_ERR_EMPTYOBJECT & @CRLF & 'Object is empty'
		Case Else
			$sErrorInfo = '=' & $iXMLWrapper_Error & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @error'
	EndSwitch

	Local $sExtendedInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_COMERROR, $XML_ERR_NODEAPPEND, $XML_ERR_NODECREATE
			$sExtendedInfo = 'COM ERROR NUMBER (@error returned via @extended) =' & $iXMLWrapper_Extended
		Case $XML_ERR_PARAMETER
			$sExtendedInfo = 'This @error was fired by parameter: #' & $iXMLWrapper_Extended
		Case Else
			Switch $iXMLWrapper_Extended
				Case $XML_EXT_DEFAULT
					$sExtendedInfo = '$XML_EXT_DEFAULT=' & $XML_EXT_DEFAULT & @CRLF & 'Default - Do not return any additional information'
				Case $XML_EXT_XMLDOM
					$sExtendedInfo = '$XML_EXT_XMLDOM=' & $XML_EXT_XMLDOM & @CRLF & '"Microsoft.XMLDOM" related Error'
				Case $XML_EXT_DOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_DOMDOCUMENT=' & $XML_EXT_DOMDOCUMENT & @CRLF & '"Msxml2.DOMDocument" related Error'
				Case $XML_EXT_XSLTEMPLATE
					$sExtendedInfo = '$XML_EXT_XSLTEMPLATE=' & $XML_EXT_XSLTEMPLATE & @CRLF & '"Msxml2.XSLTemplate" related Error'
				Case $XML_EXT_SAXXMLREADER
					$sExtendedInfo = '$XML_EXT_SAXXMLREADER=' & $XML_EXT_SAXXMLREADER & @CRLF & '"MSXML2.SAXXMLReader" related Error'
				Case $XML_EXT_MXXMLWRITER
					$sExtendedInfo = '$XML_EXT_MXXMLWRITER=' & $XML_EXT_MXXMLWRITER & @CRLF & '"MSXML2.MXXMLWriter" related Error'
				Case $XML_EXT_FREETHREADEDDOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_FREETHREADEDDOMDOCUMENT=' & $XML_EXT_FREETHREADEDDOMDOCUMENT & @CRLF & '"Msxml2.FreeThreadedDOMDocument" related Error'
				Case $XML_EXT_XMLSCHEMACACHE
					$sExtendedInfo = '$XML_EXT_XMLSCHEMACACHE=' & $XML_EXT_XMLSCHEMACACHE & @CRLF & '"Msxml2.XMLSchemaCache." related Error'
				Case $XML_EXT_STREAM
					$sExtendedInfo = '$XML_EXT_STREAM=' & $XML_EXT_STREAM & @CRLF & '"ADODB.STREAM" related Error'
				Case $XML_EXT_ENCODING
					$sExtendedInfo = '$XML_EXT_ENCODING=' & $XML_EXT_ENCODING & @CRLF & 'Encoding related Error'
				Case Else
					$sExtendedInfo = '$iXMLWrapper_Extended=' & $iXMLWrapper_Extended & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @extened'
			EndSwitch
	EndSwitch
	; return back @error and @extended for further debuging
	Return SetError($iXMLWrapper_Error, $iXMLWrapper_Extended, _
			'@error description:' & @CRLF & _
			$sErrorInfo & @CRLF & _
			@CRLF & _
			'@extended description:' & @CRLF & _
			$sExtendedInfo & @CRLF & _
			'')

EndFunc    ;==>XML_My_ErrorParser
#EndRegion  XMLWrapperEx__Examples.au3 - XML DOM Error/Event Handling

#Region XMLWrapperEx__Examples.au3 - Help, Documentation, Manuals
#CS
	How Do I Use XML?
	https://msdn.microsoft.com/en-us/library/ms759092(v=vs.85).aspx

	A Beginner's Guide to the XML DOM
	https://msdn.microsoft.com/en-us/library/aa468547.aspx

	DOM Reference
	https://msdn.microsoft.com/en-us/library/ms764730(v=vs.85).aspx

	XML DOM Properties
	https://msdn.microsoft.com/en-us/library/ms763798(v=vs.85).aspx

	XML DOM Methods
	https://msdn.microsoft.com/en-us/library/ms757828(v=vs.85).aspx

	XML Glossary
	https://msdn.microsoft.com/en-us/library/ms256452(v=vs.85).aspx

	MSXML API History
	https://msdn.microsoft.com/en-us/library/ms762314(v=vs.85).aspx

	XML Standards Reference
	https://msdn.microsoft.com/en-us/library/ms256177(v=vs.85).aspx

	XSLT Reference
	https://msdn.microsoft.com/en-us/library/ms256069(v=vs.85).aspx

	XPath Reference
	https://msdn.microsoft.com/en-us/library/ms256115(v=vs.85).aspx

	XPath Syntax
	https://msdn.microsoft.com/en-us/library/ms256471(v=vs.85).aspx

	XPath Examples
	https://msdn.microsoft.com/en-us/library/ms256086(v=vs.110).aspx

	XML DOM Objects/Interfaces
	https://msdn.microsoft.com/en-us/library/ms760218(v=vs.85).aspx

	Location Path Examples
	https://msdn.microsoft.com/en-us/library/ms256236(v=vs.110).aspx

	Microsoft XML DOM output has no CR/LF
	http://www.experts-exchange.com/Web_Development/Web_Languages-Standards/Q_20135543.html

	Formatting of XML file
	http://www.visualbasicscript.com/Formatting-of-XML-file-m77414.aspx

	Stream Object (ADO)
	https://msdn.microsoft.com/en-us/library/windows/desktop/ms675032(v=vs.85).aspx

	TODO:
	IXMLDOMAttribute Members  ($oAttribute)
	https://msdn.microsoft.com/en-us/library/ms767677(v=vs.85).aspx

	XML Editing: A WYSIWYG XML Document Editor
	https://msdn.microsoft.com/en-us/library/ms977865.aspx

	Understanding XML Namespaces
	https://msdn.microsoft.com/en-us/library/aa468565.aspx

	Understanding XML
	https://msdn.microsoft.com/en-us/library/aa468558.aspx

#CE
#CS ON LINE XPath Tools
	http://www.xpathtester.com/xpath
	http://codebeautify.org/Xpath-Tester
	http://xpath.online-toolz.com/tools/xpath-editor.php
	http://www.whitebeam.org/library/guide/TechNotes/xpathtestbed.rhtm
	http://www.qutoric.com/xslt/analyser/xpathtool.html
	https://addons.mozilla.org/en-US/firefox/addon/xpather/
	http://www.xmlme.com/XpathTool.aspx
#CE
#CS OFF LINE XPath Tools
	http://qutoric.com/xmlquire/
	https://xpathvisualizer.codeplex.com/
#CE
#EndRegion  XMLWrapperEx__Examples.au3 - Help, Documentation, Manuals

#Region TEST

Func XML_ObjName_FlagsValue(ByRef $oObj)
	Local $sInfo = ''

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,1) {The name of the Object} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_NAME) & @CRLF

	; HELPFILE REMARKS: Not all Objects support flags 2 to 7. Always test for @error in these cases.
	$sInfo &= '+>' & @TAB & 'ObjName($oObj,2) {Description string of the Object} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_STRING)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,3) {The ProgID of the Object} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_PROGID)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,4) {The file that is associated with the object in the Registry} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_FILE)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,5) {Module name in which the object runs (WIN XP And above). Marshaller for non-inproc objects.} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_MODULE)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,6) {CLSID of the object''s coclass} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_CLSID)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	$sInfo &= '+>' & @TAB & 'ObjName($oObj,7) {IID of the object''s interface} =' & @CRLF & @TAB & ObjName($oObj, $OBJ_IID)
	If @error Then $sInfo &= '@error = ' & @error
	$sInfo &= @CRLF & @CRLF

	MsgBox($MB_SYSTEMMODAL, "ObjName:", $sInfo)
EndFunc    ;==>XML_ObjName_FlagsValue
#EndRegion  TEST
