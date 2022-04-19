#Hotstring C o * R0

/*
    inline math mode, and
    display math mode
*/
; inline math mode
::mk ::$${left 1}

:?:dm ::
; Clear next line for input, important for lists in Obsidian, 
; where next line may have a bullet point.
;   ? lets dm have alphanumeric characters right before in triggering hotstring.
;   We do enter space, in case enter encounters an empty line, 
;   then there needs to be a space for the selection and deletion (shift+Home) delete
SendInput {Enter}{Space}
SendInput +{Home}{Backspace}

SendInput $${Enter}{Enter}$${Left 3}
Return

/*
    align and align*
    We assume dm has been done here, so no need to clear line.
*/
::ali ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
; ::align ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
::ali* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}
; ::align* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}

/*
    \begin ENVIRONMENT
*/
::beg ::

; beg -> \begin.
SendInput \begin.

; begin capturing input for environment name
; visual mode --> can see your input 
Input, envName, V, {Esc} {Space} {Tab} {Enter}

; delete the typed input and dash
StringLen, envNameLength, envName
SendInput {Backspace %envNameLength%}
; need two backspaces for dot and endchar in visual mode
SendInput {Backspace 2}

; input the rest of the environment
SendInput {{}%envName%{}}{Enter}{Enter}\end{{}%envName%{}}

; go back to the middle for typing
SendInput {Left %envNameLength%}
SendInput {Left 7}
Return


; turn on ending character agai