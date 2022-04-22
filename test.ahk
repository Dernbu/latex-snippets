;AHK V2
; a := ["(one)/", "((one))/", "(one (two))/"]

; For str in a {
;     OutputDebug fractionOnlyNumeratorCaptureGroup(str)[0]
; }
; capture := ""


; RegExMatch("(a+b)/", "\([a-zA-Z0-9_\\{}\(\)\[\]\+\-\*]+\)\/$", &capture)
; OutputDebug capture[0]
; OutputDebug capture == ""

test := "(one)/two"
test := "(one + \alpha)/two"
fractionCaptureGroup(test)

fractionCaptureGroup(str) {
    ; for getting the caputre group of (something)/something_else
    num_dim_array := StrSplit(str, "/")
    
    ; numerator:
    depth := 0
    index := StrLen(num_dim_array[1])
    Loop StrLen(num_dim_array[1]) {
        if (SubStr(num_dim_array[1], index, 1) == ")") {
            depth += 1
        }
        if (SubStr(num_dim_array[1], index, 1) == "(") {
            depth -= 1
        }
        if (depth == 0) {
            break
        }
        index -= 1
    }

    
    OutputDebug str
    OutputDebug SubStr(num_dim_array[1], index + 1, StrLen(num_dim_array[1]) - index - 1)
    OutputDebug num_dim_array[2]

    return Map(
        0, str
        1, SubStr(num_dim_array[1], index + 1, StrLen(num_dim_array[1]) - index - 1)
        2, num_dim_array[2]
    )
}