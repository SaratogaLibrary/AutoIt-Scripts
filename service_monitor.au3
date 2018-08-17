#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon
#include ".\UDFs\Services.au3"

; Assign necessary variables
; Note: Service Name is NOT the display name -- View service properties in GUI to get actual service name
$serviceName  = IniRead(@ScriptDir & "\settings.ini", "CassieCrashDetect", "service_name",   'CassieUserStation');
$window_class = IniRead(@ScriptDir & "\settings.ini", "CassieCrashDetect", "windowclass",    "[REGEXPTITLE:(.* minutes)]");
$reboot_msg   = IniRead(@ScriptDir & "\settings.ini", "CassieCrashDetect", "message",        "Restarting PC to correct application failure. Please save your work.");
$reboot_secs  = IniRead(@ScriptDir & "\settings.ini", "CassieCrashDetect", "reboot_seconds", 300);	5 minute default

Sleep(1.5 * 60 * 1000);                Don't start the service checking until 1.5 minutes after boot, in case of slow startup

While 1
	Sleep(10 * 1000); Check every 10 seconds
	$status = _Service_QueryStatus($serviceName);
	$status = $status[1];

	If $status <> $SERVICE_RUNNING Then
		Switch $status
			Case $SERVICE_STOP_PENDING
				Sleep(30 * 1000);
				_Service_Start($serviceName);
				Run(@ComSpec & " /c sc start " & $serviceName, "", @SW_HIDE);
			Case $SERVICE_STOPPED
				_Service_Start($serviceName);
				Run(@ComSpec & " /c sc start " & $serviceName, "", @SW_HIDE);
			Case $SERVICE_PAUSE_PENDING
				Sleep(30 * 1000);
				_Service_Resume($serviceName);
				Run(@ComSpec & " /c sc continue " & $serviceName, "", @SW_HIDE);
			Case $SERVICE_PAUSED
				_Service_Resume($serviceName);
				Run(@ComSpec & " /c sc continue " & $serviceName, "", @SW_HIDE);
			Case $SERVICE_CONTINUE_PENDING  ; ignore, should be working soon
			Case $SERVICE_START_PENDING     ; ignore, should be working soon
		EndSwitch
		Sleep(10 * 1000);                     give the GUI 10 seconds to reappear after restarting the service
	EndIf

	; If service was stopped, GUI should be back up after the service is restarted well before the 10 second sleep is reached
	; ... need to check on kiosk window being present though
	If 0 = WinExists($window_class) Then ; GUI crashed -- restart PC after displaying warning for 5 minutes [ini setting] ... alert uses SplashTextOn
		; Don't start the restart sequence for 30 seconds, just in case a patron properly Exited their session and this check was done prior to Cassie's shutdown command was issued
		Sleep(30 * 1000);
		SplashTextOn("", $reboot_msg, -1, -1, -1, -1, 21, "", 24);
		Run(@ComSpec & " /c " & "shutdown -r -f -t " & $reboot_secs, "", @SW_HIDE);
		Sleep($reboot_secs * 1000);
		SplashOff();
	EndIf
WEnd