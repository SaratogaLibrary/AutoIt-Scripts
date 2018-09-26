#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Timers.au3>
#include <GuiConstants.au3>

;declare variables
$IDLETIME = 0
$SECONDS_TO_WAIT = INIREAD(@SCRIPTDIR & "\settings.ini", "CoinBoxTimer", "idle_seconds", 60)
$WINDOW_TITLE    = INIREAD(@SCRIPTDIR & "\settings.ini", "CoinBoxTimer", "window_identifier", "[CLASS:#32770; TITLE:Show Print Jobs]");
$ACTION_TIME = 1000 * $SECONDS_TO_WAIT

WHILE 1
	$IDLETIME = _TIMER_GETIDLETIME()
	IF $IDLETIME >= $ACTION_TIME THEN
		WINWAIT($WINDOW_TITLE)
		IF NOT WINACTIVE($WINDOW_TITLE) THEN WINACTIVATE($WINDOW_TITLE)
		WINWAITACTIVE($WINDOW_TITLE)
		SEND("!{F4}")
	ELSEIF NOT WINACTIVE($WINDOW_TITLE) THEN
		MOUSEMOVE(MOUSEGETPOS(0) + 1, MOUSEGETPOS(1))
		MOUSEMOVE(MOUSEGETPOS(0) - 1, MOUSEGETPOS(1))
	ENDIF
	SLEEP(500)
WEND