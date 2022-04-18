#Include, regex_hotstrings.ahk
; expressions_regex contains more difficult autocomplete that regex_hotstrings need to be used for
#Include, expressions_regex.ahk

/*
    Shortcut for greek symbols with first two characters
    Files for triggering with tab/space.
*/
; #Include, greek_symbols_tab.ahk
#Include, greek_symbols_space.ahk

/*
    Shortcut for expressions:
    - frac
    - sqrt
    - text
    - mathbf
    - mathbb
*/
#Include, expressions.ahk
#Include, environments.ahk

; #Hotstring EndChars `t
; #Hotstring C o *0