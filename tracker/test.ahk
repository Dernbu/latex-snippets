hatCaptureFunction(str) {
    capture := ""
    RegExMatch(str, "[a-zA-Z0-9_]*.hat$", &capture)
    return capture[0]
}

fn := hatCaptureFunction
; MsgBox fn("b.hat")

CAPTURE_REPLACEMENT_FUNCTIONS = Map(
        hat, ["\hat{%$1%}", hatCaptureFunction]
    )