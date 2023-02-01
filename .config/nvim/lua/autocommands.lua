------------[ autocommands ]------------
-- jumps to the last position upon reopening a file
vim.cmd([[
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
    endif
]])
