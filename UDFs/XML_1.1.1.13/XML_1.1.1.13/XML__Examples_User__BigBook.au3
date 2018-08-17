; modified version of:
;~ https://www.autoitscript.com/forum/topic/176895-xmlau3-v-11110-formerly-xmlwrapperexau3-beta-support-topic/?do=findComment&comment=1329637

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
#Tidy_Parameters=/sort_funcs /reel

#include <array.au3>
#include <date.au3>
#include <MsgBoxConstants.au3>
#include "XML.au3"

_Example()

Func _Example()
	;create xml object
	Local $oXMLDoc = _XML_CreateDOMDocument()
	If @error Then
		ConsoleWrite("Error _XML_CreateDOMDocument. Error: " & @error & " Extended: " & @extended & @LF)
	EndIf

	Local $sXML_Content = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> ' & @CRLF
	$sXML_Content &= '<FILE xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' & @CRLF
	$sXML_Content &= '</FILE>'

	_XML_LoadXml($oXMLDoc, $sXML_Content)

	; Array declaration
	Local $aDeptCodeTemp[1][2]
	; Array assignig values
	$aDeptCodeTemp[0][0] = "DEPT_CODE"
	$aDeptCodeTemp[0][1] = "1"

	; first child 'record'
	_XML_CreateChildWAttr($oXMLDoc, "FILE", "RECORD", $aDeptCodeTemp)

	; second child "Field1"
	_XML_InsertChildNode($oXMLDoc, "RECORD[@DEPT_CODE='1']", "FIELD1")
	If @error Then MsgBox($MB_ICONERROR, 'INSERT', '@error = ' & @error & @CRLF & '@extended = ' & @extended)

	Local $sXMLValue = _XML_Tidy($oXMLDoc, 'UTF-8')
	_XML_LoadXml($oXMLDoc, $sXMLValue, "", True, False)
	Local $aFilePath = @ScriptDir & '\XML_Example_XML_Files\BigBook.xml'
	_XML_SaveToFile($oXMLDoc, $aFilePath)

	ShellExecute($aFilePath)

EndFunc    ;==>_Example
