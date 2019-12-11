; https://www.autoitscript.com/forum/topic/21004-easy-zip-compression-using-windows-xp/
Func _ZipCreate( $sZip )
    If not StringLen(Chr(0)) Then Return SetError(1)
    Local $sHeader = Chr(80) & Chr(75) & Chr(5) & Chr(6), $hFile
    For $i = 1 to 18
        $sHeader &= Chr(0)
    Next
    $hFile = FileOpen($sZip, 2)
    FileWrite($hFile, $sHeader)
    FileClose($hFile)
EndFunc

Func _ZipAdd( $sZip, $sFile )
    If not StringLen(Chr(0)) Then Return SetError(1)
    If not FileExists($sZip) or not FileExists($sFile) Then Return SetError(2)
    Local $oShell = ObjCreate('Shell.Application')
    If @error or not IsObj($oShell) Then Return SetError(3)
    Local $oFolder = $oShell.NameSpace($sZip)
    If @error or not IsObj($oFolder) Then Return SetError(4)
    $oFolder.CopyHere($sFile)
    Sleep(500)
EndFunc

Func _ZipList( $sZip )
    If not StringLen(Chr(0)) Then Return SetError(1)
    If not FileExists($sZip) Then Return SetError(2)
    Local $oShell = ObjCreate('Shell.Application')
    If @error or not IsObj($oShell) Then Return SetError(3)
    Local $oFolder = $oShell.NameSpace($sZip)
    If @error or not IsObj($oFolder) Then Return SetError(4)
    Local $oItems = $oFolder.Items()
    If @error or not IsObj($oItems) Then Return SetError(5)
    Local $i = 0
    For $o in $oItems
        $i += 1
    Next
    Local $aNames[$i + 1]
    $aNames[0] = $i
    $i = 0
    For $o in $oItems
        $i += 1
        $aNames[$i] = $oFolder.GetDetailsOf($o, 0)
    Next
    Return $aNames
EndFunc
