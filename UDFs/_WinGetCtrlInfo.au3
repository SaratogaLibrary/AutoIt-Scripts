Global $Array = _WinGetCtrlInfo(WinGetTitle(''))
Global $sOne = '[0][0] = ' & $Array[0][0] & @CR, $sTwo
For $iCC = 1 To $Array[0][0]
    $sOne &= '[' & $iCC & '][0] = ' & $Array[$iCC][0] & @CR
    $sTwo &= '[' & $iCC & '][1] = ' & $Array[$iCC][1] & @CR
Next
MsgBox(64, 'WinInfo', StringTrimRight($sOne, 1) & @CR & StringTrimRight($sTwo, 1))?oÝ?÷ Ù@Åjëh?×6Func _WinGetCtrlInfo($hWin)
    If IsString($hWin) Then $hWin = WinGetHandle($hWin)
    Local $sClassList = WinGetClassList($hWin), $iAdd = 1, $aDLL, $sHold
    Local $aSplitClass = StringSplit(StringTrimRight($sClassList, 1), @LF), $aReturn[1][2]
    For $iCount = $aSplitClass[0] To 1 Step - 1
        Local $nCount = 0
        While 1
            $nCount += 1
            If ControlGetHandle($hWin, '', $aSplitClass[$iCount] & $nCount) = '' Then ExitLoop
            If Not StringInStr(Chr(1) & $sHold, Chr(1) & $aSplitClass[$iCount] & $nCount & Chr(1)) Then
                $sHold &= $aSplitClass[$iCount] & $nCount & Chr(1)
                $iAdd += 1
                ReDim $aReturn[$iAdd][2]
                $aReturn[$iAdd - 1][0] = $aSplitClass[$iCount] & $nCount
                $aDLL = DllCall('User32.dll', 'int', 'GetDlgCtrlID', 'hwnd', _
                    ControlGetHandle($hWin, '', $aSplitClass[$iCount] & $nCount))
                If @error = 0 Then
                    $aReturn[$iAdd - 1][1] = $aDLL[0]
                Else
                    $aReturn[$iAdd - 1][1] = ''
                EndIf
            EndIf
        WEnd
    Next
    $aReturn[0][0] = $iAdd - 1
    Return $aReturn
EndFunc