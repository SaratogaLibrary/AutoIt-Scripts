#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <StaticConstants.au3>

; Match title by any substring found
Opt("WinTitleMatchMode", 2);
Opt('TrayIconDebug', 1);        Set to 1 to view current line in tray icon via tooltip
Opt('TrayIconHide', 0);         Set to 1 to hide the tray icon

$totalParams = $CmdLine[0];     Set a default
$debug       = false;           Prints passed args to MsgBox when true

Switch $totalParams
	Case 0 To 2
		PrintUsage();
		Exit 0;
	Case 3 To 63
		Switch StringLower($CmdLine[1])
			Case "-o"
				; On window open
				; Acceptable window title name formats: "Usage Policy", or "[REGEXPTITLE:(.* minutes)]"
				$window = WinWait($CmdLine[2]);             Pauses script execution until a window with a title supplied from the 2nd argument passed in the command line exists
			Case "-c"
				; On window close
				$window = WinWait($CmdLine[2]);             Pauses script execution until a window with a title supplied from the 2nd argument passed in the command line exists
				WinWaitClose($CmdLine[2]);                  Pauses script execution until the designated window is closed
			Case "-od"
				; On window open, and debug
				$window = WinWait($CmdLine[2]);             Pauses script execution until a window with a title supplied from the 2nd argument passed in the command line exists
				$debug = true;
			Case "-cd"
				; On window closed, and debug
				$window = WinWait($CmdLine[2]);             Pauses script execution until a window with a title supplied from the 2nd argument passed in the command line exists
				WinWaitClose($CmdLine[2]);                  Pauses script execution until the designated window is closed
				$debug = true;
			Case Else
				PrintUsage();
				Exit 0;     Break on wrong order of parameters
		EndSwitch
	Case Else
		PrintUsage();
		Exit 0;
EndSwitch

; Code to call the executables that were passed
$num_applications = $totalParams - 2;   total params (actual parameter), open/close flag, target window
$app_index = 0;

While $app_index < $num_applications
	If IsNumber($CmdLine[3 + $app_index]) Then
		Sleep(1000 * $CmdLine[3 + $app_index]);
	Else
		; Technically speaking, the only one that should be reached here is the last Else
		If StringIsFloat($CmdLine[3 + $app_index]) Then
			Sleep(1000 * $CmdLine[3 + $app_index]);
		ElseIf StringIsInt($CmdLine[3 + $app_index]) Then
			Sleep(1000 * $CmdLine[3 + $app_index]);
		Else
			Run(@ComSpec & " /c " & $CmdLine[3 + $app_index], "", @SW_HIDE);
		EndIf
	EndIf

	$app_index = $app_index + 1;
WEnd;

If $debug Then
	DebugArgs();
EndIf

Func PrintUsage()
	MsgBox(4096 + 48, @ScriptName, "Usage of ""Run on Window"":" & @CRLF & '-----------------------------------------------' & @CRLF & @CRLF & 'RUN APPLICATION(S) ON OPEN:' & @CRLF & 'run_on_window.exe -o "Window title/hWnd/class" [exe1[ exe2[...]]]' & _
		@CRLF & @CRLF & 'RUN APPLICATION(S) ON CLOSE:' & @CRLF & 'run_on_window.exe -c "Window title/hWnd/class" [exe1[ exe2[ ...]]]' & _
		@CRLF & @CRLF & 'Pass an additional ''d'' flag for debugging information (Ex: `run_on_window.exe -cd "Window title" [exe1]`)' & _
		@CRLF & @CRLF & '-----------------------------------------------' & @CRLF & 'NOTE: Use a number as an argument to pause script execution for that many seconds (ex: 2, 1.5, 15)');
EndFunc

Func DebugArgs()
	$testStr = '';
	$step = 0;
	For $param In $CmdLine
		$testStr = $testStr & $step & ": " & $param & @CRLF & @CRLF;
		$step = $step + 1;
	Next

	MsgBox(4096 + 48, @ScriptName, $testStr);
	Exit 0;
EndFunc