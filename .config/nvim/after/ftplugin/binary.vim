" see h: text-editing

" vim -b : edit binary using xxd-format!
augroup Binary
    au!
    au BufReadPre   *.bin,*.dat let &bin=1
    au BufReadPost  *.bin,*.dat if &bin | %!xxd
    au BufReadPost  *.bin,*.dat set ft=xxd | endif
    au BufWritePre  *.bin,*.dat if &bin | %!xxd -r
    au BufWritePre  *.bin,*.dat endif
    au BufWritePost *.bin,*.dat if &bin | %!xxd
    au BufWritePost *.bin,*.dat set nomod | endif
augroup END
