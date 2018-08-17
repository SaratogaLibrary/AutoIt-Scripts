;#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
;#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Original code from http://www.autoitscript.com/forum/topic/52575-iconmap/
#include <GuiListView.au3>

; Get runtime instructions
If @Compiled Then
	Switch $CmdLine[0]
		Case 0
			If RegRead("HKCR\.icn", "") = "IconMaps" Then
				$sMode = "/UNINSTALL"
			Else
				$sMode = "/INSTALL"
			EndIf
		Case 2
			$sMode = ($CmdLine[1]); /SAVE or /RESTORE
			$sINI = $CmdLine[2]; The *.ICN filename to use as ini file
		Case Else
			MsgBox(4096 + 48, @ScriptName, "Error - Commandline Usage:" & @LF & @LF & 'IconMap.exe /save "<.icn filename>"' & @LF & 'IconMap.exe /restore "<.icn filename>"')
	EndSwitch
;Else
; Designtime testing;o)
;	$sMode = "/RESTORE"
;	$sINI = "C:\Documents and Settings\James\Desktop\Desktop.icn"
EndIf

; Get a handle on the desktop, which is actually a listview control.
$hWnd_LV = ControlGetHandle("Program Manager", "", "[CLASS:SysListView32]")

; Save or Restore?
Switch StringUpper($sMode)
	Case "/SAVE"
	; Drop all previous icon positions
		IniDelete($sINI, "Icons")
	; Walk the listview items, saving their positions to the INI file.
		For $nIdx = 0 To _GUICtrlListView_GetItemCount($hWnd_LV) - 1
			$sIconText = _GUICtrlListView_GetItemText($hWnd_LV, $nIdx)
			$aPos = _GUICtrlListView_GetItemPosition($hWnd_LV, $nIdx)
			If @error Then MsgBox(32, StringTrimRight(@ScriptName, 4), "There was an error writing details for program: " & $sIconText)
			IniWrite($sINI, "Icons", $sIconText, $aPos[0] & ":" & $aPos[1])
		Next
		Beep(1500, 100)
		Beep(1000, 100)
		Beep(500, 100)
	Case "/RESTORE"
	; Walk the listview items, applying their positions from the INI file.
		For $nIdx = 0 To _GUICtrlListView_GetItemCount($hWnd_LV) - 1
			$sIconText = _GUICtrlListView_GetItemText($hWnd_LV, $nIdx)
			$aPos = StringSplit(IniRead($sINI, "Icons", $sIconText, "0:0"), ":")
			If $aPos[0] <> 2 Then
				MsgBox(0, StringTrimRight(@ScriptName, 4), "Error - invalid coordinates for icon:" & @LF & @LF & $sIconText)
				Exit
			EndIf
			_GUICtrlListView_SetItemPosition($hWnd_LV, $nIdx, $aPos[1], $aPos[2])
		Next
		Beep(500, 100)
		Beep(1000, 100)
		Beep(1500, 100)
	Case "/INSTALL"
	; Setup a context menu for the command shell
		If MsgBox(4096 + 4 + 32, StringTrimRight(@ScriptName, 4), "Configure shell options for Right-clicking on *.ICN map files?" & @LF & "This requires writing to the registry!") = 6 Then;6=Yes
		; Prep Registry entries to handle ".icn" files
			RegWrite("HKCR\.icn", "", "REG_SZ", "IconMaps")
			If @error Then
				MsgBox(32, StringTrimRight(@ScriptName, 4), "There was an error installing *.ICN extension!")
				$ErrorLog = FileOpen(@ScriptDir & '\error.log', 1)
				FileWrite($ErrorLog, "Error installing IconMap *.ICN information to registry!")
				FileClose($ErrorLog)
			EndIf
			RegWrite("HKCR\IconMaps", "", "REG_SZ", "Desktop Icon Positions")
			If @error Then
				MsgBox(32, StringTrimRight(@ScriptName, 4), "There was an error installing registry information!")
				$ErrorLog = FileOpen(@ScriptDir & '\error.log', 1)
				FileWrite($ErrorLog, "Error installing IconMap information to registry!")
				FileClose($ErrorLog)
			EndIf
			RegWrite("HKCR\IconMaps\Shell", "", "REG_SZ", "1_save")
			RegWrite("HKCR\IconMaps\Shell\1_save", "", "REG_SZ", "S&ave IconMap layout")
			RegWrite("HKCR\IconMaps\Shell\1_save\command", "", "REG_SZ", '"C:\Program Files\IconMaps\IconMap.exe" /save "%1"')
			RegWrite("HKCR\IconMaps\Shell\2_restore", "", "REG_SZ", "R&estore IconMap layout")
			RegWrite("HKCR\IconMaps\Shell\2_restore\command", "", "REG_SZ", '"C:\Program Files\IconMaps\IconMap.exe" /restore "%1"')
			MsgBox(64, StringTrimRight(@ScriptName, 4), "IconMap was succesfully installed!")
		EndIf
	Case "/UNINSTALL"
		If MsgBox(4096 + 4 + 32, StringTrimRight(@ScriptName, 4), "Are you sure you want to remove " & @ScriptName & "?" & @LF & "This will remove the " & "*.ICN extension - You will not be able to run IconMap.exe!") = 6 Then;6=Yes
		; Remove previously Registered entires
			RegDelete("HKCR\.icn")
			If @error Then
				MsgBox(32, StringTrimRight(@ScriptName, 4), "There was an error removing *.ICN extension!" & @LF & "Error was logged!")
				$ErrorLog = FileOpen(@ScriptDir & '\error.log', 1)
				FileWrite($ErrorLog, "Error removing IconMap *.ICN information from registry!")
				FileClose($ErrorLog)
			EndIf
			RegDelete("HKCR\IconMaps")
			If @error Then
				MsgBox(32, StringTrimRight(@ScriptName, 4), "There was an error removing registry keys for IconMap information." & @LF & "Error was logged!")
				$ErrorLog = FileOpen(@ScriptDir & '\error.log', 1)
				FileWrite($ErrorLog, "Error removing IconMap information from registry!")
				FileClose($ErrorLog)
			EndIf
			MsgBox(64, StringTrimRight(@ScriptName, 4), "IconMap has been removed!")
		EndIf
	Case Else
		MsgBox(4096 + 48, StringTrimRight(@ScriptName, 4), "Error - Commandline Usage:" & @LF & @LF & 'IconMap.exe /save "<.icn filename>"' & @LF & 'IconMap.exe /restore "<.icn filename>"')
EndSwitch