------------[ autocommands ]------------
-- jumps to the last position upon reopening a file
vim.cmd([[
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
    endif
]])

local enable_auto_format = false
local exist, _ = pcall(require, "formatter")
-- format after save
if exist and enable_auto_format then
	vim.cmd([[
        augroup FormatAutogroup
            autocmd!
            autocmd BufWritePost * FormatWrite
        augroup END
    ]])
end

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
    augroup highlight_yank
        autocmd!
            au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    augroup END
]])
