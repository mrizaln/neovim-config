-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- search related keymaps
do
  local search_s = [["sy:let @/= '\V' . escape(@s, '/\')<CR>:set hls<CR>]]
  local search_w = [["sy:let @/= '\V' . '\<' . escape(@s, '/\') . '\>'<CR>:set hls<CR>]]

  local function search_pattern(p, s)
    local function add_then_back(ss)
      local len = string.len(ss)
      local new_s = ss
      for _ = 1, len do
        new_s = new_s .. "<Left>"
      end
      return new_s
    end

    local prefix = p .. [[<esc>:%s/\V]]
    local suffix = add_then_back([[/g | noh | norm!``]])

    return prefix .. s .. suffix
  end

  local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
  end

  -- see: https://stackoverflow.com/a/49944815
  vim.keymap.set(
    "n",
    "*",
    [[:let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]],
    opts("override search without jump")
  )

  vim.keymap.set("v", "/", search_s, opts("search highlighted text"))
  vim.keymap.set("v", "?", search_w, opts("search highlighted text (whole)"))

  vim.keymap.set(
    "v",
    "\\r",
    search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>/]]),
    opts("replace currently highlighted text with new text")
  )

  vim.keymap.set(
    "v",
    "\\R",
    search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\>/]]),
    opts("replace currently highlighted text with new text (whole)")
  )

  vim.keymap.set(
    "v",
    "\\i",
    search_pattern(search_s, [[\ze<c-r>=escape(@s,'/\')<cr>/]]),
    opts("insert new text before currently highlighted text")
  )

  vim.keymap.set(
    "v",
    "\\I",
    search_pattern(search_w, [[\ze\<<c-r>=escape(@s,'/\')<cr>\>/]]),
    opts("insert new text after currently highlighted text (whole)")
  )

  vim.keymap.set(
    "v",
    "\\a",
    search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>\zs/]]),
    opts("append new text after currently highlighted text")
  )

  vim.keymap.set(
    "v",
    "\\A",
    search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\zs\>/]]),
    opts("append new text after currently highlighted text (whole word")
  )

  vim.keymap.set(
    "v",
    "\\e",
    search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>/<c-r>=escape(@s,'/\')<cr>]]),
    opts("edit currently highlighted text")
  )

  vim.keymap.set(
    "v",
    "\\E",
    search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\>/<c-r>=escape(@s,'/\')<cr>]]),
    opts("edit currently highlighted text (whole)")
  )
end
