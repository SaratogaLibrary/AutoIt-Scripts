#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Inspirational source: https://www.autoitscript.com/forum/topic/127667-how-to-create-a-countdown-timer-in-autoit/?tab=comments#comment-885650
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>

; Configurable settings
$seconds_to_wait   = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "idle_seconds",            60);
$notice_seconds    = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "notice_seconds",          20);
$alert_seconds     = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "alert_seconds",           10);
$notice_text_color = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "notice_color",            "990000");
$alert_text_color  = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "alert_color",             "FF0000");
$alarm             = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "alarm",                   True);
$printDialogWindow = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "window_identifier",       "[CLASS:#32770; TITLE:Show Print Jobs]");
$printDialogText   = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "text_control_idenfifier", "Name:");
$timerFontSize     = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "timer_font_size",         28);
$textFontSize      = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "text_font_size",          9);
$preTimerText      = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "pre_timer_text",          "For your privacy this window will close after " & $seconds_to_wait & "s of inactivity.");
$postTimerText     = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "post_timer_text",         "When closed, the coinbox will dispense all funds.");
$font              = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "font",                    "Segoe UI");
$window_x_padding  = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "x_padding",               6);
$window_y_padding  = IniRead(@ScriptDir & "\settings.ini", "CoinBoxTimer", "y_padding",               16);

; Non-configurable settings
$overlay_height = 77;
$overlay_width  = 333;

Global $countdownTime = _SetIdleSeconds($seconds_to_wait), $_Seconds, $ticks;
Global $loopComplete = False;

; Close everything when the ESC key is pressed
HotKeySet("{Esc}", "_Exit");

; Create our overlay window for the Cassie printing dialog window
$timer = GUICreate("Countdown Timer", $overlay_width, $overlay_height, -1, -1, $WS_POPUP, BitOr($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_COMPOSITED));
GUISetBkColor(0xF0F0F0);

; Create our labels
$preTimerLabel  = GUICtrlCreateLabel($preTimerText, 0, 3, $overlay_width, $overlay_height, $SS_CENTER);
$TimeLabel      = GUICtrlCreateLabel("", 0, 0, $overlay_width, $overlay_height, BitOR($SS_CENTER, $SS_CENTERIMAGE));
$postTimerLabel = GUICtrlCreateLabel($postTimerText, 0, $overlay_height-($textFontSize + 8), $overlay_width, $overlay_height, $SS_CENTER);

; Set the fonts and background colors of the labels
GUICtrlSetFont($TimeLabel, $timerFontSize, 700, 0, $font);
GUICtrlSetFont($preTimerLabel, $textFontSize, 0, 0, $font);
GUICtrlSetFont($postTimerLabel, $textFontSize, 0, 0, $font);
GUICtrlSetBkColor($preTimerLabel, $GUI_BKCOLOR_TRANSPARENT);
GUICtrlSetBkColor($TimeLabel, $GUI_BKCOLOR_TRANSPARENT);
GUICtrlSetBkColor($postTimerLabel, $GUI_BKCOLOR_TRANSPARENT);

; Initially hide our overlay window, but set to top
GUISetState(@SW_HIDE, $timer);
WinSetOnTop($timer, "", 1);

While 1
	; To uniquely identify the correct window, more than just the window title was needed, thus the text identification
	If WinActive($printDialogWindow, $printDialogText) Then
		; Make sure it's active ... likely unnecessary
		;WinWait($printDialogWindow, $printDialogText);
		;If Not WinActive($printDialogWindow, $printDialogText) Then WinActivate($printDialogWindow, $printDialogText);
		;WinWaitActive($printDialogWindow, $printDialogText);

		; Set the position of the timer based on the targeted Cassie window
		_SetTimerPosition();

		; Make the overlay window visible and set to top
		GUISetState(@SW_SHOW, $timer);
		WinSetOnTop($timer, "", 1);

		; Reset the timers
		$countdownTime = _SetIdleSeconds($seconds_to_wait);
		$ticks = TimerInit();
		$idleTime = _Timer_GetIdleTime();

		; Begin looping for the timers until informed otherwise (i.e.: loopComplete = True)
		While $loopComplete = False
			; If the last saved "idle time" is greater than actual idle time, reset stuff
			If $idleTime > _Timer_GetIdleTime() Then
				$ticks         = TimerInit();
				$countdownTime = _SetIdleSeconds($seconds_to_wait);
				GUICtrlSetColor($TimeLabel, "0x000000"); Reset to black
			EndIf
			; Update the idle time checking variable and then run _Check() (main function)
			$idleTime = _Timer_GetIdleTime();
			_Check();
			Sleep(50);
		WEnd
		$loopComplete = False;
		GUICtrlSetColor($TimeLabel, "0x000000"); Reset to black
	Else
		Sleep(100);
	EndIf
WEnd

; The guts of this script...
; If Cassie window doesn't exist, it was closed...reset and hide everything
; Update timers and update text controls if necessary, as well as colors and audio cue
Func _Check()
	If Not WinExists($printDialogWindow, $printDialogText) Then
		GuiSetState(@SW_HIDE, $timer);
		$loopComplete = True;
		Return 0;   Exit Early
	EndIf
	WinSetOnTop($timer, "", 1);
    $countdownTime -= TimerDiff($ticks);
    $ticks = TimerInit();
	$_SecCalc = $countdownTime;
    $_SecCalc = Int($_SecCalc / 1000);

	; If the remaining seconds are less than or equal to zero, close the print job window and exit calling loop
    If $_SecCalc <= 0 Then
        _Exit();
		$loopComplete = True;
    Else
        If $_SecCalc <> $_Seconds Then
            $_Seconds = $_SecCalc;
            ControlSetText ($timer, "", $TimeLabel, _FormatTime($_Seconds-1));
			; Subtracting 1 second for comparison since our visible display is one second less than actual (so we can see a 0 value)
			If ($_SecCalc-1) <= $alert_seconds Then
				GUICtrlSetColor($TimeLabel, "0x" & $alert_text_color);
				If $alarm Then Beep(1200, 100);
			ElseIf ($_SecCalc-1) <= $notice_seconds Then
				GUICtrlSetColor($TimeLabel, "0x" & $notice_text_color);
			Else
				; There's a bug with "transparent" background text color and dynamically changing text, this corrects it
				GUICtrlSetColor($TimeLabel, "0x" & 0x000000);
			EndIf
        EndIf
    EndIf
EndFunc ;==> _Check()

; Converts seconds to milliseconds and returns the value for use in timer calculations
Func _SetIdleSeconds($seconds)
	Return ($seconds + 2) * 1000;
EndFunc

; Accepts a value in seconds, returns a formatted string for time display based on initial time
; 100 seconds --> "1:40"
;  60 seconds --> "60"
Func _FormatTime($seconds)
	If $seconds_to_wait >= 100 Then
		If $seconds < 60 Then
			Return StringFormat("%02u", $seconds);
		Else
			Return Int($seconds / 60) & ":" & StringFormat("%02u", Mod($seconds, 60));
		EndIf
	Else
		Return StringFormat("%02u", $seconds);
	EndIf
EndFunc

; Hides overlay window, sets focus to Cassie Print dialog window, then closes it
Func _Exit()
	$countdownTime = _SetIdleSeconds($seconds_to_wait);
	GuiSetState(@SW_HIDE, $timer);
	WinWait($printDialogWindow, $printDialogText)
	If Not WinActive($printDialogWindow, $printDialogText) Then WinActivate($printDialogWindow, $printDialogText)
	WinWaitActive($printDialogWindow, $printDialogText)
	Send("!{F4}");    close the currently focused window
EndFunc

; Dynamically sets the overlay countdown timer window based on Cassie's print dialog window size and position
Func _SetTimerPosition()
	$data = WinGetPos($printDialogWindow, $printDialogText);
	WinMove($timer, "", $data[0]+$window_x_padding, ($data[1] + $data[3] - $overlay_height - $window_y_padding));
EndFunc