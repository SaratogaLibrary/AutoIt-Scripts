#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <MsgBoxConstants.au3>
#include ".\UDFs\XML_1.1.1.13\XML_1.1.1.13\XML.au3"

#NoTrayIcon

; ==============================================================================================================================
; Title .........: chat_config_install.au3
; AutoIt Version : 3.3.10.2++
; Description ...: Allows for a user to self-install and configure Pidgin for use with LibraryH3lp - prompts user for un/pw
; Author(s) .....: Brendon Kozlowski
; Original Script idea from: https://community.spiceworks.com/scripts/show/1857-automatically-configure-pidgin-for-ldap-and-xmpp
; ==============================================================================================================================

; Steps:
; 1. Set User Environment Variable (PURPLEHOME); set to My Documents\pidgin_config_<username> (will create config folder [.purple] inside location declared as PURPLEHOME)
; 2. Install Pidgin
; 3. Copy config files to user's PURPLEHOME/.purple directory
; 4. Edit necessary portions of newly copied config files

; Command line parameters:
; 1. Username
; 2. Password
; 3. Domain (optional)

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
			$pidginUsername = InputBox("Configuration: Username", "Please enter the username provided to you:");
			$pidginPassword = InputBox("Configuration: Password", "Please enter the password provided to you:", "", "*");
			$pidginDomain   = InputBox("Configuration: Domain",   "If provided, please enter the domain (otherwise leave blank):");
	EndSwitch
EndIf

;;;;;;;;;;
; STEP 1 ;
;;;;;;;;;;

; Find the My Documents location, then append 'pidgin_config' to the path, and create it
$purplePath = @MyDocumentsDir & '\pidgin_config_' & $pidginUsername;
DirCreate($purplePath);

; Set the registry
RegWrite('HKEY_CURRENT_USER\Environment', 'PURPLEHOME', 'REG_SZ', $purplePath);


;;;;;;;;;;
; STEP 2 ;
;;;;;;;;;;

SplashTextOn("Chat Install", "Please wait while the application is installed.", -1, -1, -1, -1, 32, "", 24)
RunAsWait("Username", "DOMAIN", "Password", 0, 'msiexec /q /i "Full (shared server) path to pidgin MSI installation file" ');
ControlSetText("Chat Install", "", "Static1", "Application installed. Please wait while it is now customized.")


;;;;;;;;;;
; STEP 3 ;
;;;;;;;;;;

DirCopy('\\server_share\copy-of-default-.purple-directory\.purple', $purplePath & '\.purple');


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
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'ERR:' & @error & ' EXT:' & @extended, XML_My_ErrorParser(@error, @extended))
	MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, '_XML_Load', _XML_ErrorParser_GetDescription($oXML))
	Exit
EndIf

MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Pre-UpdateField', _XML_TIDY($oXML));
_XML_UpdateField($oXml, '/account/account/name',     $pidginUsername & '@' & $pidginDomain & '/');
_XML_UpdateField($oXml, '/account/account/password', $pidginPassword);
MsgBox($MB_SYSTEMMODAL + $MB_ICONINFORMATION, 'Post-UpdateField', _XML_TIDY($oXML));

; Create new accounts.xml file from new version in memory; must delete then create, XML lib doesn't support overwriting (by design)
FileDelete($purplePath & '\.purple\accounts.xml')
_XML_SaveToFile($oXMLDoc, $purplePath & '\.purple\accounts.xml');


; End the script
ControlSetText("Chat Install", "", "Static1", "All done! Thank you!")
Sleep(5000);
SplashOff();