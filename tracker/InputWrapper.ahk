#Include TextLogger.ahk

regexCaptureFunction(regex) {
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

class InputWrapper {
    /*
        A functor class that wraps around a TextLog class.
    */

    /*
        Static Final Map - keys are replacement strings and value are the regex capture functions.
    */
    static CAPTURE_REPLACEMENT_FUNCTIONS := Map(
        "\hat{%$1%}", regexCaptureFunction("([a-zA-Z0-9_]*)\.hat$"), ; x.hat => \hat{x}
        "\overline{%$1%}", regexCaptureFunction("([a-zA-Z0-9_]*)\.bar$"), ; x.bar => \overline{x}
        "%$1%{%$2%}", regexCaptureFunction("([\^_])([a-zA-Z0-9]+)$") ; x_bar, x^hat => x_{bar}, x^{hat}
    )

    textLog := "" ; TextLog object wrapped by this object
    inputHook := "" ; InputHook object 

    __new(loggedString := "", caretPosition := "") {

        ; initialise textLog variable
        this.textLog := TextLog(loggedString, caretPosition)

        OutputDebug "Starting Input Logger:"
        this.inputHook := InputHook("VC")
        this.inputHook.keyOpt("{All}", "NV")
        ; this.inputHook.OnChar := this.onKeyPress
        this.inputHook.OnChar := ObjBindMethod(this, "onKeyPress")
        this.inputHook.OnKeyDown := ObjBindMethod(this, "onKeyDown")

        this.inputHook.Start()

        ; Space, Enter and tab: Action keys
        Hotkey "Space", ObjBindMethod(this, "onAction")
        ; Hotkey "Enter", ObjBindMethod(this, "onAction")
        ; Hotkey "Tab", ObjBindMethod(this, "onAction")

        ; Mouse hotkeys: Reset the textLog object
        ; HotKey "~LButton", ObjBindMethod(this, "onMousePress")
        ; HotKey "~RButton", ObjBindMethod(this, "onMousePress")
        ; HotKey "~MButton", ObjBindMethod(this, "onMousePress")
        ; HotKey "~XButton1", ObjBindMethod(this, "onMousePress")
        ; HotKey "~XButton2", ObjBindMethod(this, "onMousePress") 

    }

    onAction(key) {
        /*
            The onAction function 
        */

        For replacementStr, captureGroupFunction in InputWrapper.CAPTURE_REPLACEMENT_FUNCTIONS {

            captureGroup := this.getRightmostCaptureGroup(captureGroupFunction)

            if (captureGroup == "") {
                Continue
            }

            replacementStr := getRegexReplacementString(captureGroup, replacementStr)
            ; MsgBox captureGroup[0] " : " captureGroup[1] " : " replacementStr
            this.replaceRightmostString(captureGroup[0], replacementStr)

        }
    }

    onKeyPress(hook, char) {

        if (char == " ") {
            return
        }
        this.textLog.addStr(char)
        OutputDebug "Key Pressed: " char
        OutputDebug this._getPrintStr()
    }

    onKeyDown(hook, vk, sc) {
        keyName := GetKeyName(Format("vk{:x}sc{:x}", vk, sc))
        OutputDebug "Key Down: " keyName

        Switch (keyName) {

        Case "Backspace":
            this.textLog.backspace(1, InputWrapper.getCtrlState())
        Case "Left":
            this.textLog.moveLeft(1, InputWrapper.getCtrlState())
        Case "Right":
            this.textLog.moveRight(1, InputWrapper.getCtrlState())
        Case "Delete":
            this.textLog.delete(1, InputWrapper.getCtrlState())

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

    replaceRightmostString(captureStr, replacementStr) {
        this.textLog.replaceRightmostString(captureStr, replacementStr)
        ; MsgBox captureStr " | " replacementStr
        SendInput "{Backspace " StrLen(captureStr) "}{Raw}" replacementStr
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

t := InputWrapper()