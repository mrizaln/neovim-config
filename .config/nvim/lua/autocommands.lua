------------[ autocommands ]------------
-- jumps to the last position upon reopening a file
vim.cmd([[
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
    endif
]])

--
-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
    augroup highlight_yank
        autocmd!
            au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    augroup END
]])

--
-- autosaves on rust file on file change (to trigger rust_analyzer)
vim.cmd([[
    augroup autosave_rust
        autocmd!
        autocmd FileType rust autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
    augroup END
]])

--
-- set different tabstop size for md file
vim.cmd([[
    autocmd FileType markdown setlocal tabstop=2 softtabstop=2
]])

--
-- turn on spell check on markdown files (for English and Indonesian)
vim.cmd([[
    autocmd FileType markdown setlocal spelllang=en_us,id spell
]])

--
-- keep cursor at `scrolloff` distance from end of window
vim.cmd([[
augroup KeepFromBottom
    autocmd!
    autocmd CursorMoved * call AvoidBottom()
    autocmd TextChangedI * call AvoidBottom()
augroup END

function AvoidBottom()
    let distance_from_end = winheight(0) - winline()
    let lines_below_scrolloff = distance_from_end - &scrolloff

    " if cursor is below scrolloff distance from bottom of window, scroll buffer up that number of lines
    if lines_below_scrolloff < 0
        normal! 5<C-E>
        let n = -lines_below_scrolloff
        execute 'normal! ' . n . "\<C-E>"
    endif
endfunction
]])
