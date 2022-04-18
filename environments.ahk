#Hotstring C o * R0

; inline math mode
::mk ::$${left 1}
; This is specially set for Obsidian, since Enter causes problems in a bullet list.
; TODO: Figure out how to write newline (asc 010 or 013) directly without mapping to enter.
; ::dm ::+{Enter}$$+{Enter}+{Enter}$${Up 1}
; ::dm ::
; SendRaw `n
; SendInput $$
; SendRaw `n`n
; SendInput $$ {up 1}
; Return
; ::dm ::{U+000D}{U+000A}
; ::dm ::$$$${left 2}
; ::dm ::`r`n$$`r`n`r`n$${up 1}
::dm ::{Enter}$${Enter}{Enter}$${Left 3}
; ::dm ::`n$$`n`n$${up 1}
; ::dm ::{asc 013}$${asc 013}{asc 013}$${up 1}
; ::dm ::`r$$`r`r$${up 1}
; ::dm ::{asc 010}$${asc 010}{asc 010}$${up 1}


; align and align*
::ali ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
::align ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Left 12}
::ali* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}
::align* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Left 12}

; We replace enter with shift-enter for Obsidian.
; ::ali ::\begin{{}align{}}+{Enter}+{Enter}\end{{}align{}}{Up 1}
; ::align ::\begin{{}align{}}+{Enter}+{Enter}\end{{}align{}}{Up 1}
; ::ali* ::\begin{{}align*{}}+{Enter}+{Enter}\end{{}align*{}}{Up 1}
; ::align* ::\begin{{}align*{}}+{Enter}+{Enter}\end{{}align*{}}{Up 1}
