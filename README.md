# cmp-skkeleton

nvim-cmpのskkeletonソースです。

# Requirements

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [skkeleton](https://github.com/vim-skk/skkeleton)

# Usage

skkeleton本体が対応しているので、eggLikeNewlineを設定していれば通常の`<CR>`（`cmp.confirm({ select = true })`）は動作します。

```lua
require("cmp").setup({
  ...
  sources = {
    ...
    { name = "skkeleton" },
  }
})
```

# Related project

- [rinx/cmp-skkeleton](https://github.com/rinx/cmp-skkeleton)
