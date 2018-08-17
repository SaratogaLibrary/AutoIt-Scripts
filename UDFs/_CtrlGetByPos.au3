;===============================================================================
; Function Name:    _CtrlGetByPos()
; Description:      Get the Control ID or the ClassNameNN by the X and Y client coordinates
; Syntax:           _CtrlGetByPos("Window Title", [Control Text], [X Client Coord], [Y Client Coord], [Return Type])
;
; Parameter(s):     $hWin               = Window Name or Handle
;                   $sText              = Text of the Control
;                   $iXPos              = X Client Coord
;                   $iYPos              = Y Client Coord
;                   $iReturnType        = Return type (default = 0 (ClassNameNN))
;                                           0 = ClassNameNN
;                                           1 = Control ID
;                                           2 = Control Handle
;                                           3 = All 3 ClassNameNN, Control ID, Control Handle
;
;
; Requirement(s):   External:           = None.
;                   Internal:           = AutoIt Beta 3.1.130 (or which ever release SetError(0,0,0) was introduced)
;
; Return Value(s):  On Success:         = Returns Array List
;                   On Failure:         = @error 1 (Control was found but there was an error with the DLLCall)
;                   On Failure:         = @error 2 (No classes were found)
;
; Author(s):        SmOke_N
;
; Note(s):          Similar to LxP's here (This was made before I remembered he had done something similar)
;                   <a href='http://www.autoitscript.com/forum/index.php?showtopic=14323&hl=' class='bbc_url' title=''>http://www.autoitscript.com/forum/index.php?showtopic=14323&hl=</a>
;
;
; Example(s):
;   Opt('WinTitleMatchMode', 4)
;   _CtrlGetByPos('classname=SciTEWindow', '', 829, 504, 2)
;===============================================================================

Func _CtrlGetByPos($hWin, $sText = '', $iXPos = 0, $iYPos = 0, $iReturnType = 0)
    If IsString($hWin) Then $hWin = WinGetHandle($hWin)
    Local $sClassList = WinGetClassList($hWin), $hCtrlWnd
    Local $sSplitClass = StringSplit(StringTrimRight($sClassList, 1), @LF), $aReturn = ''
    For $iCount = UBound($sSplitClass) - 1 To 1 Step - 1
        Local $nCount = 0
        While 1
            $nCount += 1
            Local $aCPos = ControlGetPos($hWin, $sText, $sSplitClass[$iCount] & $nCount)
            If @error Then ExitLoop
            If $iXPos >= $aCPos[0] And $iXPos <= ($aCPos[0] + $aCPos[2]) _
                    And $iYPos >= $aCPos[1]  And $iYPos <= ($aCPos[1] + $aCPos[3]) Then
                If $sSplitClass[$iCount] <> '' And Not $iReturnType Then
                    Local $aClassNN[2] = [2, $sSplitClass[$iCount] & $nCount]
                    Return $aClassNN
                EndIf
                If $sSplitClass[$iCount] <> '' And $iReturnType = 3 Then
                    $hCtrlWnd = ControlGetHandle($hWin, $sText, $sSplitClass[$iCount] & $nCount)
                    ControlFocus($hWin, $sText, $hCtrlWnd)
                    $aReturn = DllCall('User32.dll', 'int', 'GetDlgCtrlID', 'hwnd', $hCtrlWnd)
                    If @error = 0 And $aReturn[0] <> '' Then
                        Local $aClassNN[4] = [4, $aReturn[0], $sSplitClass[$iCount] & $nCount, $hCtrlWnd]
                        Return $aClassNN
                    EndIf
                    Local $aClassNN[2] = [2, $sSplitClass[$iCount] & $nCount]
                    Return $aClassNN
                ElseIf $sSplitClass[$iCount] <> '' And $iReturnType = 2 Then
                    Return ControlGetHandle($hWin, $sText, $sSplitClass[$iCount] & $nCount)
                ElseIf $sSplitClass[$iCount] <> '' And $iReturnType = 1 Then
                    $hCtrlWnd = ControlGetHandle($hWin, $sText, $sSplitClass[$iCount] & $nCount)
                    ControlFocus($hWin, $sText, $hCtrlWnd)
                    $aReturn = DllCall('User32.dll', 'int', 'GetDlgCtrlID', 'hwnd', $hCtrlWnd)
                    If @error = 0 And $aReturn[0] <> '' Then
                        Local $aClassNN[2] = [2, $aReturn[0]]
                        Return $aClassNN
                    EndIf
                EndIf
                Return SetError(1, 0, 0)
            EndIf
        WEnd
    Next
    Return SetError(2, 0, 0)
EndFunc
Opt('WinTitleMatchMode', 4)
Global $Control_To_Interact_With_Is = _CtrlGetByPos('classname=SciTEWindow', '', 829, 504, 3)
If IsArray($Control_To_Interact_With_Is) Then
    For $i = 1 To UBound($Control_To_Interact_With_Is) - 1
        MsgBox(0, '', $Control_To_Interact_With_Is[$i])
    Next
EndIf