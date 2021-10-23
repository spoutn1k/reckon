if exists("b:current_syntax")
    finish
endif

syntax match bkdComment "^#.*$"
highlight link bkdComment Comment

syntax region blockLabel matchgroup=blockEntry start=/^/ end=/>----*/ oneline
highlight link blockLabel Function
highlight link blockEntry Identifier

syntax match blockEnd "-*---<"
highlight link blockEnd Identifier

syntax match Reckoning "TOTAL.*"
highlight link Reckoning StorageClass

let b:current_syntax = "bankdata"
