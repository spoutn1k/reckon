set foldmarker=>---,---<
set foldmethod=marker

function! Sum(number)
    let g:S = g:S + str2float(a:number)
    return a:number
endfunction

function GetLabel(line)
    let l:label=matchstr(a:line, ".*>")
    return substitute(l:label, "\\s>$", '', '')
endfunction

function Fold()
    let row_number=line('.')
    let line=getline('.')
    let g:S = 0

    execute "normal! zR"

    if match(line, ">-\\+$") > -1
        let l:label=GetLabel(line)
        execute "normal! j"
        call FoldOne_(l:label)
    endif

    execute "normal! " . row_number . "G"
endfunction

function SetOrUpdateTotal(label, total)
    let l:line=getline(line('.') + 1)
    if match(l:line, 'TOTAL .*') > -1
        execute "normal! j"
    else
        execute "normal! o"
    endif
    call setline('.', 'TOTAL ' . a:label . ': ' . a:total)
endfunction

function FoldOne_(label)
    let l:sum=0
    while 1
        let line=getline('.')
        let amount=matchstr(line, "-*\\d\\+\\.\\d\\+")

        if match(line, ">-\\+$") > -1
            " echom line "START" g:S
            let l:sum=g:S
            let g:S=0
            let l:sublabel=GetLabel(line)
            execute "normal! j"
            let g:S=l:sum + FoldOne_(l:sublabel)
        elseif match(line, "^-\\+<$") > -1
            " echom line "END" g:S
            let l:sum=g:S
            let g:S=0
            call SetOrUpdateTotal(a:label, l:sum)
            execute "normal! j"
            return l:sum
        elseif amount ==? "" || match(line, "^#") > -1
            " echom line "NOOP" g:S
            execute "normal! j"
        else
            call Sum(amount)
            " echom line "SUM" g:S
            execute "normal! j"
        endif
    endwhile
endfunction
