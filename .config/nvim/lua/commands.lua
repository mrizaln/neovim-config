----------------------------------[ commands ]----------------------------------
--

-- [ delete hidden buffers ]
-- source: https://stackoverflow.com/a/30101152
vim.cmd([[
    function! DeleteHiddenBuffers_func()
        let tpbl=[]
        let closed = 0
        call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
        for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
            if getbufvar(buf, '&mod') == 0
                silent execute 'bwipeout' buf
                let closed += 1
            endif
        endfor
        echo "Closed ".closed." hidden buffers"
    endfunction
]])

vim.api.nvim_create_user_command("DeleteHiddenBuffers", function()
	vim.cmd([[call DeleteHiddenBuffers_func()]])
end, { bang = true })

-- [ toggle background color to and from 'none' (original terminal color) ]
local configured_background = {
	normal = nil,
	normal_float = nil,
}
vim.api.nvim_create_user_command("ToggleBackground", function()
	if configured_background.normal == nil or configured_background.normal_float == nil then
		configured_background = {
			normal = vim.api.nvim_get_hl_by_name("Normal", true).background,
			normal_float = vim.api.nvim_get_hl_by_name("NormalFloat", true).background,
		}
	end

	local bg = vim.api.nvim_get_hl_by_name("Normal", true).background
	if bg == nil then
		vim.api.nvim_set_hl(0, "Normal", { bg = configured_background.normal })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = configured_background.normal_float })
	else
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end
end, {})

-- [ toggle navigation motion for long lines as separate lines (on wrapped lines) ]
local use_nav_long_lines = false -- by default, when wrapped, navigate long lines as separate lines
vim.api.nvim_create_user_command("ToggleNavLongLines", function()
	if use_nav_long_lines then
		vim.cmd([[
            nnoremap j gj
            nnoremap k gk
        ]])
	else
		vim.cmd([[
            nnoremap j j
            nnoremap k k
        ]])
	end
	use_nav_long_lines = not use_nav_long_lines
end, {})
