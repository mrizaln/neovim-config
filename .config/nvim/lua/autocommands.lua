-----------------------------[ autocommands ]-----------------------------------
--
-- filter undoes from TextChanged event
vim.cmd([[
    function RunNotUndoElse(run, else_run)
        let undotree = undotree()
        if undotree.seq_cur is# undotree.seq_last
            " no undos
            echo a:run()
            return
        endif

        " undo
        if !empty(a:else_run)
            execute a:else_run
        endif
    endfunction
]])

--
-- filetype specific
vim.cmd([[
    " turn on spell check on markdown files (for English and Indonesian)
    autocmd FileType markdown setlocal spelllang=en_us,id spell tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType markdown autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | call RunNotUndoElse(function('MyFormatWrite'), ':write') | endif

    " set scrolloff to 0 for floaterm
    autocmd FileType floaterm,Trouble setlocal scrolloff=1

    " autosaves on rust file on file change (to trigger rust_analyzer)
    augroup autosave
        autocmd!
        autocmd FileType rust autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
    augroup END
]])

--
-- ignore capital letters misspelling
vim.cmd([[
    fun! IgnoreCamelCaseSpell()
        syn match myExCapitalWords +\<\w*[A-Z]\K*\>+ contains=@NoSpell
    endfun

    autocmd FileType !markdown BufRead,BufNewFile * :call IgnoreCamelCaseSpell()
]])

--
-- jumps to the last position upon reopening a file
--
vim.cmd([[
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
    endif
]])

--
-- highlight yanked text for 200ms using the "Visual" highlight group
--
vim.cmd([[
    augroup highlight_yank
        autocmd!
            au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    augroup END
]])

--
-- keep cursor at `scrolloff` distance from end of window
--
vim.cmd([[
    augroup KeepFromBottom
        autocmd!
        autocmd CursorMoved * call AvoidBottom()
        autocmd TextChanged * call AvoidBottom()
        autocmd TextChangedI * call AvoidBottom()
    augroup END

    function AvoidBottom()
        let distance_from_window_end = winheight(0) - winline()
        let lines_below_scrolloff = distance_from_window_end - &scrolloff
        let distance_to_eof = line('$') - line('.')

        let below_scrolloff = lines_below_scrolloff < 0
        let center_instead = winheight(0)/2 <= &scrolloff
        let near_eof = distance_to_eof < &scrolloff && distance_to_eof < winheight(0)/2
        let at_eol = getcursorcharpos()[2] > len(getline('.'))

        " if cursor is below scrolloff distance from bottom of window and near eof, scroll the buffer up that number of lines
        if below_scrolloff && near_eof
            if center_instead
                execute 'normal! zz'
                " echo "center"
            else
                let n = -lines_below_scrolloff
                execute 'normal! ' . n . "\<C-E>"
                " echo "scroll: ".n
            endif

            " Fix position of cursor at end of line
            if at_eol
                let cursor_pos = getcursorcharpos()
                let cursor_pos[2] = cursor_pos[2] + 1
                call setcursorcharpos(cursor_pos[1:])
            endif
        else
            " echo "not triggered: ".distance_to_eof
        endif
    endfunction
]])

--
-- keep cursor centered
--
-- vim.cmd([[
-- augroup KeepCentered
--   autocmd!
--   autocmd CursorMoved * normal! zz
--   autocmd TextChangedI * call InsertRecenter()
-- augroup END

-- function InsertRecenter() abort
--   let at_end = getcursorcharpos()[2] > len(getline('.'))
--   normal! zz

--   " Fix position of cursor at end of line
--   if at_end
--     let cursor_pos = getcursorcharpos()
--     let cursor_pos[2] = cursor_pos[2] + 1
--     call setcursorcharpos(cursor_pos[1:])
--   endif
-- endfunction
-- ]])
