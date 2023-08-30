#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=N ;Pidgin is a 32-bit application, this causes @ProgramFilesDir to point correctly
#AutoIt3Wrapper_Outfile=C:\Users\bkozlowski\Desktop\chat_setup.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIError.au3>
#include "D:\backups\Scripts\AutoIT\UDFs\XML_1.1.1.13\XML_1.1.1.13\XML.au3"


; ==============================================================================================================================
; Title .........: chat_config_install.au3
; AutoIt Version : 3.3.10.2++
; Description ...: Allows for a user to self-install and configure Pidgin for use with LibraryH3lp - prompts user for un/pw
; Author(s) .....: Brendon Kozlowski
; Original Script idea from: https://community.spiceworks.com/scripts/show/1857-automatically-configure-pidgin-for-ldap-and-xmpp
; ==============================================================================================================================

; Steps:
; 1. Gather user account info
; 2. Install Pidgin
; 3. Copy config files to user's PURPLEHOME/.purple directory
; 4. Edit necessary portions of newly copied config files

; Command line parameters:
; 1. Username
; 2. Password
; 3. Domain (optional)

; Set program runtime options
Opt("SendKeyDelay", 20);

; Get config variable information
$APP    = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "exe_name",     "pidgin-2.11.0-offline.msi");
$PATH   = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "exe_location", @WorkingDir & '\');
$TITLE  = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "title",        "Buddy List");
$GROUP  = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "chat_group",   "Chat Rooms");
$CHAT   = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "chat_name",    "sspl-general");
$PASS   = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "chat_pass",    "Tz3RAWjg4oUdPBkwwHLdbQ==");
;$DOMAIN = IniRead(@ScriptDir & "\config.ini", "PidginConfigSettings", "user_domain",  "SSPL");

; Assign initial variables for pidgin account information
$pidginUsername = "";
$pidginPassword = "";
$pidginDomain   = "";

; Get commandline parameters (if any) and set associated variables
If @Compiled Then
	If $CmdLine[0] > 3 Then
		Exit;
	EndIf
	Switch $CmdLine[0]
		Case 1
			$pidginUsername = $CmdLine[1];
		Case 2
			$pidginUsername = $CmdLine[1];
			$pidginPassword = $CmdLine[2];
		Case 3
			$pidginUsername = $CmdLine[1];
			$pidginPassword = $CmdLine[2];
			$pidginDomain   = $CmdLine[3];
		Case Else
			$pidginUsername = InputBox("Configuration: Username", "Please enter the username:");
			$pidginPassword = InputBox("Configuration: Password", "Please enter the password:", "", "*");
			; $pidginDomain   = InputBox("Configuration: Domain",   "If provided, please enter the domain (otherwise leave blank):");
			$pidginDomain   = 'libraryh3lp.com';
	EndSwitch
Else
	$pidginUsername = InputBox("Configuration: Username", "Please enter the username:");
	$pidginPassword = InputBox("Configuration: Password", "Please enter the password:", "", "*");
	; $pidginDomain   = InputBox("Configuration: Domain",   "If provided, please enter the domain (otherwise leave blank):");
	$pidginDomain   = 'libraryh3lp.com';
EndIf

If $pidginUsername = '' OR $pidginPassword = '' Then
	MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, 'Exiting...', 'User cancelled, exiting setup.', 3);
	Exit;
EndIf

;;;;;;;;;;
; STEP 1 ;
;;;;;;;;;;

; Find the My Documents location, then append 'pidgin_config' to the path, and create it
;$purplePath = @MyDocumentsDir & '\pidgin_config_' & $pidginUsername;
;DirCreate($purplePath);

; Set the registry
;RegWrite('HKEY_CURRENT_USER\Environment', 'PURPLEHOME', 'REG_SZ', $purplePath);

; Default Config/Files Install Location
$purplePath = @AppDataDir;


;;;;;;;;;;
; STEP 2 ;
;;;;;;;;;;

SplashTextOn("Chat Install", "Please wait while the application" & @CRLF & "is installed.", -1, -1, -1, -1, 32, "", 24);
$return = RunWait('"' & $PATH & $APP & '" /DS=1 /SMS=0 /L=1033 /S');


If @error Then
	Local $sLastError = _WinAPI_GetLastErrorMessage();
	MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Error", "Application has not Run :" & @CRLF & @CRLF & $sLastError);
	Exit;
EndIf

ControlSetText("Chat Install", "", "Static1", "Application installed. Please wait" & @CRLF & "while it is now customized.");


;;;;;;;;;;
; STEP 3 ;
;;;;;;;;;;

$copied = DirCopy($PATH & '.purple', $purplePath & '\.purple', $FC_OVERWRITE);
If $copied = 0 Then
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Error:', 'Error copying configuration files to User Roaming AppData location.', 5);
	Exit;
EndIf


;;;;;;;;;;
; STEP 4 ;
;;;;;;;;;;

; 1. accounts.xml: Find //account/account/name, set value to username @ domain/ (note ending forward slash)
; 2. accounts.xml: Find //account/account/password, set value to password
; 3. accounts.xml: Save

Local $oXML = _XML_CreateDOMDocument(Default);
Local $sXML = $purplePath & '\.purple\accounts.xml';
_XML_Load($oXML, $sXML);

If @error Then
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended));
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '_XML_Load', _XML_ErrorParser_GetDescription($oXML));
	Exit;
EndIf

; MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Pre-UpdateField', _XML_TIDY($oXML));
_XML_UpdateField($oXml, '/account/account/name',     $pidginUsername & '@' & $pidginDomain & '/');
_XML_UpdateField($oXml, '/account/account/password', $pidginPassword);
; MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Post-UpdateField', _XML_TIDY($oXML));

; Create new accounts.xml file from new version in memory; must delete then create, XML lib doesn't support overwriting (by design)
FileDelete($sXML);
_XML_SaveToFile($oXML, $sXML);


; 1. prefs.xml: Find plugin pathlist information and update to current user's path
; 3. prefs.xml: Save
Local $sContent  = FileRead($purplePath & '\.purple/prefs.xml');
Local $sUserPath = AddDomain() ? @UserName & '.SSPL' : @UserName;
$sContent = StringReplace($sContent, 'bkozlowski', $sUserPath);
$sContent = StringReplace($sContent, "<pref name='theme' type='string' value='Default'/>", "<pref name='theme' type='string' value='Android Emoji Theme'/>");
FileDelete($purplePath & '\.purple/prefs.xml');
FileWrite($purplePath & '\.purple/prefs.xml', $sContent);

; Add the Chat Rooms to the Client - must interact with the GUI to do so...
Run(@ProgramFilesDir & "\Pidgin\pidgin.exe");
WinWait($TITLE);
WinActivate($TITLE);
WinWaitActive($TITLE, "", 30);
Sleep(5000);

Send("!b");       Activate "Buddy" Menu
Sleep(10);
Send("h");        Add cHat
Sleep(10);
Send($CHAT);      channel name
Sleep(10);
Send("!p");       Focus password field
Sleep(10);
Send($PASS);      Password
Sleep(10);
Send("!g");       Focus group name
Sleep(10);
Send($GROUP);     Group name
Sleep(10);
Send("{TAB 2}");  Tab twice
Sleep(10);
Send("{SPACE}");  Activate checkbox
Sleep(10);
Send("{TAB}");    Tab once
Sleep(10);
Send("{SPACE}");  Activate checkbox
Sleep(10);
Send("{ENTER}");  OK/Apply settings
Sleep(3000);
Send("^q");       Quit Pidgin - settings are finalized

; End the script
ControlSetText("Chat Install", "", "Static1", "All done! Thank you!");
Sleep(5000);
SplashOff();


; #FUNCTION# ====================================================================================================================
; Name ..........: XML_My_ErrorParser
; Description ...: Changing $XML_ERR_ ... to human readable description
; Syntax ........: XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended)
; Parameters ....: $iXMLWrapper_Error	 - an integer value.
;                  $iXMLWrapper_Extended - an integer value.
; Return values .: description as string
; Author ........: mLipok
; Modified ......:
; Remarks .......: This function is only example of how user can parse @error and @extended to human readable description
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended = 0)
	Local $sErrorInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_SUCCESS
			$sErrorInfo = '$XML_ERR_SUCCESS=' & $XML_ERR_SUCCESS & @CRLF & 'All is ok.'
		Case $XML_ERR_GENERAL
			$sErrorInfo = '$XML_ERR_GENERAL=' & $XML_ERR_GENERAL & @CRLF & 'The error which is not specifically defined.'
		Case $XML_ERR_COMERROR
			$sErrorInfo = '$XML_ERR_COMERROR=' & $XML_ERR_COMERROR & @CRLF & 'COM ERROR OCCURED. Check @extended and your own error handler function for details.'
		Case $XML_ERR_ISNOTOBJECT
			$sErrorInfo = '$XML_ERR_ISNOTOBJECT=' & $XML_ERR_ISNOTOBJECT & @CRLF & 'No object passed to function'
		Case $XML_ERR_INVALIDDOMDOC
			$sErrorInfo = '$XML_ERR_INVALIDDOMDOC=' & $XML_ERR_INVALIDDOMDOC & @CRLF & 'Invalid object passed to function'
		Case $XML_ERR_INVALIDATTRIB
			$sErrorInfo = '$XML_ERR_INVALIDATTRIB=' & $XML_ERR_INVALIDATTRIB & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_INVALIDNODETYPE
			$sErrorInfo = '$XML_ERR_INVALIDNODETYPE=' & $XML_ERR_INVALIDNODETYPE & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_OBJCREATE
			$sErrorInfo = '$XML_ERR_OBJCREATE=' & $XML_ERR_OBJCREATE & @CRLF & 'Object can not be created.'
		Case $XML_ERR_NODECREATE
			$sErrorInfo = '$XML_ERR_NODECREATE=' & $XML_ERR_NODECREATE & @CRLF & 'Can not create Node - check also COM Error Handler'
		Case $XML_ERR_NODEAPPEND
			$sErrorInfo = '$XML_ERR_NODEAPPEND=' & $XML_ERR_NODEAPPEND & @CRLF & 'Can not append Node - check also COM Error Handler'
		Case $XML_ERR_PARSE
			$sErrorInfo = '$XML_ERR_PARSE=' & $XML_ERR_PARSE & @CRLF & 'Error: with Parsing objects, .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_PARSE_XSL
			$sErrorInfo = '$XML_ERR_PARSE_XSL=' & $XML_ERR_PARSE_XSL & @CRLF & 'Error with Parsing XSL objects .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_LOAD
			$sErrorInfo = '$XML_ERR_LOAD=' & $XML_ERR_LOAD & @CRLF & 'Error opening specified file.'
		Case $XML_ERR_SAVE
			$sErrorInfo = '$XML_ERR_SAVE=' & $XML_ERR_SAVE & @CRLF & 'Error saving file.'
		Case $XML_ERR_PARAMETER
			$sErrorInfo = '$XML_ERR_PARAMETER=' & $XML_ERR_PARAMETER & @CRLF & 'Wrong parameter passed to function.'
		Case $XML_ERR_ARRAY
			$sErrorInfo = '$XML_ERR_ARRAY=' & $XML_ERR_ARRAY & @CRLF & 'Wrong array parameter passed to function. Check array dimension and content.'
		Case $XML_ERR_XPATH
			$sErrorInfo = '$XML_ERR_XPATH=' & $XML_ERR_XPATH & @CRLF & 'XPath syntax error - check also COM Error Handler.'
		Case $XML_ERR_NONODESMATCH
			$sErrorInfo = '$XML_ERR_NONODESMATCH=' & $XML_ERR_NONODESMATCH & @CRLF & 'No nodes match the XPath expression'
		Case $XML_ERR_NOCHILDMATCH
			$sErrorInfo = '$XML_ERR_NOCHILDMATCH=' & $XML_ERR_NOCHILDMATCH & @CRLF & 'There is no Child in nodes matched by XPath expression.'
		Case $XML_ERR_NOATTRMATCH
			$sErrorInfo = '$XML_ERR_NOATTRMATCH=' & $XML_ERR_NOATTRMATCH & @CRLF & 'There is no such attribute in selected node.'
		Case $XML_ERR_DOMVERSION
			$sErrorInfo = '$XML_ERR_DOMVERSION=' & $XML_ERR_DOMVERSION & @CRLF & 'DOM Version: ' & 'MSXML Version ' & $iXMLWrapper_Extended & ' or greater required for this function'
		Case $XML_ERR_EMPTYCOLLECTION
			$sErrorInfo = '$XML_ERR_EMPTYCOLLECTION=' & $XML_ERR_EMPTYCOLLECTION & @CRLF & 'Collections of objects was empty'
		Case $XML_ERR_EMPTYOBJECT
			$sErrorInfo = '$XML_ERR_EMPTYOBJECT=' & $XML_ERR_EMPTYOBJECT & @CRLF & 'Object is empty'
		Case Else
			$sErrorInfo = '=' & $iXMLWrapper_Error & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @error'
	EndSwitch

	Local $sExtendedInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_COMERROR, $XML_ERR_NODEAPPEND, $XML_ERR_NODECREATE
			$sExtendedInfo = 'COM ERROR NUMBER (@error returned via @extended) =' & $iXMLWrapper_Extended
		Case $XML_ERR_PARAMETER
			$sExtendedInfo = 'This @error was fired by parameter: #' & $iXMLWrapper_Extended
		Case Else
			Switch $iXMLWrapper_Extended
				Case $XML_EXT_DEFAULT
					$sExtendedInfo = '$XML_EXT_DEFAULT=' & $XML_EXT_DEFAULT & @CRLF & 'Default - Do not return any additional information'
				Case $XML_EXT_XMLDOM
					$sExtendedInfo = '$XML_EXT_XMLDOM=' & $XML_EXT_XMLDOM & @CRLF & '"Microsoft.XMLDOM" related Error'
				Case $XML_EXT_DOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_DOMDOCUMENT=' & $XML_EXT_DOMDOCUMENT & @CRLF & '"Msxml2.DOMDocument" related Error'
				Case $XML_EXT_XSLTEMPLATE
					$sExtendedInfo = '$XML_EXT_XSLTEMPLATE=' & $XML_EXT_XSLTEMPLATE & @CRLF & '"Msxml2.XSLTemplate" related Error'
				Case $XML_EXT_SAXXMLREADER
					$sExtendedInfo = '$XML_EXT_SAXXMLREADER=' & $XML_EXT_SAXXMLREADER & @CRLF & '"MSXML2.SAXXMLReader" related Error'
				Case $XML_EXT_MXXMLWRITER
					$sExtendedInfo = '$XML_EXT_MXXMLWRITER=' & $XML_EXT_MXXMLWRITER & @CRLF & '"MSXML2.MXXMLWriter" related Error'
				Case $XML_EXT_FREETHREADEDDOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_FREETHREADEDDOMDOCUMENT=' & $XML_EXT_FREETHREADEDDOMDOCUMENT & @CRLF & '"Msxml2.FreeThreadedDOMDocument" related Error'
				Case $XML_EXT_XMLSCHEMACACHE
					$sExtendedInfo = '$XML_EXT_XMLSCHEMACACHE=' & $XML_EXT_XMLSCHEMACACHE & @CRLF & '"Msxml2.XMLSchemaCache." related Error'
				Case $XML_EXT_STREAM
					$sExtendedInfo = '$XML_EXT_STREAM=' & $XML_EXT_STREAM & @CRLF & '"ADODB.STREAM" related Error'
				Case $XML_EXT_ENCODING
					$sExtendedInfo = '$XML_EXT_ENCODING=' & $XML_EXT_ENCODING & @CRLF & 'Encoding related Error'
				Case Else
					$sExtendedInfo = '$iXMLWrapper_Extended=' & $iXMLWrapper_Extended & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @extended'
			EndSwitch
	EndSwitch
	; return back @error and @extended for further debuging
	Return SetError($iXMLWrapper_Error, $iXMLWrapper_Extended, _
			'@error description:' & @CRLF & _
			$sErrorInfo & @CRLF & _
			@CRLF & _
			'@extended description:' & @CRLF & _
			$sExtendedInfo & @CRLF & _
			'')

EndFunc    ;==>XML_My_ErrorParser

Func AddDomain()
	Local $position  = StringInStr(@AppDataDir, @UserName);
	Local $addDomain = (StringInStr(@AppDataDir, @UserName & '\') <> $position);

	Return $addDomain;
EndFunc
