#Hotstring C o * R0

/*
    inline math mode, and
    display math mode
*/
; inline math mode
::mk ::$${left 1}
; This is specially set for Obsidian, since Enter causes problems in a bullet list.
; TODO: Figure out how to write newline (asc 010 or 013) directly without mapping to enter.
; ::dm ::{U+000D}{U+000A}
; ::dm ::$$$${left 2}
; ::dm ::`r`n$$`r`n`r`n$${up 1}
::dm ::{Enter}$${Enter}{Enter}$${Left 3}
; ::dm ::`n$$`n`n$${up 1}
; ::dm ::{asc 013}$${asc 013}{asc 013}$${up 1}
; ::dm ::`r$$`r`r$${up 1}
; ::dm ::{asc 010}$${asc 010}{asc 010}$${up 1}

/*
    align and align*
*/
::ali ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
; ::align ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
::ali* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}
; ::align* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}

/*
    \begin ENVIRONMENT
*/
::beg ::
; beg -> \begin-
SendInput \begin.
; begin capturing input for environment name
; visual mode --> can see your input 
Input, envName, V, {Esc} {Space} {Tab} {Enter}
; delete the typed input and dash
StringLen, envNameLength, envName
SendInput {Backspace %envNameLength%}
; need extra backspace for endchar in visual mode
SendInput {Backspace 2}
; input the rest of the environment
SendInput {{}%envName%{}}{Enter}{Enter}\end{{}%envName%{}}
; go back to the middle for typing
SendInput {Left %envNameLength%}
SendInput {Left 7}
Return


; turn on ending character agai