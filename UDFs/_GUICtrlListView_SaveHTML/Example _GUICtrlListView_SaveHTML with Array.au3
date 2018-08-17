#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <WindowsConstants.au3>

_Main()

Func _Main()
	Local $aArray, $hListView, $iButton, $iListView, $sPrintOut
	GUICreate("_GUICtrlListView_SaveHTML()", 400, 300, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
	$iListView = GUICtrlCreateListView("", 0, 0, 400, 270)
	$hListView = GUICtrlGetHandle($iListView)4
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$iButton = GUICtrlCreateButton("Export HTML", 400 - 80, 275, 75, 22.5)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)

	GUISetState(@SW_SHOW)

	__ListViewFill($hListView, Random(1, 5, 1), Random(25, 100, 1)) ; Fill the ListView with Random data.

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit

			Case $iButton
				$aArray = _GUICtrlListView_CreateArray($hListView)
				$sPrintOut = _GUICtrlListView_SaveHTML($aArray, @ScriptDir & "\Export.html", "http://www.autoitscript.com/forum")
				ShellExecute($sPrintOut)

		EndSwitch
	WEnd
EndFunc   ;==>_Main

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #FUNCTION# =========================================================================================================
; Name...........: _GUICtrlListView_SaveHTML()
; Description ...: Exports the details of a ListView to a .html file. It will also convert URL's into hyperlinks.
; Syntax.........: _GUICtrlListView_SaveHTML($aArray, $sFile, [$sURL = ""])
; Parameters ....: $aArray - Array returned from _GUICtrlListView_CreateArray()
;                  $sFile - FilePath, this should ideally use the filetype .html e.g. @ScriptDir & "\Example.html"
;                  $sURL - [Optional] A URL to link to your applications website. [Default = ""]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns filepath.
;                  Failure - Returns filepath & sets @error = 1
; Author ........: guinness & HTML syntax by tproli with modifications by Lupo73
; Example........; Yes
;=====================================================================================================================
Func _GUICtrlListView_SaveHTML($aArray, $sFile, $sURL = "")
	Local $aColumns, $hFileOpen, $iCount, $iError = 0, $sAlternative, $sHTMLBody, $sHTMLColumns, $sHTMLFooter, $sHTMLHeader, $sIndex, $sScriptName = StringTrimRight(@ScriptName, 4)

	Local $sCreatedText = "Created with", $sTopText = "Top", $sTotalText = "Total count", $sUpdatedText = "Updated" ; Text Strings.

	$sHTMLColumns = '<tr>' & @CRLF ; ListView Columns
	$sHTMLColumns &= @TAB & '<th>' & '#' & '</th>' & @CRLF
	$aColumns = StringSplit($aArray[0][2], "|")
	For $A = 1 To $aColumns[0]
		$sHTMLColumns &= @TAB & '<th>' & $aColumns[$A] & '</th>' & @CRLF
	Next
	$sHTMLColumns &= '</tr>' & @CRLF

	For $A = 1 To $aArray[0][0] ; ListView Items.
		$sAlternative = "even"
		If Mod($A, 2) Then
			$sAlternative = 'odd'
		EndIf
		$sHTMLBody &= '<tr class="' & $sAlternative & '">' & @CRLF
		$sHTMLBody &= @TAB & '<td>' & $A & '</td>' & @CRLF
		For $B = 0 To $aArray[0][1] - 1
			$sIndex = $aArray[$A][$B]
			If StringRegExp($sIndex, "(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?") Then
				$sIndex = '<a href="' & $sIndex & '" class="url" target="_blank">' & $sIndex & '</a>'
			EndIf
			$sHTMLBody &= @TAB & '<td>' & $sIndex & '</td>' & @CRLF
		Next
		$sHTMLBody &= '</tr>' & @CRLF
	Next

	$iCount = $aArray[0][0]
	$sHTMLHeader = '<!-- ' & $sCreatedText & ' ' & $sScriptName & ' -->' & @CRLF & _
			'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"' & @CRLF & _
			' "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF & _
			'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">' & @CRLF & _
			@CRLF & _
			@CRLF & _
			'<head>' & @CRLF & _
			'<meta http-equiv="content-type" content="text/html;charset=UTF-8" />' & @CRLF & _
			'<title>' & $sScriptName & '</title>' & @CRLF & _
			'<style type="text/css">' & @CRLF & _ ; Start of StyleSheet -  Edit this Section to change the Style.
			'html {' & @CRLF & _
			@TAB & 'background: #E4ECF2;' & @CRLF & _
			@TAB & 'margin: 0;' & @CRLF & _
			@TAB & 'padding: 0;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'body {' & @CRLF & _
			@TAB & 'padding-left: 50px;' & @CRLF & _
			@TAB & 'font-family: Arial, sans-serif;' & @CRLF & _
			@TAB & 'font-size: 12px;' & @CRLF & _
			@TAB & 'color: #233447;' & @CRLF & _
			@TAB & 'min-width: 990px;' & @CRLF & _
			@TAB & 'height: auto;' & @CRLF & _
			@TAB & 'margin: 0;' & @CRLF & _
			@TAB & 'padding: 30px 40px 30px 40px;' & @CRLF & _
			@CRLF & _
			@TAB & 'background: #E4ECF2; /* Old browsers */' & @CRLF & _
			@TAB & 'background: -moz-linear-gradient(top, #EFF5F9 0%, #E4ECF2 100%); /* FF3.6+ */' & @CRLF & _
			@TAB & 'background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#EFF5F9), color-stop(100%,#E4ECF2)); /* Chrome, Safari4+ */' & @CRLF & _
			@TAB & 'background: -webkit-linear-gradient(top, #EFF5F9 0%,#E4ECF2 100%); /* Chrome10+, Safari5.1+ */' & @CRLF & _
			@TAB & 'background: -o-linear-gradient(top, #EFF5F9 0%,#E4ECF2 100%); /* Opera11.10+ */' & @CRLF & _
			@TAB & 'background: -ms-linear-gradient(top, #EFF5F9 0%,#E4ECF2 100%); /* IE10+ */' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a {' & @CRLF & _
			@TAB & 'outline: none;' & @CRLF & _
			@TAB & 'color: #0096BF;' & @CRLF & _
			@TAB & 'padding: 3px 5px 3px 3px;' & @CRLF & _
			@TAB & '-o-border-radius: 3px;' & @CRLF & _
			@TAB & '-ms-border-radius: 3px;' & @CRLF & _
			@TAB & '-moz-border-radius: 3px;' & @CRLF & _
			@TAB & '-webkit-border-radius: 3px;' & @CRLF & _
			@TAB & 'border-radius: 3px;' & @CRLF & _
			@TAB & 'text-decoration: none;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a:hover {' & @CRLF & _
			@TAB & 'color: #233447;' & @CRLF & _
			@TAB & 'background-color: #BFE1EA;' & @CRLF & _
			@TAB & 'text-shadow: 1px 1px #c9f0f5;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a.top {' & @CRLF & _
			@TAB & 'color: #8397A7;' & @CRLF & _
			@TAB & 'text-shadow: 1px 1px #FFF;' & @CRLF & _
			@TAB & 'padding: 4px 8px 4px 0;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a.top:hover {' & @CRLF & _
			@TAB & 'color: #49647A;' & @CRLF & _
			@TAB & 'background-color: transparent;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a.url {' & @CRLF & _
			@TAB & 'color: #233447;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'a.url:hover {' & @CRLF & _
			@TAB & 'color: #233447;' & @CRLF & _
			@TAB & 'text-decoration: underline;' & @CRLF & _
			@TAB & 'background-color: transparent;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'h1 {' & @CRLF & _
			@TAB & 'color: #0096BF;' & @CRLF & _
			@TAB & 'font-size: 28px;' & @CRLF & _
			@TAB & 'display: inline;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'.bold {' & @CRLF & _
			@TAB & 'font-weight: bold;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'.italic {' & @CRLF & _
			@TAB & 'font-style: italic;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'.uppercase {' & @CRLF & _
			@TAB & 'text-transform: uppercase;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'div.infoline {' & @CRLF & _
			@TAB & 'margin-top: 30px;' & @CRLF & _
			@TAB & 'margin-bottom: 15px;' & @CRLF & _
			@TAB & 'height: 12px;' & @CRLF & _
			@TAB & 'line-height: 12px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'div.infoline span {' & @CRLF & _
			@TAB & 'border-left: 1px solid #233447;' & @CRLF & _
			@TAB & 'padding-left: 10px;' & @CRLF & _
			@TAB & 'margin-left: 10px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'div.infoline span:first-child {' & @CRLF & _
			@TAB & 'border-left: none;' & @CRLF & _
			@TAB & 'padding-left: 0;' & @CRLF & _
			@TAB & 'margin-left: 0;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'div.infoline span.noborder {' & @CRLF & _
			@TAB & 'border: none !important;' & @CRLF & _
			@TAB & 'margin-left: 0 !important;' & @CRLF & _
			@TAB & 'padding-left: 0 !important;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'div.footer {' & @CRLF & _
			@TAB & 'position: relative;' & @CRLF & _
			@TAB & 'margin-top: 20px;' & @CRLF & _
			@TAB & 'margin-bottom: 30px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF
	$sHTMLHeader &= 'table {' & @CRLF & _
			@TAB & 'border: 1px solid #FFF;' & @CRLF & _
			@TAB & 'border-spacing: 0;' & @CRLF & _
			@CRLF & _
			@TAB & '-o-box-shadow: 0px 0px 10px #BCD2EB;' & @CRLF & _
			@TAB & '-moz-box-shadow: 0px 0px 10px #BCD2EB;' & @CRLF & _
			@TAB & '-webkit-box-shadow: 0px 0px 10px #BCD2EB;' & @CRLF & _
			@TAB & 'box-shadow: 0px 0px 10px #BCD2EB;' & @CRLF & _
			@CRLF & _
			@TAB & '-o-background-clip: padding-box;' & @CRLF & _
			@TAB & '-ms-background-clip: padding-box;' & @CRLF & _
			@TAB & '-moz-background-clip: padding-box;' & @CRLF & _
			@TAB & '-webkit-background-clip: padding-box;' & @CRLF & _
			@TAB & 'background-clip: padding-box;' & @CRLF & _
			@CRLF & _
			@TAB & 'background-color: #FFF;' & @CRLF & _
			@CRLF & _
			@TAB & '-o-border-radius: 4px;' & @CRLF & _
			@TAB & '-ms-border-radius: 4px;' & @CRLF & _
			@TAB & '-moz-border-radius: 4px;' & @CRLF & _
			@TAB & '-webkit-border-radius: 4px;' & @CRLF & _
			@TAB & 'border-radius: 4px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table th, table td {' & @CRLF & _
			@TAB & 'padding: 2px 12px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table th {' & @CRLF & _
			@TAB & 'text-transform: uppercase;' & @CRLF & _
			@TAB & 'color: #FFF;' & @CRLF & _
			@TAB & 'font-size: 11px;' & @CRLF & _
			@TAB & 'text-align: left;' & @CRLF & _
			@TAB & 'padding-top: 4px;' & @CRLF & _
			@TAB & 'height: 22px;' & @CRLF & _
			@TAB & 'line-height: 22px;' & @CRLF & _
			@CRLF & _
			@TAB & 'background: rgb(59,103,158); /* Old browsers */' & @CRLF & _
			@TAB & 'background: -moz-linear-gradient(top, rgba(59,103,158,1) 0%, rgba(43,136,217,1) 50%, rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%); /* FF3.6+ */' & @CRLF & _
			@TAB & 'background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(59,103,158,1)), color-stop(50%,rgba(43,136,217,1)), color-stop(51%,rgba(32,124,202,1)), color-stop(100%,rgba(125,185,232,1))); /* Chrome, Safari4+ */' & @CRLF & _
			@TAB & 'background: -webkit-linear-gradient(top, rgba(59,103,158,1) 0%,rgba(43,136,217,1) 50%,rgba(32,124,202,1) 51%,rgba(125,185,232,1) 100%); /* Chrome10+, Safari5.1+ */' & @CRLF & _
			@TAB & 'background: -o-linear-gradient(top, rgba(59,103,158,1) 0%,rgba(43,136,217,1) 50%,rgba(32,124,202,1) 51%,rgba(125,185,232,1) 100%); /* Opera11.10+ */' & @CRLF & _
			@TAB & 'background: -ms-linear-gradient(top, rgba(59,103,158,1) 0%,rgba(43,136,217,1) 50%,rgba(32,124,202,1) 51%,rgba(125,185,232,1) 100%); /* IE10+ */' & @CRLF & _
			@TAB & 'background: linear-gradient(top, rgba(59,103,158,1) 0%,rgba(43,136,217,1) 50%,rgba(32,124,202,1) 51%,rgba(125,185,232,1) 100%); /* W3C */' & @CRLF & _
			@CRLF & _
			@TAB & 'text-shadow: -1px -1px #3A68A0;' & @CRLF & _
			@TAB & 'border-bottom: 1px solid #3A68A0;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table td:first-child {' & @CRLF & _
			@TAB & 'text-align: right;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table th:first-child {' & @CRLF & _
			@TAB & 'text-align: right;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table th:first-child {' & @CRLF & _
			@TAB & '-o-border-top-left-radius: 4px;' & @CRLF & _
			@TAB & '-ms-border-top-left-radius: 4px;' & @CRLF & _
			@TAB & '-webkit-border-top-left-radius: 4px;' & @CRLF & _
			@TAB & '-moz-border-radius-topleft: 4px;' & @CRLF & _
			@TAB & 'border-top-left-radius: 4px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table th:last-child {' & @CRLF & _
			@TAB & '-o-border-top-right-radius: 4px;' & @CRLF & _
			@TAB & '-ms-border-top-right-radius: 4px;' & @CRLF & _
			@TAB & '-webkit-border-top-right-radius: 4px;' & @CRLF & _
			@TAB & '-moz-border-radius-topright: 4px;' & @CRLF & _
			@TAB & 'border-top-right-radius: 4px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table td {' & @CRLF & _
			@TAB & 'height: 23px;' & @CRLF & _
			@TAB & 'line-height: 23px;' & @CRLF & _
			@TAB & 'border-bottom: 1px solid #D9EBEB;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table tr:last-child td {' & @CRLF & _
			@TAB & 'border-bottom: none;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table tr.even {' & @CRLF & _
			@TAB & 'background-color: #F2F9FD;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'table tr:hover {' & @CRLF & _
			@TAB & 'background: #DEF4FA; /* Old browsers */' & @CRLF & _
			@TAB & 'background: -moz-linear-gradient(top, #DEF4FA 0%, #D5F2F9 50%, #C9EEF7 51%, #FFFEFD 100%); /* FF3.6+ */' & @CRLF & _
			@TAB & 'background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#DEF4FA), color-stop(50%,#D5F2F9), color-stop(51%,#C9EEF7), color-stop(100%,#FFFEFD)); /* Chrome, Safari4+ */' & @CRLF & _
			@TAB & 'background: -webkit-linear-gradient(top, #DEF4FA 0%,#D5F2F9 50%,#C9EEF7 51%,#FFFEFD 100%); /* Chrome10+, Safari5.1+ */' & @CRLF & _
			@TAB & 'background: -o-linear-gradient(top, #DEF4FA 0%,#D5F2F9 50%,#C9EEF7 51%,#FFFEFD 100%); /* Opera11.10+ */' & @CRLF & _
			@TAB & 'background: -ms-linear-gradient(top, #DEF4FA 0%,#D5F2F9 50%,#C9EEF7 51%,#FFFEFD 100%); /* IE10+ */' & @CRLF & _
			@TAB & 'background: linear-gradient(top, #DEF4FA 0%,#D5F2F9 50%,#C9EEF7 51%,#FFFEFD 100%); /* W3C */' & @CRLF & _
			@CRLF & _
			@TAB & 'text-shadow: 1px 1px rgba(255,255,255,0.5);' & @CRLF & _
			'}' & @CRLF & _
			@CRLF
	$sHTMLHeader &= '.triangle-border {' & @CRLF & _
			@TAB & 'position: relative;' & @CRLF & _
			@TAB & 'display: inline;' & @CRLF & _
			@TAB & 'padding: 5px 10px 4px 10px;' & @CRLF & _
			@TAB & 'background-color: #DAF0F5;' & @CRLF & _
			@CRLF & _
			@TAB & 'background: #EDFAFC; /* Old browsers */' & @CRLF & _
			@TAB & 'background: -moz-linear-gradient(top, #EDFAFC 5%, #DCF1F4 5%, #D4EEF4 100%); /* FF3.6+ */' & @CRLF & _
			@TAB & 'background: -webkit-gradient(linear, left top, left bottom, color-stop(5%,#EDFAFC), color-stop(5%,#DCF1F4), color-stop(100%,#D4EEF4)); /* Chrome, Safari4+ */' & @CRLF & _
			@TAB & 'background: -webkit-linear-gradient(top, #EDFAFC 5%,#DCF1F4 5%,#D4EEF4 100%); /* Chrome10+, Safari5.1+ */' & @CRLF & _
			@TAB & 'background: -o-linear-gradient(top, #EDFAFC 5%,#DCF1F4 5%,#D4EEF4 100%); /* Opera11.10+ */' & @CRLF & _
			@TAB & 'background: -ms-linear-gradient(top, #EDFAFC 5%,#DCF1F4 5%,#D4EEF4 100%); /* IE10+ */' & @CRLF & _
			@TAB & 'background: linear-gradient(top, #EDFAFC 5%,#DCF1F4 5%,#D4EEF4 100%); /* W3C */' & @CRLF & _
			@CRLF & _
			@TAB & 'top: -6px;' & @CRLF & _
			@TAB & 'margin-left: 28px;' & @CRLF & _
			@TAB & 'text-shadow: 1px 1px #EDFAFC;' & @CRLF & _
			@TAB & 'border: 1px solid #BFE1EA;' & @CRLF & _
			@TAB & 'border-bottom-width: 1px;' & @CRLF & _
			@TAB & 'border-bottom-color: #DCF1F4;' & @CRLF & _
			@CRLF & _
			@TAB & '-o-box-shadow: 0 2px 0 #AEDBE6;' & @CRLF & _
			@TAB & '-moz-box-shadow: 0 2px 0 #AEDBE6;' & @CRLF & _
			@TAB & '-webkit-box-shadow: 0 2px 0 #AEDBE6;' & @CRLF & _
			@TAB & 'box-shadow: 0 2px 0 #AEDBE6;' & @CRLF & _
			@CRLF & _
			@TAB & '-webkit-border-radius: 4px;' & @CRLF & _
			@TAB & '-moz-border-radius: 4px;' & @CRLF & _
			@TAB & 'border-radius: 4px;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'.triangle-border.left:after {' & @CRLF & _
			@TAB & 'content: "";' & @CRLF & _
			@TAB & 'position: absolute;' & @CRLF & _
			@TAB & 'top: 7px;' & @CRLF & _
			@TAB & 'left: -15px;' & @CRLF & _
			@TAB & 'border: 6px outset transparent;' & @CRLF & _
			@TAB & 'border-right: 6px solid #ADDDE7;' & @CRLF & _
			'}' & @CRLF & _
			@CRLF & _
			'</style>' & @CRLF & _  ; End of StyleSheet - Edit this Section to change the Style.
			'</head>' & @CRLF & _
			@CRLF & _
			'<body>' & @CRLF & _
			@CRLF & _
			'<h1>' & $sScriptName & '</h1>' & @CRLF & _
			@CRLF & _
			'<div class="triangle-border left">' & $sUpdatedText & ' ' & @MDAY & '-' & @MON & '-' & @YEAR & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & '</div>' & @CRLF & _
			@CRLF & _
			'<div class="infoline">' & @CRLF & _
			@TAB & '<p>' & @CRLF & _
			@TAB & '<span class="bold noborder">' & $sTotalText & '</span>: ' & $iCount & @CRLF & _
			@TAB & '</p>' & @CRLF & _
			'</div>' & @CRLF & _
			@CRLF & _
			'<table cellspacing="0" cellpadding="0">' & @CRLF & _
			'<tbody>' & @CRLF

	$sHTMLFooter = '</tbody>' & @CRLF & _
			'</table>' & @CRLF & _
			@CRLF & _
			'<div class="footer">' & @CRLF & _
			'<p>' & @CRLF & _
			$sCreatedText & ' <a href="' & $sURL & '" target="_blank">' & $sScriptName & '</a>' & @CRLF & _
			@TAB & '<span class="italic"></span>' & @CRLF & _
			@TAB & '<br />' & @CRLF & _
			@TAB & '<br />' & @CRLF & _
			@TAB & '<a href="#" class="top">' & $sTopText & '</a>' & @CRLF & _
			@TAB & '</p>' & @CRLF & _
			'</div>' & @CRLF & _
			@CRLF & _
			'</body>' & @CRLF & _
			'</html>' & @CRLF

	$hFileOpen = FileOpen($sFile, 2 + 8 + 128)
	FileWrite($hFileOpen, $sHTMLHeader & $sHTMLColumns & $sHTMLBody & $sHTMLFooter)
	FileClose($hFileOpen)
	If @error Then
		$iError = 1
	EndIf
	Return SetError($iError, 0, $sFile)
EndFunc   ;==>_GUICtrlListView_SaveHTML

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #FUNCTION# =========================================================================================================
; Name...........: _GUICtrlListView_CreateArray()
; Description ...: Creates a 2-dimensional array from a lisview.
; Syntax.........: _GUICtrlListView_CreateArray($hListView, [$sDelimeter = "|"])
; Parameters ....: $hListView - Handle of the ListView.
;                  [Optional] $sDelimeter - One or more characters to use as delimiters (case sensitive). Default = "|"
; Requirement(s).: v3.2.12.1 or higher & GUIListView.au3.
; Return values .: Success - The array returned is two-dimensional and is made up as follows:
;                                $aArray[0][0] = Number of rows
;                                $aArray[0][1] = Number of columns
;                                $aArray[0][3] = Delimited string of the column name(s) e.g. Column 1|Column 2|Column 3|Column nth

;                                $aArray[1][0] = 1st row, 1st column
;                                $aArray[1][1] = 1st row, 2nd column
;                                $aArray[n][0] = nth row, 1st column
;                                $aArray[n][1] = nth row, 2nd column
;                                $aArray[n][1] = nth row, 3rd column
;                  Failure - Returns array with @error = 1 if the number of rows is equal to 0
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _GUICtrlListView_CreateArray($hListView, $sDelimeter = "|")
	Local $aColumns, $iDim = 0, $iError = 0, $sIndex, $sSubItem
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hListView)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hListView)
	If $iColumnCount < 3 Then
		$iDim = 3 - $iColumnCount
	EndIf
	Local $aReturn[$iItemCount + 1][$iColumnCount + $iDim] = [[$iItemCount, $iColumnCount, ""]]

	For $A = 0 To $iColumnCount - 1
		$aColumns = _GUICtrlListView_GetColumn($hListView, $A)
		If $A = $iColumnCount - 1 Then
			$sDelimeter = ""
		EndIf
		$aReturn[0][2] &= $aColumns[5] & $sDelimeter
	Next

	For $A = 0 To $iItemCount - 1
		$sIndex = _GUICtrlListView_GetItemText($hListView, $A)
		$aReturn[$A + 1][0] = $sIndex
		If $iColumnCount > 0 Then
			For $B = 1 To $iColumnCount - 1
				$sSubItem = _GUICtrlListView_GetItemText($hListView, $A, $B)
				$aReturn[$A + 1][$B] = $sSubItem
			Next
		EndIf
	Next
	If $aReturn[0][0] = 0 Then
		$iError = 1
	EndIf
	Return SetError($iError, 0, $aReturn)
EndFunc   ;==>_GUICtrlListView_CreateArray

Func __ListViewFill($hListView, $iColumns, $iRows) ; Required only for _Main(), but not the UDF!
	For $A = 0 To $iColumns - 1
		_GUICtrlListView_InsertColumn($hListView, $A, "Column " & $A + 1, 50)
		_GUICtrlListView_SetColumnWidth($hListView, $A - 1, -2)
	Next
	For $A = 0 To $iRows - 1
		_GUICtrlListView_AddItem($hListView, Chr(Random(65, 90, 1)) & " - Row " & $A + 1 & ": Col 1", $A)
		For $B = 1 To $iColumns
			_GUICtrlListView_AddSubItem($hListView, $A, "Row " & $A + 1 & ": Col " & $B + 1, $B)
		Next
	Next
EndFunc   ;==>__ListViewFill