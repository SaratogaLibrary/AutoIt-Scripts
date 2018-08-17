#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>


; --- FORCED DISPLAY SIGNAGE CODE --- ;
$seconds_to_display = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "time_delay_secs",  "10");
$background_color   = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "background_color", "000000");
$splash_image       = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "splash_image",     "images\splash.jpg")
$window_title       = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "window_title",     "Usage Policy");
$image_width        = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "image_width",      "1024");
$image_height       = IniRead(@ScriptDir & "\settings.ini", "SplashScreenSettings", "image_height",     "768");


; --- CONVERT NUMERIC DATA FROM SETTINGS TO NUMERIC VALUES --- ;
; ...probably unnecessary, but recommended by AutoIT documentation
$seconds_to_display = Int($seconds_to_display);
$image_width        = Int($image_width);
$image_height       = Int($image_height);


; --- WINDOW DETECTION CODE --- ;
;$window = WinWait($window_title);				Pauses script execution until a window with title "Usage Policy" exists
;$window = WinActivate($window_title);			Places focus on the Usage Policy window (if not already)
;WinWaitClose($window);							Pauses script execution until the designated window is closed

; ^ handled by "run_on_window.au3" script, set in registry


$gui = GuiCreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP);
GuiSetState(@SW_SHOW);							Show the window
WinSetOnTop($gui, "", 1);						Set the window to show up above all other windows
GuiSetBkColor("0x" & $background_color);
$left = (@DesktopWidth - $image_width) / 2;
$top  = (@DesktopHeight - $image_height) / 2;
$n = GUICtrlCreatePic(@ScriptDir & "\" & $splash_image, $left, $top, $image_width, $image_height);
Sleep ( $seconds_to_display * 1000 );