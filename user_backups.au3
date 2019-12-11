#AutoIt3Wrapper_UseX64=y

#include <File.au3>
#include <Array.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

; ZIP archives could (theoretically; untested) be created using this UDF:
; https://www.autoitscript.com/forum/topic/21004-easy-zip-compression-using-windows-xp/

; NOTE: Firefox and Chrome FULL backups can be LARGE ... and take a lot of time
; All browsers must be closed for the backup to work or there will be a sharing violation and it will fail
;   ...even if the application says it was successful. (I could do further error checking but this was a rush job.)

$usb_drives = "";
$app_width = 450; pixels
$current_drive = StringUpper(StringLeft(@ScriptDir, 2));
$sLocation = '';

; Find the available Users folders
$user_folders = _FileListToArray('C:\Users\', '*', $FLTA_FOLDERS);
If @Error=1 Then
    MsgBox (0,"","No user folders found.");
    Exit
EndIf
; Convert to a readable format for the combobox (select/dropdown) component
$folder_string = '';
For $i = 1 To UBound($user_folders) - 1
	If $user_folders[$i] <> 'All Users' AND $user_folders[$i] <> 'Default User' Then
		$folder_string &= "|" & $user_folders[$i];
	EndIf
Next

; Get the currently available drives, then filter by USB drives and convert to a readable format for a combobox
$drive_array = DriveGetDrive($DT_ALL);
If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox($MB_SYSTEMMODAL, "", "It appears an error occurred detecting available drives.")
Else
    For $i = 1 To $drive_array[0]
        ; Show all the drives found and convert the drive letter to uppercase.
		$type = DriveGetType($drive_array[$i], $DT_BUSTYPE);
		If $type = 'USB' Then
			$usb_drives &= "|" & StringUpper($drive_array[$i]);
		EndIf
	Next
EndIf

; Build the GUI
$window                 = GUICreate("Browser and Sticky Notes Backup Tool", $app_width, 345);
$folder_label           = GUICtrlCreateLabel("Choose the user's folder to extract backups from:", 10, 10, $app_width - 20, 14);
$folder_select          = GUICtrlCreateCombo('', 10, 30, $app_width - 20, 20);
$drive_label            = GUICtrlCreateLabel("Choose the USB drive to save to:", 10, 70, $app_width - 20, 14);
$drive_select           = GUICtrlCreateCombo('', 10, 90, $app_width - 20, 20);
$backupChromeFull       = GUICtrlCreateCheckbox("Chrome Backup: Full", 11, 130, $app_width - 20, 25);
$backupChromeBookmarks  = GUICtrlCreateCheckbox("Chrome Backup: Bookmarks", 11, 150, $app_width - 20, 25);
$backupFirefoxFull      = GUICtrlCreateCheckbox("Firefox Backup: Full", 11, 170, $app_width - 20, 25);
$backupFirefoxBookmarks = GUICtrlCreateCheckbox("Firefox Backup: Bookmarks", 11, 190, $app_width - 20, 25);
$backupIE               = GUICtrlCreateCheckbox("IE Backup: Favorites", 11, 210, $app_width - 20, 25);
$backupEdge             = GUICtrlCreateCheckbox("Edge Backup", 11, 230, $app_width - 20, 25);
$backupStickyNotes      = GUICtrlCreateCheckbox("Sticky Notes Backup", 11, 250, $app_width - 20, 25);
$backupRainlendar       = GUICtrlCreateCheckbox("Rainlendar Backup", 11, 270, $app_width - 20, 25);
$submit_button          = GUICtrlCreateButton("Backup!", 10, 310, 145, 25);

; Set option values for the select (combo) boxes
GUICtrlSetData($folder_select, $folder_string);
GUICtrlSetData($drive_select, $usb_drives, $current_drive);

; Set the default state of the checkbox options
GUICtrlSetState($backupChromeFull, $GUI_UNCHECKED);
GUICtrlSetState($backupChromeBookmarks, $GUI_CHECKED);
GUICtrlSetState($backupFirefoxFull, $GUI_UNCHECKED);
GUICtrlSetState($backupFirefoxBookmarks, $GUI_CHECKED);
GUICtrlSetState($backupIE, $GUI_CHECKED);
GUICtrlSetState($backupEdge, $GUI_CHECKED);
GUICtrlSetState($backupStickyNotes, $GUI_CHECKED);
GUICtrlSetState($backupRainlendar, $GUI_CHECKED);

; Set the background color, and show the GUI window
GUISetBkColor(0x00EEEEEE);
GUISetState(@SW_SHOW);

While 1
    Switch GUIGetMsg()
		Case $submit_button
			CopyFiles();
			Exit;
        Case $GUI_EVENT_CLOSE
            Exit;
    EndSwitch
WEnd

Func CopyFiles()
	$drive  = GUICtrlRead($drive_select);
	$folder = GUICtrlRead($folder_select);
	$msg    = '';

	; USB Drive User Folder
	If NOT FileExists($drive & "\" & $folder) Then
		DirCreate($drive & "\" & $folder);
	EndIf

	; Google Chrome
	$chromePath = "C:\Users\" & $folder & "\AppData\Local\Google\Chrome\User Data\Default";
	If _IsChecked($backupChromeFull) Then
		If FileExists($chromePath) Then
			DirCopy($chromePath, $drive & "\" & $folder & "\Chrome\Default");
			$msg &= "Chrome backed up." & @CRLF;
		Else
			$msg &= "Chrome data not found." & @CRLF;
		EndIf
	EndIf

	; Google Chrome Bookmarks
	If _IsChecked($backupChromeBookmarks) Then
		$chromePath = $chromePath & "\Bookmarks";
		If FileExists($chromePath) Then
			FileCopy($chromePath, $drive & "\" & $folder & "\Chrome Bookmarks\Bookmarks", $FC_CREATEPATH);
			$msg &= "Chrome Bookmarks backed up." & @CRLF;
		Else
			$msg &= "Chrome Bookmarks file not found." & @CRLF;
		EndIf
	EndIf

	; Mozilla Firefox
	$firefoxPath = "C:\Users\" & $folder & "\AppData\Roaming\Mozilla\Firefox\Profiles";
	If FileExists($firefoxPath) Then
		$path = "";
		$profiles = _FileListToArray($firefoxPath, "*", $FLTA_FOLDERS);
		If (UBound($profiles)-1) > 0 Then
			$time = FileGetTime($firefoxPath & "\" & $profiles[1], 0);
			$time = $time[0] & $time[1] & $time[2] & $time[3] & $time[4];
			$path = $profiles[1];
		EndIf
		For $i = 2 to UBound($profiles)-1
			$time2 = FileGetTime($firefoxPath & "\" & $profiles[$i], 0);
			$time2 = $time2[0] & $time2[1] & $time2[2] & $time2[3] & $time2[4];
			If ($time2 > $time) Then
				$time = $time2;
				$path = $profiles[$i];
			EndIf
		Next
		$firefoxPath = $firefoxPath & "\" & $path;

		If _IsChecked($backupFirefoxFull) Then
			DirCopy($firefoxPath, $drive & "\" & $folder & "\Firefox\" & $path);
		EndIf

		If _IsChecked($backupFirefoxBookmarks) Then
			$firefoxPath = $firefoxPath & "\places.sqlite";
			FileCopy($firefoxPath, $drive & "\" & $folder & "\Firefox Bookmarks\places.sqlite", $FC_CREATEPATH);
		EndIf

		$msg &= "Firefox backed up." & @CRLF;
	Else
		$msg &= "Firefox data not found." & @CRLF;
	EndIf

	; Internet Explorer
	If _IsChecked($backupIE) Then
		$iePath = "C:\Users\" & $folder & "\Favorites";
		If FileExists($iePath) Then
			DirCopy($iePath, $drive & "\" & $folder & "\IE");
			$msg &= "IE Favorites backed up." & @CRLF;
		Else
			$msg &= "IE data not found." & @CRLF;
		EndIf
	EndIf

	; Edge
	If _IsChecked($backupEdge) Then
		$edgePath = "C:\Users\" & $folder & "\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User\Default\DataStore\Data\nouser1\120712-0049\DBStore\spartan.edb";
		If FileExists($edgePath) Then
			FileCopy($edgePath, $drive & "\" & $folder & "\Edge\spartan.edb", $FC_CREATEPATH);
			$msg &= "Edge database file backed up." & @CRLF;
		Else
			$msg &= "Edge data not found." & @CRLF;
		EndIf
	EndIf

	; Sticky Notes
	If _IsChecked($backupStickyNotes) Then
		$notesPath = "C:\Users\" & $folder & "\AppData\Roaming\Microsoft\Sticky Notes\StickyNotes.snt";
		If FileExists($notesPath) Then
			FileCopy($notesPath, $drive & "\" & $folder & "\Sticky Notes\", $FC_CREATEPATH);
			$msg &= "Sticky Notes backed up." & @CRLF;
		Else
			$msg &= "Sticky Notes data not found." & @CRLF;
		EndIf
	EndIf

	; Rainlendar
	If _IsChecked($backupRainlendar) Then
		$calendarPath = "C:\Users\" & $folder & "\.rainlendar2";
		If FileExists($calendarPath) Then
			DirCopy($calendarPath, $drive & "\" & $folder & "\Rainlendar");
			$msg &= "Rainlendar data backed up." & @CRLF;
		Else
			$msg &= "Rainlendar data not found." & @CRLF;
		EndIf
	EndIf

	; Show an informative message
	MsgBox(32, "Backup Result", $msg);
EndFunc

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
