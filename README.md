# vitesse.nvim

A faithful Neovim port of [Anthony Fu's Vitesse](https://github.com/antfu/vscode-theme-vitesse) — the low-halation, desaturated theme, in **both dark and light**.

Pure Lua, no dependencies. Tree-sitter and LSP semantic tokens covered. The
palette is lifted verbatim from Vitesse's own `scripts/colors.ts`, and the
per-token color assignments mirror its `scripts/theme.ts`, so syntax reads the
same as it does in VS Code.

> Not affiliated with Anthony Fu. Colors © their author; this port is MIT.

## Install

lazy.nvim:

```lua
{ "bcorey85/vitesse.nvim", lazy = false, priority = 1000 }
```

## Use

```vim
colorscheme vitesse
```

`vitesse` follows `background` — `:set background=light` gives the light
variant, `dark` the dark one. No separate colorscheme names to juggle.

## Configure

`setup()` is optional; defaults shown:

```lua
require("vitesse").setup({
  transparent = false,      -- let the terminal background show through
  italic_comments = true,
  style = nil,              -- pin a variant, ignoring `background`:
                            -- dark | light | dark-soft | light-soft | black
  overrides = {},           -- e.g. { Comment = { fg = "#8a8778" } }
})
```

Call `setup()` before `colorscheme vitesse`.

## Variants

`dark`, `light`, and the `-soft` (warmer, lower-contrast backgrounds) and
`black` (pure `#000`) variants from upstream. Pick one via `style`, or let
`background` choose between plain dark and light.

## Credit

All color choices are Anthony Fu's. This repository only translates them into
Neovim highlight groups.
