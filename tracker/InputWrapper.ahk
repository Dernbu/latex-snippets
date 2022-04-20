; AHK V2
#Include TextLogger.ahk

class InputWrapper {
    /*
        A functor class that wraps around a TextLog class.
    */

    /*
        Map - keys are replacement strings and value are the regex capture functions.
    */
    captureReplacementFunctions := Map()

    textLog := "" ; TextLog object wrapped by this object
    inputHook := "" ; InputHook object 

    __new() {

        ; initialise textLog variable
        this.textLog := TextLog()

        OutputDebug "Starting Input Logger:"
        this.inputHook := InputHook("VC")
        this.inputHook.keyOpt("{All}", "NV")
        this.inputHook.OnChar := ObjBindMethod(this, "onKeyPress")
        this.inputHook.OnKeyDown := ObjBindMethod(this, "onKeyDown")

        this.inputHook.Start()

        ; Space, Enter and tab: Action keys
        Hotkey "$Space", ObjBindMethod(this, "onAction")
        ; Hotkey "Enter", ObjBindMethod(this, "onAction")
        Hotkey "$Tab", ObjBindMethod(this, "gotoMarker")

        ; Mouse hotkeys: Reset the textLog object
        HotKey "~LButton", ObjBindMethod(this, "onMousePress")
        HotKey "~RButton", ObjBindMethod(this, "onMousePress")
        HotKey "~MButton", ObjBindMethod(this, "onMousePress")
        HotKey "~XButton1", ObjBindMethod(this, "onMousePress")
        HotKey "~XButton2", ObjBindMethod(this, "onMousePress") 

    }

    gotoMarker(key) {
        /*
            Strings can be makred by %&i%, and pressing the given key will jump to the next %&i%.
        */

        pressKey := True

        Loop 10 {
            marker := "%&" A_Index-1 "%"

            markerDistance := this.textLog.findMarkerDistance(marker)

            ; Not found
            if (markerDistance == "") {
                Continue
            }

            if (markerDistance <= -StrLen(marker)) {
                ; entire marker is to left of cursor
                ; go to back of marker and press backspace
                this.sendLeft(- markerDistance - StrLen(marker))
                this.sendBackspace(StrLen(marker))

            } else if (markerDistance >= -StrLen(marker) && markerDistance <= 0) {
                ; cursor is inside marker
                ; go to back of marker and press backspace
                this.sendRight(StrLen(marker) + markerDistance)
                this.sendBackspace(StrLen(marker))
            } else {
                ; marker is to right of cursor
                ; go to front of marker and press delete
                this.sendRight(markerDistance)
                this.sendDelete(StrLen(marker))
            }
            pressKey := False
            Break
        }
        ; If nothing is done, you have to press the key
        if (pressKey) {
            key := StrReplace(key, "$")
            Switch key {
            Case "Space":
                this.sendString(" ")
            Case "Tab":
                this.sendString("`t")
            Default:
                this.sendString(key)
            }

        }
    }

    onAction(key) {
        /*
            The onAction function 
        */

        regexReplaced := False
        ; Loop through all replacements and capture group, and do the first one you find
        For replacementStr, captureGroupFunction in this.captureReplacementFunctions {

            captureGroup := this.getRightmostCaptureGroup(captureGroupFunction)

            if (captureGroup == "") {
                Continue
            }

            regexReplaced := True
            replacementStr := getRegexReplacementString(captureGroup, replacementStr)
            this.sendBackspace(StrLen(CaptureGroup[0]))
            this.sendString(replacementStr)

            this.gotoMarker("")

            Break
        }

        ; if nothign is done, just send the string
        if (!regexReplaced) {
            key := StrReplace(key, "$")
            Switch key {
            Case "Space":
                this.sendString(" ")
            Default:
                this.sendString(key)
            }
        }
    }

    onKeyPress(hook, char) {

        if (char == " ") {
            return
        }
        this.textLog.sendString(char)
        OutputDebug "Key Pressed: " char
        OutputDebug this._getPrintStr()
    }

    onKeyDown(hook, vk, sc) {
        keyName := GetKeyName(Format("vk{:x}sc{:x}", vk, sc))
        OutputDebug "Key Down: " keyName

        Switch (keyName) {

        Case "Backspace":
            this.textLog.sendBackspace(1, InputWrapper.getCtrlState())
        Case "Left":
            this.textLog.sendLeft(1, InputWrapper.getCtrlState())
        Case "Right":
            this.textLog.sendRight(1, InputWrapper.getCtrlState())
        Case "Delete":
            this.textLog.sendDelete(1, InputWrapper.getCtrlState())

        }

        OutputDebug this._getPrintStr()
    }

    onMousePress(key) {
        OutputDebug "Mouse Pressed: " key
        this.textLog.reset()
    }

    /*
        Hotstring/hotkey functions
    */
    getRightmostCaptureGroup(captureGroupFunction) {
        /*
            Check if a capture group can be found with the given function
            @param captureGroupFunction a function object that takes in a string parameter
                to return a capture group (string)
                
            - The capture group is assumed to be at the end of the string (end of string is at cursor.)
            - Regex remember "$" at the end

            @return "" if capture group is not found, else return the capture group itself.
        */

        return this.textLog.getRightmostCaptureGroup(captureGroupFunction)

    }

    /*
        Wrapped functions that send stuff
    */

    sendBackspace(n := 1) {
        SendInput "{Backspace " n "}"
        this.textLog.sendBackspace(n)
    }

    sendString(string) {
        SendInput "{raw}" string
        this.textLog.sendString(string)
    }

    sendLeft(n := 1) {
        SendInput "{Left " n "}"
        this.textLog.sendLeft(n)
    }
    sendRight(n := 1) {
        SendInput "{Right " n "}"
        this.textLog.sendRight(n)

    }
    sendDelete(n := 1) {
        SendInput "{Delete " n "}"
        this.textLog.sendDelete(n)
    }

    replaceRightmostString(captureStr, replacementStr) {
        /*
            Replace the rightmost string  in the buffer with the given replacement string
            Also replaces the string in textLog
        */
        this.textLog.replaceRightmostString(captureStr, replacementStr)
        ; MsgBox captureStr " | " replacementStr
        SendInput "{Backspace " StrLen(captureStr) "}{Raw}" replacementStr
    }

    addRegexHotString(regex, replacement) {
        /*
            Adds a regex hotstring to the target object.
            @param regex the regex that triggers the hotstring.
                Note that the regex is only triggered/checked when pressing space (before space has been sent)
                Note that the regex should end with a $ (check end of string, right before caret)
            
            @parem replacement the replacement string to replace the target string captured by the regex.
                Syntax: %$i% for the ith capture group
                        %&i% for the ith cursor hop (first cursor hop is executed automatically)
        */
        this.captureReplacementFunctions.set(replacement, InputWrapper.makeRegexCaptureFunction(regex))
    }

    addHotString(string, replacement) {
        this.captureReplacementFunctions.set("%$1%" replacement, InputWrapper.makeStringCaptureFunction(string))
    }

    /*
        Utility functions to make dynamic function objects for capture groups
    */
    static makeRegexCaptureFunction(regex) {
    /*
        Function to dynamically generate regex capture functions from a regex string.
        */
        newFunction(str) {
            capture := ""
            RegExMatch(str, regex, &capture)
        return capture
    }
    return newFunction
}

static makeStringCaptureFunction(str) {
            /*
            Function to dynamically generate capture functions from a string.
            TODO more efficient way?
    */
    str := strReplace(str, "\", "\\")
    str := strReplace(str, ".", "\.")
    return InputWrapper.makeRegexCaptureFunction("(\s|^)" str "$")
}
    /*
        State helping functions
*/
static getCapsLockState() {
    return GetKeyState("CapsLock", "T")
}

static getShiftState() {
    return GetKeyState("Shift", "P")
}

static getCapsState() {
    ; Get state of overall caps - considering both caps lock and shift
    return GetKeyState("CapsLock", "T")^GetKeyState("Shift", "P")
}

static getCtrlState() {
    return GetKeyState("Control", "P")
}

static getAltState() {
    return GetKeyState("Alt", "P")
}

_getPrintStr() {
    return this.textLog._getPrintStr()
}

}

/*
Utility functions
*/

getRegexReplacementString(captureGroup, replacementStr) {
    /*
    Get the regex replacement string by replacing %$i% wtih the ith capture group.
    */

    captureGroupNumber := 1

    while True {
        if (InStr(replacementStr, "%$" captureGroupNumber "%") == 0) {
            Break
        }
        ; OutputDebug replacementStr
        replacementStr := StrReplace(replacementStr, "%$" captureGroupNumber "%" , captureGroup[captureGroupNumber])
        OutputDebug "replaced" replacementStr
        captureGroupNumber += 1
    }

    return replacementStr
}