; AHK V2
#Include HotStringManager.ahk

; Miscellaneous optimisations from https://www.autohotkey.com/boards/viewtopic.php?t=6413
KeyHistory 0
ListLines False

; TODO: Hotstring regex: use lookahead instead of the other thing
; TODO: handle selection delete
; TODO: ctrl backspace, left right can be handled as ctrl shift backspace, left right
; TODO: Currently uses space to trigger regex search, but is it possible to do it every keystroke?
; TODO: Is there a more efficient way to search through all the regex instead of looping through everything

/*
    Synatax:
    - regex is just regex
    - %$i% represents the ith capture group of the regex
    - %&0% makes the cursor jump to the marker after the hotstring, deleting the marker
    - %&i% makes the cursor jump to the marker (with the lowest i, i >= 1) on tap, deleting the marker
    - `r for newline

    addHotString is the same thing as detecting through the regex ([^a-zA-Z0-9_]?) + searchString + $

    - Note that hotstring priority prioritises keys added first.
*/

hotStrings := HotStringManager()

/*
    --- SETTINGS ---
*/
hotStrings.max_capture_groups := 2 ; Optimisation: The maximum number of capture groups needed in any regex/custom hotstring (always >= 1)
hotStrings.max_cursor_markers := 3 ; Optimisation: Maximum number of cursor markers in any hotstring
hotStrings.allowed_prefix_regex := "(?<=[^a-zA-Z0-9_]|^)" ; This is a regex that corresponds to the valid characters before a hotstring

/*
    --- SYMBOLS ---
*/
/*
    All greek symbols  - shortcut by their first two characters al or \al => alpha.
    Only exceptions are :
        \beta - be clashes with the word be, and so beta is the shortcut instead.
        two-letter greek words, cause \mu => \mu as a hotstring is dumb
*/
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?al$","\alpha")
hotStrings.addHotString("\be","\beta")
hotStrings.addHotString("beta","\beta") ; be is a word.
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ga$","\gamma")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?De$","\Delta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?de$","\delta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ep$","\epsilon")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ze$","\zeta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?et$","\eta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?Th$","\Theta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?th$","\theta")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?io$","\iota")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ka$","\kappa")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?La$","\Lambda")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?la$","\lambda")
hotStrings.addHotString("mu", "\mu") ; Obviously, \mu => \mu is a shitty hotstring
hotStrings.addHotString("nu", "\nu")
hotStrings.addHotString("Xi", "\Xi")
hotStrings.addHotString("xi", "\xi")
hotStrings.addHotString("Pi", "\Pi")
hotStrings.addHotString("pi", "\pi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?Si$", "\Sigma")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?si$", "\sigma")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ta$", "\tau")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?Ph$", "\Phi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ph$", "\phi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ch$", "\chi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?Ps$", "\Psi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?ps$", "\psi")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?Om$", "\Omega")
hotStrings.addRegexHotString(hotStrings.allowed_prefix_regex "\\?om$", "\omega")

hotStrings.addRegexHotString("(?<=[^a-zA-Z0-9_\\]|^)pm", "\pm") ; pm => \pm
hotStrings.addRegexHotString("(?<=[^a-zA-Z0-9_\\]|^)mp", "\mp") ; mp => \mp

/*
    --- TEXT MODIFIERS ---
*/

hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.(?:hat|aht|ath)$", "\hat{%$1%}") ; x.hat, x.aht, x.ath => \hat{x}
hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.bar$", "\overline{%$1%}") ; x.bar => \overline{x}
hotStrings.addRegexHotString("([\^_])([-a-zA-Z0-9}\\][-a-zA-Z0-9{}}\\,\|]*)$", "%$1%{%$2%}") ; x_bar, x^hat => x_{bar}, x^{hat}
hotStrings.addHotString("sq", "\sqrt{%&0%}%&1%") ; sq => \sqrt{%&0%}%&1%
hotStrings.addHotString("sqrt", "\sqrt{%&0%}%&1%") ; sqrt => \sqrt{%&0%}%&1%
; hotStrings.addHotString("/", "\frac{%&0%}{%&1%}%&2%")

;   FRACTIONS
hotStrings.addCustomRegexHotstring( ; a/ => \frac{a}{
    "\([a-zA-Z0-9_\\{}\(\)\[\]\+\-\*]+\)\/$", 
    fractionOnlyNumeratorCaptureGroup, 
    "\frac{%$1%}{%&0%}%&1%"
)

hotStrings.addCustomRegexHotstring(
    "\([a-zA-Z0-9_\\{}\(\)\[\]\+\-\*]+\)\/[a-zA-Z0-9_\\{}\(\)\[\]\+\-\*\^_]+$", 
    fractionCaptureGroup, 
    "\frac{%$1%}{%$2%}%&0%"
) ; a/ => \frac{a}{
hotStrings.addRegexHotString("([a-zA-Z0-9_\\{}\(\)\[\]]+)\/$", "\frac{%$1%}{%&0%}%&1%") ; a/ => \frac{a}{|}
hotStrings.addRegexHotString("([a-zA-Z0-9_\\{}\(\)\[\]]+)\/([a-zA-Z0-9_\\{}\(\)\[\]\+\-\*\^_]+)$", "\frac{%$1%}{%$2%}") ; a/b=> \frac{a}{b}|
hotStrings.addHotString("/", "\frac{%&0%}{%&1%}%&2%") ; / => \frac{|}{}

/*
    --- ENVIRONMENTS ---
*/
hotStrings.addHotString("mk", "$%&0%$%&1%") ; mk => inline math
hotStrings.addHotString("dm", "`r$$`r%&0%`r$$`r%&1%") ; dm => display math

hotStrings.addHotString("ali", "\begin{align}`r%&0%`r\end{align}`r%&1%")
hotStrings.addHotString("ali*", "\begin{align*}`r%&0%`r\end{align*}`r%&1%")
hotStrings.addHotString("te", "\text{%&0%}%&1%") ; te => \text{}
hotStrings.addHotString("bf", "\mathbf{%&0%}%&1%") ; bf => \mathbf{}
hotStrings.addHotString("bb", "\mathbb{%&0%}%&1%") ; bb => \mathbb{}

hotStrings.addHotString("beg", "\begin.%&0%") ; beg => \begin.<cursor>
hotStrings.addRegexHotString("\\begin\.([a-zA-Z0-9*]+)", "\begin{%$1%}`r%&0%`r\end{%$1%}`r%&1%") ; \begin.<input> -> environment

/*
    Custom Capturegroup functions
*/

fractionOnlyNumeratorCaptureGroup(str) {
    ; For getting the capture group of (something)/ => auto-detect brackets around numerator

    depth := 0
    index := StrLen(str) - 1
    Loop StrLen(str) {
        if (SubStr(str, index, 1) == ")") {
            depth += 1
        }
        if (SubStr(str, index, 1) == "(") {
            depth -= 1
        }
        if (depth == 0) {
            break
        }
        index -= 1
    }

    ; creating capture group object
    result := Map(0, SubStr(str, index, StrLen(str) - index) "/", 1, SubStr(str, index + 1, StrLen(str) - index - 2))
    return result
}

fractionCaptureGroup(str) {
    ; for getting the caputre group of (something)/something_else => auto-detect brackets around numerator
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

    return Map(0, str,
        1, SubStr(num_dim_array[1], index + 1, StrLen(num_dim_array[1]) - index - 1),
        2, num_dim_array[2]
    )

}