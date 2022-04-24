; OutputDebug "Starting Input Logger:"
; ih := ""
; ih := InputHook("VC")
; ih.keyOpt("{All}", "NV")
; ; ih.OnKeyDown := Func("onKeyDown")
; ih.OnKeyDown := onKeyDown
; ih.Start()

; onKeyDown(hook, vk, sc) {
;     ; Check if anything is selected
;     ClipSaved := A_Clipboard
;     A_Clipboard := "" ; Start off empty to allow ClipWait to detect when the text has arrived.
;     SendInput "^c"
;     ClipWait ; Wait for the clipboard to contain text.
;     MsgBox "Control-C copied the following contents to the clipboard:`n`n" A_Clipboard
; }

#c::{
oCB := A_Clipboard  ; save clipboard contents
Send "^c"
ClipWait 1

OutputDebug "Control-C copied the following contents to the clipboard:"
OutputDebug A_Clipboard

A_Clipboard := oCB         ; return original Clipboard contents
return
}