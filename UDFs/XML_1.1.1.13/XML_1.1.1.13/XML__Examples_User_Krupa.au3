;~ https://www.autoitscript.com/forum/topic/176895-xmlau3-v-11110-formerly-xmlwrapperexau3-beta-support-topic/?do=findComment&comment=1345368
#include <Array.au3>
#include "XML.au3"

_Example()
Func _Example()
	Local $sXML = _
			'<?xml version="1.0"?>' & @CRLF & _
			'<catalog>' & @CRLF & _
			'	<book id="bk101">' & @CRLF & _
			'		<author>Gambardella, Matthew</author>' & @CRLF & _
			'		<title>XML Developers Guide</title>' & @CRLF & _
			'	</book>' & @CRLF & _
			'	<book id="bk102">' & @CRLF & _
			'		<author>Ralls, Kim</author>' & @CRLF & _
			'		<title>Midnight Rain</title>' & @CRLF & _
			'	</book>' & @CRLF & _
			'</catalog>' & @CRLF & _
			''

	Local $oXML = _XML_CreateDOMDocument(Default)
	_XML_LoadXML($oXML, $sXML)
	Local $iNodeCount = _XML_GetNodesCount($oXML, "/catalog/book")
	ConsoleWrite("Group(s):      $iNodeCount = " & $iNodeCount & "; @error = " & @error & "; @extended = " & @extended & @LF)
	Local $aNames = _XML_GetValue($oXML, "/catalog/book/author")
	_ArrayDisplay($aNames, '$aNames')
	Local $aTaxCountries = _XML_GetValue($oXML, "/catalog/book/title")
	Local $aData[$iNodeCount + 1][3] = [[$iNodeCount, "", ""]]
	For $n = 1 To $iNodeCount
		Local $oNode_Selected_SingleOne = _XML_SelectSingleNode($oXML, '/catalog/book[' & $n & ']')
		Local $sAttribute_Value = _XML_GetNodeAttributeValue($oNode_Selected_SingleOne, 'id')
		$aData[$n][0] = $aNames[$n]
		$aData[$n][1] = $aTaxCountries[$n]
		$aData[$n][2] = $sAttribute_Value
	Next

	_ArrayDisplay($aData, "$aData")

EndFunc   ;==>_Example

