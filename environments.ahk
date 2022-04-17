#Hotstring C o * R0

; inline math mode
::mk ::$${left 1}
::dm ::{Enter}$${Enter}{Enter}$${up 1}

; align and align*
::ali ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Up 1}
::align ::\begin{{}align{}}{Enter}{Enter}\end{{}align{}}{Up 1}
::ali* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Up 1}
::align* ::\begin{{}align*{}}{Enter}{Enter}\end{{}align*{}}{Up 1}
