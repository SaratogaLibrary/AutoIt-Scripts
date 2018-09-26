#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>				; Fixes issue with odd transparent pixels w/normal AutoIt image/background methods
#include ".\UDFs\BlockInputEx\BlockInputEx.au3"	; Attempts to block ALT+TAB from working (works in XP, sort of mimics it in >= Vista

Opt('TrayIconDebug',  0);   Set to 1 to view current line in tray icon via tooltip
Opt('TrayIconHide',   1);   Set to 1 to hide the tray icon
Opt("GUIOnEventMode", 1);   Can call an event on action (like button click)


; --- FORCED DISPLAY SIGNAGE CODE --- ;
$seconds_to_display    = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "time_delay_secs",       10);
$background_color      = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "background_color",      "000000");
$splash_image          = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "splash_image",          "images\splash.jpg")
$image_width           = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "image_width",           @DesktopWidth);
$image_height          = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "image_height",          @DesktopHeight);
$window_title          = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "window_title",          "Usage Policy");
$left = (@DesktopWidth - $image_width) / 2;         Image centering placement
$top  = (@DesktopHeight - $image_height) / 2;       Image centering placement


; --- TIME/WINDOW DETECTION CODE --- ;
$window = WinWaitClose($window_title, "", 1);       Pauses script execution until the Cassie Usage Policy window is accepted (and closed)


; --- Set the Form Controls --- ;
; Window
$kiosk = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP);
WinSetOnTop($kiosk, "", 1);                                                     Set the window to show up above all other windows
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
; Dummy button for use with blocking key commands
$dummyCtrl1 = GUICtrlCreateDummy();
$dummyCtrl2 = GUICtrlCreateDummy();


;--- Block certain keys/combos for XP machines ---;
; Enter, Space, SHIFT+TAB, WIN+TAB, ALT+SHIFT+TAB, WIN+SHIFT+TAB
Local  $AccelKeys[3][2] = [["{ENTER}", $dummyCtrl1], ["{SPACE}", $dummyCtrl1], ["!{TAB}|#{TAB}|!+{TAB}|#+{TAB}", $dummyCtrl2]];
GUISetAccelerators($AccelKeys);


; --- Display the Coded Form --- ;
GUISetState(@SW_SHOW);
WinActivate($kiosk);


; Close window after set time expires, disallow other actions with AccelKeys
$timer = TimerInit();
Do
	$msg = GUIGetMsg();
	Select
		Case $msg = $dummyCtrl1
			; DO NOTHING
		Case $msg = $dummyCtrl2
			; DO NOTHING
	EndSelect
Until TimerDiff($timer) > $seconds_to_display * 1000


; --- CLOSE THE KIOSK GUI EARLY --- ;
Func Remove ()
	GUIDelete();
	Exit;
EndFunc
Func blocked ()
EndFunc