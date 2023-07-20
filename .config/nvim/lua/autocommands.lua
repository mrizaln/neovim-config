-----------------------------[ autocommands ]-----------------------------------

--
------------[ detach lsp on file that not match list of filetype ]--------------
--
-- vim.api.nvim_create_augroup("BufReadCheckLspDetach", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufRead" }, {
-- 	callback = function()
-- 		for _, client in pairs(vim.lsp.get_active_clients({ buffer = 0 })) do
-- 			print("on_attach client: " .. client.name)
-- 			local filetype = vim.api.nvim_buf_get_option(0, "filetype")
-- 			local shouldAttach = _G.myUtils.isInTable(filetype, client.config.filetypes)
-- 			-- or _G.myUtils.isInTable(filetype, additional)

-- 			if not shouldAttach then
-- 				vim.lsp.buf_detach_client(vim.api.nvim_get_current_buf(), client.id)
-- 				print("detaching client: " .. client.name)
-- 			end
-- 		end

-- 		-- no lsp support; match current word instead
-- 		vim.cmd([[call matchadd('LspReferenceText', expand('<cword>'), -1)]])
-- 	end,
-- 	pattern = "*",
-- 	group = "BufReadCheckLspDetach",
-- 	desc = "Detach LSP on buf not in client.config.filetypes",
-- })
--------------------------------------------------------------

--
--------------------[ highlight variables ]-------------------
--
-- vim.cmd([[
--     function DocumentHighlightCustom()
--         " let has_lsp_client = luaeval(vim.lsp.get_active_clients ~= nil)
--         " if !has_lsp_client
--         "     return
--         " endif

--         " let can_highlight = luaeval('vim.lsp.get_active_clients()[1].server_capabilities.documentHighlightProvider')
--         " if can_highlight
--         "     lua vim.lsp.buf.document_highlight()
--         " endif

--         lua for _, client in pairs(vim.lsp.get_active_clients()) do if client.server_capabilities.documentHighlightProvider then vim.lsp.buf.document_highlight() end end
--     endfunction

--     augroup VariableReferencesHighlight
--         autocmd!
--         autocmd CursorHold  * call DocumentHighlightCustom()
--         autocmd CursorHoldI * call DocumentHighlightCustom()
--         autocmd CursorMoved * lua vim.lsp.buf.clear_references()
--     augroup END
-- ]])

vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	callback = function()
		for _, client in pairs(vim.lsp.get_active_clients({ buffer = 0 })) do
			if client.name == "copilot" then
				goto continue
			end
			-- there is lsp support
			if client.server_capabilities.documentHighlightProvider then
				if pcall(vim.lsp.buf.document_highlight) then
				else
					print("hi")
				end
				return
			end
			::continue::
		end

		-- no lsp support; match current word instead
		vim.cmd([[call matchadd('LspReferenceText', expand('<cword>'), -1)]])
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

    " autosaves on rust file on file change (to trigger rust_analyzer)
    augroup AutoSaves
        autocmd!
        " auto saves only "
        autocmd FileType rust autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
        " auto saves but run formatter first"
        autocmd FileType markdown,cpp autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | call RunNotUndoElse('MyFormatWrite', ':write') | endif
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
