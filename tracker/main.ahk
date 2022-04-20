#Include InputWrapper.ahk

hotStrings := InputWrapper()
hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.(?:hat|aht|ath)$", "\hat{%$1%}") ; x.hat, x.aht, x.ath => \hat{x}
hotStrings.addRegexHotString("([a-zA-Z0-9_]*)\.bar$", "\overline{%$1%}") ; x.bar => \overline{x}
hotStrings.addRegexHotString("([\^_])([a-zA-Z0-9]+)$", "%$1%{%$2%}") ; x_bar, x^hat => x_{bar}, x^{hat}
hotStrings.addHotString("pm", "\pm") ; pm => \pm
hotStrings.addHotString("mp", "\mp") ; mp => \mp
hotStrings.addHotString("mp", "\mp") ; mp => \mp