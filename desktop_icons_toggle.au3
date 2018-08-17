#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

_ToggleDesktopIcons()

Func _ToggleDesktopIcons()
	Local $hwnd = WinGetHandle("Program Manager")
	Local $sClass = "[CLASS:SysListView32; INSTANCE:1]"
	$iVis = ControlCommand($hwnd, "", $sClass, "IsVisible", "")

	If Not $iVis Then
		ControlShow($hwnd, "", $sClass)
	Else
		ControlHide($hwnd, "", $sClass)
	EndIf
EndFunc   ;==>_ToggleDesktopIcons