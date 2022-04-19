;AHK V2

class TextLog {
    /*
        A class to store the currently logged string, together with the caret position.

        TODO: Make this a singleton class. But not too important rn
    */

    loggedString := ""
    caretPosition := 0
    isSelection := False
    selectionStartPos := 0
    selectionEndPos := 0

    __new(loggedString := "", caretPosition := "") {
        /*
            Function for a new TextLog object.
            note caretPosition is an int
        */

        if (caretPosition == "") {
            caretPosition := StrLen(loggedString)
        }

        this.loggedString := loggedString
        this.caretPosition := caretPosition
        isSelection := False
        selectionStartPos := 0
        selectionEndPos := 0
    }

    map(strFunction, caretFunction) {
        ; By right i should return a new object,
        ; but I modify this one instead to save performance & memory
        ; Keep in mind this is called every keystroke

        ; return State(
        ;     strFunction(this.loggedString), 
        ;     caretFunction(this.caretPosition))

        this.loggedString := strFunction(this.loggedString)
        this.caretPosition := caretFunction(this.caretPosition)
        return this ; return this to chain function calls 
    }

    addStr(str) {
        ; Add a string at where the caret is, and move caret position right by 1.
        return this.map((s) => this._getCaretLeft() str this._getCaretRight(), (x) => x + StrLen(str))
    }

    backspace(n := 1, ctrlState := False) {
        ; Backspace by n characters (default 1), from where the caret is.

        if (ctrlState) {
            ; Get the number of characters to Ctrl+Delete, and backspace it
            ; Damn, this doesn't work TODO
            ; return this.backspace(StrLen(this._getCtrlBackspaceCapture()))
        }

        return this.map(
            (s) => Substr(this._getCaretLeft(), 1, this.caretPosition-n) this._getCaretRight(), 
            (x) => x < n ? 0 : x - n
        )
    }

    delete(n := 1) {
        ; Delete by n characters (default 1), from where the caret is.
        ; is like pressing the delete button
        return this.map(
            (s) => this._getCaretLeft() SubStr(this._getCaretRight(), n+1), 
            (x) => x < n ? 0 : x - n
        )

    }

    moveLeft(n := 1, ctrlState := False) {

        ; Tbh, this is a TODO
        ; if (ctrlState) {
        ;     ; Get the number of characters to Ctrl+Delete, and backspace it
        ;     return this.moveLeft(StrLen(this._getCtrlLeftCapture()))
        ; }

        return this.map(
            (s) => s, 
            (x) => x < n ? 0 : x - n
        )
    }

    moveRight(n := 1, ctrlState := False) {
        return this.map(
            (s) => s, 
            (x) => x + n > StrLen(this.loggedString) ? StrLen(this.loggedString) : x + n
        )
    }

    reset() {
        ; Reset the object
        this.loggedString := ""
        this.caretPosition := 0
        isSelection := False
        selectionStartPos := 0
        selectionEndPos := 0
    }

    getRightmostCaptureGroup(captureGroupFunction) {
        /*
            Check if a capture group can be found with the given function
            @param captureGroupFunction a function object that takes in a string parameter
                to return a capture group (string)
                
            - The capture group is assumed to be at the end of the string (end of string is at cursor.)
            - Regex remember "$" at the end

            @return "" if capture group is not found, else return the capture group itself.
        */

        captureGroup := captureGroupFunction(this._getCaretLeft())

        return captureGroup

    }

    replaceRightmostString(replacedStr, replacementStr) {
        this.backspace(StrLen(replacedStr))
        this.addStr(replacementStr)
    }

    _getCaretLeft() {
        ; Get the string to the left of the caret position
        return SubStr(this.loggedString, 1, this.caretPosition)
    }

    _getCaretRight() {
        ; Get the string to the right of the caret position
        return SubStr(this.loggedString, this.caretPosition + 1)
    }

    _getPrintStr() {
        return "Current Str: " this._getCaretLeft() "|" this._getCaretRight() "[END]"
    }

    /*
        Capture Group & Hotstring Functions
    */

    /*
        Helper functions
        These functions start with _
    */

    /*
    _getCtrlBackspaceCapture() {
        ; Get the characters skipped/selected/deleted when
        ; Ctrl + Left/Backspace is done  

        regexInfo := ""
        hayStack := this._getCaretLeft()

        RegExMatch(hayStack, "([^a-zA-Z0-9_]*)([a-zA-Z0-9_]*[^a-zA-Z0-9_]?)$", &regexInfo)
        capture := regexInfo[2]
        if (regexInfo[2] == "") {
            capture := regexInfo[1]
        }
        return capture 
    }
    */
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
