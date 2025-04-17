-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

--------------------------------------------------------------------------------
------------------------[ highlight variables (or word) ]-----------------------
--------------------------------------------------------------------------------
--
-- ref: https://sbulav.github.io/til/til-neovim-highlight-references/
--
vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    -- ignore if current buffer is not a file
    if vim.bo.filetype ~= "" then
      return
    end

    local current_bufnr = vim.api.nvim_get_current_buf()

    -- for some reason, this function returns all active clients regardless of the buffer being provided as argument
    local active_clients = vim.lsp.get_clients({ buffer = current_bufnr })

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
    vim.cmd([[
          let s = matchstr(getline('.'), '\%' . col('.') . 'c.')
          if s != '*'     "ignore special character
              call matchadd('LspReferenceText', '\<' . expand('<cword>') . '\>', -1)
          endif
        ]])
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
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-----------[ keep cursor at `scrolloff` distance from end of window ]-----------
--------------------------------------------------------------------------------
-- TODO: use lua
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
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
------------------[ disable <c-l> mapping on terminal open ]--------------------
--------------------------------------------------------------------------------
--  https://github.com/LazyVim/LazyVim/issues/4509]
vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ev)
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = ev.buf, nowait = true })
  end,
})
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-------------------[ disable autoformat for certan filetypes ]------------------
--------------------------------------------------------------------------------
local autoformat_enabled = { "c", "cpp", "glsl", "lua", "python", "rust" }

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    vim.b.autoformat = vim.tbl_contains(autoformat_enabled, vim.bo.filetype)
  end,
})
--------------------------------------------------------------------------------
