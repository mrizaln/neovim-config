local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.astyle,                 -- C/C++/C#/Java
        null_ls.builtins.formatting.autoflake,              -- python
        null_ls.builtins.formatting.black,                  -- python
        null_ls.builtins.formatting.clang_format,           -- C/C++/Java/Cuda
        null_ls.builtins.formatting.codespell,              -- general; fix common misspelling
        null_ls.builtins.formatting.eslint_d,               -- js/ts
        null_ls.builtins.formatting.lua_format,             -- lua
        null_ls.builtins.formatting.rustfmt,                -- rust
        null_ls.builtins.formatting.standardts,             -- ts
    }
})
