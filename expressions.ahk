#Hotstring C o * R0

; \frac{}{}
; / {space} --> \frac{|}{}
; TODO: auto-make pre-filled fractions
::/ :: \frac{{}{}}{{}{}}{left 3}

; \sqrt{}
; sqrt {space} --> \sqrt{|}
::sq ::\sqrt{{}{}}{left 1}

; \text{}
; te {space} --> \text{|}
::te ::\text{{}{}}{left 1}

; \mathbf{}
; bf {space} --> \mathbf{|}
::bf ::\mathbf{{}{}}{left 1}

; \mathbb{}
; bb {space} --> \mathbb{|}
::bb ::\mathbb{{}{}}{left 1}


; currentUnderscore := False

; ^a::
; RegExReplace(Haystack, NeedleRegEx [, Replacement = "", OutputVarCount = "", Limit = -1, StartingPos = 1])
; _::
; currentUnderscore := True
; Return

; Tab::
; if (currentUnderscore) {
;     currentUnderscore = False
;     RegExReplace(Haystack, NeedleRegEx [, Replacement = "", OutputVarCount = "", Limit = -1, StartingPos = 1])
; }