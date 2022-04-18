#Hotstring C o * R0

; \frac{}{}
; / {space} --> \frac{|}{}
; TODO: auto-make pre-filled fractions
::/ :: \frac{{}{}}{{}{}}{left 3}

; \sqrt{}
; sq {space} --> \sqrt{|}
; sqrt {space} --> \sqrt{|}
::sq ::\sqrt{{}{}}{left 1}
::sqrt ::\sqrt{{}{}}{left 1}

; \text{}
; te {space} --> \text{|}
::te ::\text{{}{}}{left 1}

; \mathbf{}
; bf {space} --> \mathbf{|}
::bf ::\mathbf{{}{}}{left 1}

; \mathbb{}
; bb {space} --> \mathbb{|}
::bb ::\mathbb{{}{}}{left 1}

; \pm \mp
::pm ::\pm
::mp ::\mp

/*
    superscript, subscript
*/
; subscript
+-::
SendInput, {Text}_
; begin capturing input for subscript
; visual mode --> can see your input 
Input, inputStr, V, {Esc} {Space} {Tab} {Enter}

; go to start of subscript and put a {
StringLen, inputStrLen, inputStr
SendInput, {Left %inputStrLen%}{Left 1}{{}

; go to end of subscript and put }
SendInput, {Right %inputStrLen%}{}}{Delete}
Return

;superscript
+6::
SendInput, {Text}^
; begin capturing input for subscript
; visual mode --> can see your input 
Input, inputStr, V, {Esc} {Space} {Tab} {Enter}

; go to start of subscript and put a {
StringLen, inputStrLen, inputStr
SendInput, {Left %inputStrLen%}{Left 1}{{}

; go to end of subscript and put }
SendInput, {Right %inputStrLen%}{}}{Delete}
Return