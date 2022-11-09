# cmp-skkeleton

nvim-cmpの[skkeleton](https://github.com/vim-skk/skkeleton)ソースです。

# Usage

設定例です。

skkeletonはlmapで`<CR>`を潰してしまうのでリリースし、cmp側のマッピング設定で対応します。

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
