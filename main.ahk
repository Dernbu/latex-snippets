; AHK V2
#Include InputWrapper.ahk

; TODO: hotstring priority (DONE)
; TODO: option to customise hotstrings: detectionStr, captureFunction, replacementStr
; TODO: \frac{}{}
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



/*
    All greek symbols  - shortcut by their first two characters al or \al => alpha.
    Only exceptions are :
        \beta - be clashes with the word be, and so beta is the shortcut instead.
        two-letter greek words, cause \mu => \mu as a hotstring is dumb
*/
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?al$","%$1%\alpha")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?be$","%$1%\beta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ga$","%$1%\gamma")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?De$","%$1%\Delta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?de$","%$1%\delta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ep$","%$1%\epsilon")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ze$","%$1%\zeta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?et$","%$1%\eta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?Th$","%$1%\Theta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?th$","%$1%\theta")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?io$","%$1%\iota")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ka$","%$1%\kappa")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?La$","%$1%\Lambda")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?la$","%$1%\lambda")
hotStrings.addHotString("mu", "\mu") ; Obviously, \mu => \mu is a shitty hotstring
hotStrings.addHotString("nu", "\nu")
hotStrings.addHotString("Xi", "\Xi")
hotStrings.addHotString("xi", "\xi")
hotStrings.addHotString("Pi", "\Pi")
hotStrings.addHotString("pi", "\pi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?Si$", "%$1%\Sigma")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?si$", "%$1%\sigma")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ta$", "%$1%\tau")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?Ph$", "%$1%\Phi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ph$", "%$1%\phi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ch$", "%$1%\chi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?Ps$", "%$1%\Psi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?ps$", "%$1%\psi")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?Om$", "%$1%\Omega")
hotStrings.addRegexHotString("([^a-zA-Z0-9_]?)\\?om$", "%$1%\omega")