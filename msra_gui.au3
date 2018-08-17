#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_icon=msra_gui.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;DOS command: msra /offerra [address] (address may be host name or IP)
;Run("msra /offerra COMPUTER_NAME") (If COMPUTER_NAME is left blank, MSRA dialog prompts for name)

#include <Array.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <GUIConstants.au3>

Global $combobox
Dim $objArgs[1]
Dim $objDomain
Dim $objComputer
Dim $strComputers

$domain   = "sarwin2k";
$app_width = 450; pixels

$objShell = ObjCreate("WScript.Shell");

$objDomain = ObjGet("WinNT://" & $domain);
Local $filter[1];
$filter[0] = 'computer';
$objDomain.Filter = $filter;

For $objComputer In $objDomain
 $computer = $objComputer.Name;

 ;Add a string delimiter
 If StringLen($strComputers) > 1 Then
	 $strComputers = $strComputers & '|';
 EndIf

 $strComputers = $strComputers & $computer;
Next

; Build the GUI
$window = GUICreate("Microsoft Remote Assistance GUI", $app_width, 120);
$combobox = _GUICtrlComboBox_Create($window, $strComputers, 0, 0, $app_width, 130);
$button   = GUICtrlCreateButton('Remote Assist', 0, 21, $app_width, 100, BitAND($BS_CENTER, $BS_VCENTER));
GUISetBkColor(0x00EEEEEE);
GUICtrlSetFont(-1, 25, 400, 0, "Verdana");

; Show the GUI window
GUISetState(@SW_SHOW);
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND");

; Loop until the user exits.
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop;
		Case $button
			$combo_val = _GUICtrlComboBox_GetEditText($combobox);

			; If nothing entered in combobox, MSRA's advanced dialog prompts for input
			; or allows to choose from history of connected workstations
			$iPID = Run("msra /offerra " & $combo_val);	Runs MSRA.exe (Microsoft Remote Assistance)
	EndSwitch
WEnd
GUIDelete($window);

Func _Edit_Changed()
    _GUICtrlComboBox_AutoComplete($combobox);
EndFunc

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg
    Local $hWndFrom, $iIDFrom, $iCode, $hWndCombo
    If Not IsHWnd($combobox) Then $hWndCombo = GUICtrlGetHandle($combobox)
    $hWndFrom = $ilParam
    $iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
    $iCode = BitShift($iwParam, 16) ; Hi Word
    Switch $hWndFrom
        Case $combobox, $hWndCombo
            Switch $iCode
				Case $CBN_EDITCHANGE
					_Edit_Changed();	Call "_Edit_Changed" Func
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc

