# cmp-skkeleton

nvim-cmpのskkeletonソースです。

# Requirements

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [skkeleton](https://github.com/vim-skk/skkeleton)

# Usage

設定例です。

skkeleton本体が対応しているので、eggLikeNewlineを設定していれば通常の`<CR>`（`cmp.confirm({ select = true })`）は動作します。

細かな制御が必要な場合は、以下の方法を使ってください。

```vim
au User skkeleton-enable-post call s:skkeleton_post()
function! s:skkeleton_post() abort
  lunmap <buffer> <CR>
endfunction
```

```lua
local cmp = require("cmp")
cmp.setup({
    -- other settings
    mapping = {
        ["<CR>"] = cmp.mapping(function(callback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif vim.fn["skkeleton#mode"]() ~= "" then
                vim.fn["skkeleton#handle"]("handleKey", { key = "<CR>", ["function"] = "newline" })
            else
                callback()
            end
        end, { "i" }),
    },
    sources = cmp.config.sources({
        { name = "skkeleton" },
        -- other sources
    }),
})
```
