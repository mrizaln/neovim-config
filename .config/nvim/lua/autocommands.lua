-----------------------------[ autocommands ]-----------------------------------

--
---------------[ highlight variables (or word) ]--------------
--
-- ref: https://sbulav.github.io/til/til-neovim-highlight-references/
--
vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	callback = function()
		-- ignore if current buffer is not a file
		if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
			return
		end

		local current_bufnr = vim.api.nvim_get_current_buf()

		-- for some reason, this function returns all active clients regardless of the buffer being provided as argument
		local active_clients = vim.lsp.get_active_clients({ buffer = current_bufnr })

		for _, client in pairs(active_clients) do
			if client.server_capabilities.documentHighlightProvider then
				local bufnrs = vim.lsp.get_buffers_by_client_id(client.id)
				if vim.tbl_contains(bufnrs, current_bufnr) then
					vim.lsp.buf.document_highlight()
					return
				end
			end
		end

		-- no lsp support; match current word instead
		vim.cmd([[call matchadd('LspReferenceText', '\<' . expand('<cword>') . '\>', -1)]])
	end,
	pattern = "*",
	group = "LspDocumentHighlight",
	desc = "Document Highlight",
})
vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		vim.lsp.buf.clear_references()
		vim.cmd([[call clearmatches()]]) -- clear word matches
	end,
	pattern = "*",
	group = "LspDocumentHighlight",
	desc = "Clear All the References",
})
--------------------------------------------------------------

--
-----[ set filetype to conf for file with .conf extension]----
--
-- vim.cmd([[autocmd BufRead,BufNewFile *.conf setfiletype conf]])
--------------------------------------------------------------

--
-----------------[ filetype specific commands ]---------------
--
vim.cmd([[
    " filter undoes from TextChanged event "
    function RunNotUndoElse(run, else_run)
        let undotree = undotree()
        if undotree.seq_cur is# undotree.seq_last
            " no undoes
            execute "call " . a:run . "()"
            return
        endif

        " undo
        if !empty(a:else_run)
            execute a:else_run
        endif
    endfunction

    " auto saves

    " turn on spell check on markdown files (for English and Indonesian)
    autocmd FileType markdown setlocal spelllang=en_us,id spell tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    " set scrolloff to 0 for floaterm
    autocmd FileType floaterm,Trouble,NvimTree setlocal scrolloff=0

    " autosaves on selected filetypes on file change
    augroup AutoSaves
        autocmd!
        " auto saves only for rust files (to trigger rust_analyzer)"
        autocmd FileType rust autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
        " auto saves and format but run the formatter first"
        autocmd FileType markdown,cpp,glsl autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | call RunNotUndoElse('MyFormatWrite', ':write') | endif
    augroup END

    " conanfile.txt
    autocmd BufNewFile,BufRead conanfile.txt setlocal filetype=ini
]])
--------------------------------------------------------------

--
------------[ ignore capital letters misspelling ]------------
vim.cmd([[
    fun! IgnoreCamelCaseSpell()
        syn match myExCapitalWords +\<\w*[A-Z]\K*\>+ contains=@NoSpell
    endfun

    augroup IgnoreCamelCaseSpellAutocmd
        autocmd!
        autocmd FileType !markdown BufRead,BufNewFile * :call IgnoreCamelCaseSpell()
    augroup END
]])
--------------------------------------------------------------

--
-----[ jumps to the last position upon reopening a file ]-----
--
vim.cmd([[
    augroup JumpToLastPositionOnBufRead
        autocmd!
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
    augroup END
]])
--------------------------------------------------------------

--
--[ highlight yanked text for 200ms using the "Visual" highlight group ]--
--
vim.cmd([[
    augroup HighlightYank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=400})
    augroup END
]])
--------------------------------------------------------------

--
--[ keep cursor at `scrolloff` distance from end of window ]--
--
vim.cmd([[
    augroup KeepFromBottom
        autocmd!
        autocmd CursorMoved * call AvoidBottom()
        autocmd TextChanged * call AvoidBottom()
        autocmd TextChangedI * call AvoidBottom()
    augroup END

    function AvoidBottom()
        if &ft == 'floaterm' || &ft == 'NvimTree' || &ft == 'Trouble' || &ft == 'qf'
            return
        endif

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
--------------------------------------------------------------
