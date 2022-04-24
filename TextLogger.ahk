;AHK V2

class TextLog {
    /*
        A class to store the currently logged string, together with the caret position.

        TODO: Make this a singleton class. But not too important rn
    */

    loggedString := ""

    caretPos := 0
    isSelection := False
    selectionStartPos := 0
    selectionEndPos := 0

    __new() {
    }

    findMarkerDistance(marker) {
        /*
            Strings can be makred by %&i%, and pressing the given key will jump to the next %&i%.
            @param marker (str)
            
            If marker does not exist, returns ""
            If marker exists, return the distance between cursor position and marker position (start of marker).
            -ve => marker position is to the left of cursor, +ve => marker position is to the right of cursor
        */

        markerPos := InStr(this.loggedString, marker)

        return markerPos == 0 ? "" : markerPos - (this.caretPos + 1)

    }

    sendString(str) {
        ; Add a string at where the caret is, and move caret position right by 1.
        this.loggedString := this._getCaretLeft() str this._getCaretRight()
        this.caretPos += StrLen(str)
    }

    sendBackspace(n := 1, ctrlState := False) {
        ; Backspace by n characters (default 1), from where the caret is.

        ; reset if this goes outside of the saved characters

        if (n == 0) {
            Return
        }

        if (this.caretPos < n) {
            this.reset()
            return
        }

        this.loggedString := Substr(this._getCaretLeft(), 1, this.caretPos-n) this._getCaretRight()
        this.caretPos := this.caretPos - n
    }

    sendDelete(n := 1, ctrlState := False) {
        ; Delete by n characters (default 1), from where the caret is.
        ; is like pressing the delete button

        if (n == 0) {
            Return
        }

        if (this.caretPos + n > StrLen(this.loggedstring)) {
            this.reset()
            return
        }

        this.loggedString := this._getCaretLeft() SubStr(this._getCaretRight(), n+1)
    }

    sendLeft(n := 1, ctrlState := False) {

        if (n == 0) {
            Return
        }

        if (this.caretPos < n) {
            this.reset()
            return
        }

        this.caretPos -= n
    }

    sendRight(n := 1, ctrlState := False) {

        if (n == 0) {
            Return
        }

        if (this.caretPos + n > StrLen(this.loggedstring)) {
            this.reset()
            return
        }

        this.caretPos += n
    }

    sendEnter(n := 1) {
        if (n == 0) {
            Return
        }

        Loop n
            this.sendString(Chr(13))
    }

    deleteSelection(str) {
        len := StrLen(str)
        if (SubStr(this.loggedstring, this.caretPos, len) == str) {
            this.sendDelete(len)
            return
        }

        if (SubStr(this.loggedstring, this.caretPos - len, len) == str) {
            this.sendBackspace(len)
            return
        }
    }

    reset() {
        ; Reset the object
        this.loggedString := [""]
        this.caretPos := 0
        this.caretRow := 1
        this.isSelection := False
        this.selectionStartPos := 0
        this.selectionEndPos := 0
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
        this.sendBackspace(StrLen(replacedStr))
        this.sendString(replacementStr)
    }

    _getCaretLeft() {
        ; Get the string to the left of the caret position
        return SubStr(this.loggedString, 1, this.caretPos)
    }

    _getCaretRight() {
        ; Get the string to the right of the caret position
        return SubStr(this.loggedString, this.caretPos + 1)
    }

    _getPrintStr() {
        return "Current Str: " this._getCaretLeft() "|" this._getCaretRight() "[END]"
    }
}

