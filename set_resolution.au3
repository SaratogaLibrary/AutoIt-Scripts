;#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
;#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <APIConstants.au3>     ; needed for variables $DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY, $WM_DISPLAYCHANGE

$width  = IniRead(@ScriptDir & "\settings.ini", "ResolutionSettings", "width",  1280);
$height = IniRead(@ScriptDir & "\settings.ini", "ResolutionSettings", "height", 720);
DisplayChangeRes($width, $height, @DesktopDepth, @DesktopRefresh);

;This code from: http://www.autoitscript.com/forum/topic/139429-resolution-switcher-mainly-for-win8-on-the-htc-shift-and-similar-devices-but-should-be-easy-to-modify-for-whatever/
;Thanks to danwilli @ AutoIt forums http://www.autoitscript.com/forum/topic/102335-why-not-in-all-windows-versions/page__view__findpost__p__726746
Func DisplayChangeRes($WIDTH, $HEIGHT, $BPP, $FREQ)
    Local Const $CDS_TEST = 0x00000002
    Local Const $CDS_UPDATEREGISTRY = 0x00000001
    Local Const $DISP_CHANGE_RESTART = 1
    Local Const $DISP_CHANGE_SUCCESSFUL = 0
    Local Const $HWND_BROADCAST = 0xffff
    $DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
    $B = DllCall("user32.dll", "int", "EnumDisplaySettings", "str", Null, "DWORD", 0, "struct*", $DEVMODE)
    If @error Then
        $B = 0
    Else
        $B = $B[0]
    EndIf
    If $B <> 0 Then
        DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)
        DllStructSetData($DEVMODE, 4, $WIDTH, 2)
        DllStructSetData($DEVMODE, 4, $HEIGHT, 3)
        DllStructSetData($DEVMODE, 4, $BPP, 1)
        DllStructSetData($DEVMODE, 4, $FREQ, 5)
        $B = DllCall("user32.dll", "int", "ChangeDisplaySettings", "struct*", $DEVMODE, "DWORD", $CDS_TEST)
        If @error Then
            $B = -1
        Else
            $B = $B[0]
        EndIf
        Select
            Case $B = $DISP_CHANGE_RESTART
                $DEVMODE = ""
                Return 2
            Case $B = $DISP_CHANGE_SUCCESSFUL
                DllCall("user32.dll", "int", "ChangeDisplaySettings", "struct*", $DEVMODE, "DWORD", $CDS_UPDATEREGISTRY)
				DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, _
                        "int", $bpp, "int", $height * 2 ^ 16 + $width)   ;Not sure if this is needed, correct or even correctly written
                $DEVMODE = ""
                Return 1
            Case Else
                $DEVMODE = ""
                Return $B
        EndSelect
    EndIf
    Return 1
EndFunc   ;==>DisplayChangeRes