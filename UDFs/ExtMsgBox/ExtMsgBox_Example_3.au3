
; ExtMsgBox Example

#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <StaticConstants.au3>

#include "ExtMsgBox.au3"

; Max width set to default value of 370
_ExtMsgBoxSet(Default)

; Buttons are at default size
$sMsg = "Buttons at default size - EMB at default max width as shown by the text wrapping"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "YES|NO", "Test 1", $sMsg, 20)
ConsoleWrite("Test 1 returned: " & $iRetValue & " - " & @error & @CRLF)

; Buttons an expand enough to deal with this length text
$sMsg = "Buttons expanded to fit text - EMB still at default max width as shown by the text wrapping"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "CONFIRM|&REMIND ME LATER", "Test 2", $sMsg, 20)
ConsoleWrite("Test 2 returned: " & $iRetValue & " - " & @error & @CRLF)

; Increase max width of EMB to 450
_ExtMsgBoxSet(-1, -1, -1, -1, -1, -1, 500)

; And then the buttons can expand still further
$sMsg = "EMB expanded so that buttons can expand to fit text" & @CRLF & "Button width determines EMB width"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "CONFIRM|REMIND ME QUITE A BIT LATER PLEASE", "Test 3", $sMsg, 20)
ConsoleWrite("Test 3 returned: " & $iRetValue & " - " & @error & @CRLF)

; But resetting the default EMB size...
_ExtMsgBoxSet(Default)

; ...produces an error as the button text will now not fit as the buttons cannot expand enough
$sMsg = "Error 5" & @CRLF & "Buttons wide enough to contain longest required text" & @CRLF & "too wide for default width EMB"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "CONFIRM|REMIND ME QUITE A BIT LATER", "Test 4", $sMsg, 20)
ConsoleWrite("Test 4 returned: " & $iRetValue & " - " & @error & @CRLF)
_ExtMsgBox ($EMB_ICONEXCLAM, $MB_OK, "Test 4", $sMsg, 20)

; But you can get 6 buttons
$sMsg = "6 minimum-sized buttons can fit in a default sized EMB"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "1|2|3|4|5|6", "Test 5", $sMsg, 20)
ConsoleWrite("Test 5 returned: " & $iRetValue & " - " & @error & @CRLF)

; As will too many buttons to fit even at the minimum size
$sMsg = "7 minimum-sized buttons are too many for a default sized EMB as they would have to be below minimum size"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "1|2|3|4|5|6|7", "Test 6", $sMsg, 20)
ConsoleWrite("Test 6 returned: " & $iRetValue & " - " & @error & @CRLF)
_ExtMsgBox ($EMB_ICONEXCLAM, $MB_OK, "Test 3", $sMsg, 20)
;MsgBox($MB_ICONWARNING + $MB_SYSTEMMODAL, "Test 6", "Error 4" & @CRLF & "Seven buttons are too many for default width EMB")

; Increase max width of EMB to 430
_ExtMsgBoxSet(-1, -1, -1, -1, -1, -1, 430)
$sMsg = "But 7 minimum-sized buttons will fit if the EMB is expanded a little"
$iRetValue = _ExtMsgBox ($EMB_ICONINFO, "1|2|3|4|5|6|7", "Test 7", $sMsg, 20)
ConsoleWrite("Test 7 returned: " & $iRetValue & " - " & @error & @CRLF)

; Resetting the default EMB size
_ExtMsgBoxSet(Default)

; Text wider then title
_ExtMsgBox($EMB_ICONINFO, "OK", "Title", "Text Sets Dialog Width")

; Title wider than text
_ExtMsgBox(0, "OK", "Much Longer Title To Set Dialog Width", "Text")

; Title too wide for widest EMB
_ExtMsgBox($EMB_ICONEXCLAM, "OK", " An Very Much Longer Title...Just To Show That There Are Limits Which Cause Truncation If It Gets Far Too Long", "Text")