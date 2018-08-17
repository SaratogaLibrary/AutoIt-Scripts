#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#include "UDFs\_PowerKeepAlive.au3"

; Found from: https://www.autoitscript.com/forum/topic/152381-screensaver-sleep-lock-and-power-save-disabling/

; Singleton code:
If WinExists("SA_0bc53fe0-59c2-11e2-bcfd-0800200c9a66_SA") Then Exit
AutoItWinSetTitle("SA_0bc53fe0-59c2-11e2-bcfd-0800200c9a66_SA")

Opt("TrayOnEventMode", 0)
Opt("TrayMenuMode", 1+2)
TraySetClick(8+1)

Local $iTrayExit = TrayCreateItem("Exit + Reenable Sleep")

; Disable screensaver, power-save, etc
_PowerKeepAlive()
; Be sure to register this to reenable power-saving, screensaver, etc
OnAutoItExitRegister("_PowerResetState")

; Now we're ready to accept messages
TraySetState()

While TrayGetMsg() <> $iTrayExit
    ; No need for sleep
WEnd