#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>              ; Fixes issue with odd transparent pixels w/normal AutoIt image/background methods
#include ".\UDFs\BlockInputEx.au3"	; Attempts to block ALT+TAB from working (works in XP, sort of mimics it in >= Vista

Opt('TrayIconDebug', 0);	Set to 1 to view current line in tray icon via tooltip
Opt('TrayIconHide', 1);		Set to 1 to hide the tray icon
Opt("GUIOnEventMode", 1);	Can call an event on action (like button click)


; --- FORCED DISPLAY SIGNAGE CODE --- ;
$minutes_until_display = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "minutes_until_display", 10);
$seconds_to_display    = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "time_delay_secs",       20);
$background_color      = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "background_color",      "000000");
$splash_image          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "splash_image",          "images\splash.jpg")
$text_color            = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "text_color",            "CCCCCC");
$font_size             = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "font_size",             24);
$font_weight           = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "font_weight",           600);
$close_msg             = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "close_msg",             "I Understand");
$font_family           = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "font_family",           "Verdana");
$message_text          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "message_text",          "You have a little over 10 minutes remaining." & @CRLF & "Please save your work.");
$button_width          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "button_width",          100);
$button_height         = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "button_height",         30);
$button_left           = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "button_left",           (@DesktopWidth - $button_width)/2);
$button_top            = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "button_top",            (@DesktopHeight/2 - $button_height/2) + 768);
$window_width          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "window_width",          @DesktopWidth);
$window_height         = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "window_height",         @DesktopHeight);
$image_width           = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "image_width",           @DesktopWidth);
$image_height          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "image_height",          @DesktopHeight);
$window_class          = IniRead(@ScriptDir & "\settings.ini", "TimerScreenSettings", "window_class",          "[REGEXPTITLE:(.* minutes)]");
$left = (@DesktopWidth - $image_width) / 2;         Image centering placement
$top  = (@DesktopHeight - $image_height) / 2;       Image centering placement
;$left = (1024 - $image_width) / 2;     Image centering placement
;$top  = (768 - $image_height) / 2;     Image centering placement


; Create newlines from the settings.ini file information
$message_text = StringReplace($message_text,'\n',@CRLF);


; --- TIME/WINDOW DETECTION CODE --- ;
$window = WinWait($window_class, "", 1);            Pauses script execution until the Cassie timer/application toolbar window is created and active
While 1
	$time_remaining = WinGetTitle($window_class);   Cassie displays time remaining in title of window
	$time_remaining = StringReplace($time_remaining, " minutes", "");   Replace "X minutes" with "X"
	Sleep(5000)
	If $time_remaining = $minutes_until_display Then
		ExitLoop
	EndIf
WEnd


; --- Set the Form Controls --- ;
; Window
$kiosk = GUICreate("", $window_width, $window_height, 0, 0, $WS_POPUP);
WinSetOnTop($kiosk, "", 1);                     Set the window to show up above all other windows
GuiSetBkColor("0x" & $background_color);
; Background image
_GDIPlus_Startup()
$hBitmap  = _GDIPlus_BitmapCreateFromFile(@ScriptDir & "\" & $splash_image);    load bitmap as GDI+ bitmap
$hHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap);                   convert it to a GDI bitmap
_GDIPlus_BitmapDispose($hBitmap);
$iPic = GUICtrlCreatePic("", $left, $top, 640, 480);
$hB   = GUICtrlSendMsg($iPic, 0x0172, 0, $hHBITMAP);                            copy GDI bitmap to picture control
If $hB Then _WinAPI_DeleteObject($hB);
GuiCtrlSetState(-1,$GUI_DISABLE);
; Close button
$close = GUICtrlCreateButton($close_msg, $button_left, $button_top, $button_width, $button_height);
GUICtrlSetDefColor("0x" & $text_color);
GUISetFont($font_size, $font_weight, '', $font_family);
GUICtrlSetFont($close, $font_size, $font_weight, 0, $font_family);
GUICtrlSetOnEvent($close,"Remove");				Close the window early
; Dummy button for use with blocking key commands
$dummyCtrl1 = GUICtrlCreateDummy();
$dummyCtrl2 = GUICtrlCreateDummy();
; Label text
GUICtrlCreateLabel($message_text, 15, 15);       Place the text in the GUI
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT);


;--- Block certain keys/combos for XP machines ---;
; Enter, Space, SHIFT+TAB, WIN+TAB, ALT+SHIFT+TAB, WIN+SHIFT+TAB
Local  $AccelKeys[3][2] = [["{ENTER}", $dummyCtrl1], ["{SPACE}", $dummyCtrl1], ["!{TAB}|#{TAB}|!+{TAB}|#+{TAB}", $dummyCtrl2]];
GUISetAccelerators($AccelKeys);


; --- Display the Coded Form --- ;
GUISetState(@SW_SHOW);
WinActivate($kiosk);


; Watch for key accelerators and perform an action while window open, or close window after set time expires
$timer = TimerInit();
Do
	$msg = GUIGetMsg();
	Select
		Case $msg = $dummyCtrl1
			; DO NOTHING
		Case $msg = $dummyCtrl2
			; DO NOTHING
		Case $msg = $close
			Remove();
	EndSelect
Until $msg = $close or TimerDiff($timer) > $seconds_to_display * 1000


; --- CLOSE THE KIOSK GUI EARLY --- ;
Func Remove ()
	GUIDelete();
	Exit;
EndFunc
Func blocked ()
EndFunc