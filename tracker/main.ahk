; AHK V2
#Include InputWrapper.ahk

/*
    Synatax:
    - regex is just regex
    - %$i% represents the ith capture group of the regex
    - %&i% makes the cursor jump to the marker (with the lowest i), deleting the marker
    - `r for newline
*/

hotStrings := InputWrapper()
hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.(?:hat|aht|ath)$", "\hat{%$1%}") ; x.hat, x.aht, x.ath => \hat{x}
hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.bar$", "\overline{%$1%}") ; x.bar => \overline{x}
hotStrings.addRegexHotString("([\^_])([a-zA-Z0-9]+)$", "%$1%{%$2%}") ; x_bar, x^hat => x_{bar}, x^{hat}
hotStrings.addHotString("pm", "\pm") ; pm => \pm
hotStrings.addHotString("mp", "\mp") ; mp => \mp
hotStrings.addHotString("mp", "\mp") ; mp => \mp
hotStrings.addHotString("sq", "\sqrt{%&0%}%&1%") ; sq => \sqrt{%&0%}%&1%
hotStrings.addHotString("sqrt", "\sqrt{%&0%}%&1%") ; sqrt => \sqrt{%&0%}%&1%
hotStrings.addHotString("mk", "$%&0%$%&1%") ; mk => inline math
hotStrings.addHotString("dm", "`r$$`r%&0%`r$$`r%&1%") ; dm => display math

; hotStrings.addRegexHotString("(ali\*?)$", "\begin{%$1%}`r%&0%`r\end{%$1%}`r%&1%") ; ali/ali* => \begin{align}/{align*}
hotStrings.addHotString("ali", "\begin{align}`r%&0%`r\end{align}`r%&1%")
hotStrings.addHotString("ali*", "\begin{align*}`r%&0%`r\end{align*}`r%&1%")
hotStrings.addHotString("te", "\text{%&0%}%&1%") ; te => \text{}
hotStrings.addHotString("bf", "\mathbf{%&0%}%&1%") ; bf => \mathbf{}
hotStrings.addHotString("bb", "\mathbb{%&0%}%&1%") ; bb => \mathbb{}

hotStrings.addHotString("beg", "\begin.%&0%") ; beg => \begin.<cursor>
hotStrings.addRegexHotString("\\begin\.([a-zA-Z0-9*]+)", "\begin{%$1%}`r%&0%`r\end{%$1%}`r%&1%") ; \begin.<input> -> environment

; TODO; make string to str converstion safe for special characters
