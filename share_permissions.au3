#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icons\My Files.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>		; form controls
#include <Constants.au3>			; text type (ex: @CRLF)
#include <EditConstants.au3>		; form controls
#include <GUIConstantsEx.au3>		; form generation
#include <Process.au3>				; _Run command
#include <StaticConstants.au3>		;
#include <WindowsConstants.au3>		;
#include <WinAPI.au3>				; Set focus

;Opt('TrayIconDebug', 1);			Show tooltip in tray icon for current executing line
Opt('WinTitleMatchMode', 2);		Match window title by any substring

; Give myself some credit for this little utility
;TraySetToolTip('My Files provides access to your personal files from any computer.' & chr(13) & 'Programmer: Brendon Kozlowski');

; --- APPLICATION SETTINGS AND DEFAULTS --- ;
$default_domain = IniRead("myfiles.ini", "ServerSettings", "default_domain", "");		Pre-filled data for domain box in form
$server_name    = IniRead("myfiles.ini", "ServerSettings", "server_name",    "");
$server_ip      = IniRead("myfiles.ini", "ServerSettings", "server_ip",      "");
$share_path     = IniRead("myfiles.ini", "ServerSettings", "share_path",     "");	Path to specific server share from root (with trailing slash)
$use_ip_mapping = IniRead("myfiles.ini", "ShareSettings",  "use_ip_mapping", True);				Use IP to map network drive (false for server name)
$drive_letter   = IniRead("myfiles.ini", "ShareSettings",  "drive_letter",   "Q");				Drive letter to map to

$winHandle = '';					Declare the variable globally for use in multiple methods later
$is_mapped = false;					Used to determine whether we've mapped the drive or not (to prevent msgbox from showing on close event if no drive's been mapped)

; Create the form
$form = GUICreate("Share Permissions", 346, 178, 192, 124)
$passwordLabel = GUICtrlCreateLabel("Password:", 16, 80, 53, 17)
$introLabel = GUICtrlCreateLabel("This allows you to access server shares under your own account.", 8, 8, 320, 17)
$domainLabel = GUICtrlCreateLabel("Domain:", 16, 32, 43, 17)
$usernameLabel = GUICtrlCreateLabel("Username:", 176, 32, 55, 17)
$domain = GUICtrlCreateInput($default_domain, 16, 48, 145, 21)
$username = GUICtrlCreateInput("", 176, 48, 153, 21)
$password = GUICtrlCreateInput("", 16, 96, 145, 21, $ES_PASSWORD)
$openFilesButton = GUICtrlCreateButton("Open Shares", 16, 136, 145, 25)
$closeLabel = GUICtrlCreateLabel("Keep open while working on your files." & @CRLF & @CRLF & "Close to 'log out' from your account and prevent misuse.", 176, 80, 156, 81)
_WinAPI_SetFocus(ControlGetHandle("Share Permissions", "", $username));
GUISetState(@SW_SHOW)
; Form creation end, and now shown

; Set our hotkey for the application
Local $hotkeys[1][2] = [["{ENTER}", $openFilesButton]];
GUISetAccelerators($hotkeys);		Maps the ENTER key to the MapDrive function when this window is in focus

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $openFilesButton
			MapDrive();
		Case $GUI_EVENT_CLOSE
			if ($is_mapped) Then
				$buttonPressed = MsgBox(4+48+256, 'ALERT! PLEASE NOTE!', "By closing this application you also disconnect from your files. If you still have files open/unsaved, you may lose your work. Are you sure you wish to close the application?", 0, $form);
				if ($buttonPressed == 6) Then
					UnmapDrive();
					Exit
				EndIf
			Else
				Exit
			EndIf
	EndSwitch
WEnd


Func MapDrive()
	; net use x: \\server\share /user:testuser@example.com password
	$dom   = GUICtrlRead($domain);
	$uname = GUICtrlRead($username);
	$pword = GUICtrlRead($password);
	If ($use_ip_mapping == True) Then
		$server = $server_ip;
	Else
		$server = $server_name
	EndIf

	If ($dom == "" Or $uname == "" Or $pword == "") Then
		MsgBox(16, 'Error', "All fields are required.");
	Else
		; For security, clear the current password data
		GUICtrlSetData($password, '');

		; Inform of the process, set the drive letter and run the `net use` command
		MsgBox(32, 'Loading...', 'Please wait a moment...your personal folder will appear momentarily, or an error message will appear.', 5);
		$drive_letter = StringUpper($drive_letter);
		$output = DriveMapAdd($drive_letter & ':', '\\' & $server & '\' & $share_path, 0, $dom & '\' & $uname, $pword);

		; Set the name of the window we will be looking for...
		$waitActiveWindow = $drive_letter & ':';

		; DriveMapAdd returns 1 on success, 0 on failure
		If ($output == 1) Then
			sleep(1000);									Give it time to fully map the drive before attempting to open it
			_RunDos('explorer '& $drive_letter & ':\');
			WinWaitActive($waitActiveWindow);				Wait for the window to open
			$winHandle = WinGetHandle($waitActiveWindow);	Get the window handle to know which window to close for UnmapDrive (requirement from included library)

			; set the is_mapped flag
			$is_mapped = true;
		Else
			Switch (@error)
				;; Case 1 == Undefined (therefore, else)
				Case 2
					$output = 'Access to the remote share was denied.';
				Case 3
					$output = 'The device is already assigned.';
				Case 4
					$output = 'Invalid device name.';
				Case 5
					$output = 'Invalid remote share.';
				Case 6
					$output = 'Invalid Password.';
				Case Else
					$output = 'Undefined / Other error: WinAPI Error #' & @extended;
			EndSwitch
			MsgBox(16, 'Error', $output);
		EndIf
	EndIf
EndFunc

Func UnmapDrive()
	DriveMapDel($drive_letter & ':');
	; If the Explorer window has not yet closed, close it...
	If WinExists($winHandle) Then
		WinClose($winHandle);
	EndIf
EndFunc