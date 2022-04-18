;; subscript
; RegExHotstrings("_(.{0,})(\s)", "_{%$1%}%$2%")
RegExHotstrings("_([.\S]{0,})(\s)", "_{%$1%}")

;; auto_subscript a1 to a_1.
; from https://castel.dev/post/lecture-notes-1/#sub--and-superscripts
; RegExHotstrings("([A-Za-z])(\d)\s", "%$1%_{%$2%}")

;; superscript
; RegExHotstrings("\^(.{0,})(\s)", "^{%$1%}%$2%")
RegExHotstrings("\^([.\S]{0,})(\s)", "^{%$1%}")

; RegExHotstrings("\\begin-([a-zA-Z*]{1,})\s", "%$1%")