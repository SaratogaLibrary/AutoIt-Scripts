#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Timers.au3>
#include <GuiConstants.au3>

;declare variables
$IDLETIME = 0
$SECONDS_TO_WAIT = INIREAD(@SCRIPTDIR & "\settings.ini", "CoinBoxTimer", "idle_seconds", 60)
$ACTION_TIME = 1000 * $SECONDS_TO_WAIT

WHILE 1
	$IDLETIME = _TIMER_GETIDLETIME()
	IF $IDLETIME >= $ACTION_TIME THEN
		WINWAIT("[CLASS:#32770; TITLE:Show Print Jobs]")
		IF NOT WINACTIVE("[CLASS:#32770; TITLE:Show Print Jobs]") THEN WINACTIVATE("[CLASS:#32770; TITLE:Show Print Jobs]")
		WINWAITACTIVE("[CLASS:#32770; TITLE:Show Print Jobs]")
		SEND("!{F4}")
	ELSEIF NOT WINACTIVE("[CLASS:#32770; TITLE:Show Print Jobs]") THEN
		MOUSEMOVE(MOUSEGETPOS(0) + 1, MOUSEGETPOS(1))
		MOUSEMOVE(MOUSEGETPOS(0) - 1, MOUSEGETPOS(1))
	ENDIF
	SLEEP(500)
WEND