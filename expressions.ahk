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