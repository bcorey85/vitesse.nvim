local M = {}

M.config = {
  transparent = false,
  italic_comments = true,
  -- style: nil follows vim.o.background; else dark | light | dark-soft |
  -- light-soft | black. When set, load() ignores background.
  style = nil,
  -- override or extend any highlight group: { Comment = { fg = "#..." } }
  overrides = {},
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- :terminal ANSI palette (from antfu's terminal.ansi* mapping)
local function terminal(p)
  local bright_black = p.is_light and "#aaaaaa" or "#777777"
  local white = "#dbd7ca"
  local bright_white = p.is_light and "#dddddd" or "#ffffff"
  local ansi_black = p.is_light and "#121212" or "#393a34"
  local g = vim.g
  g.terminal_color_0, g.terminal_color_8 = ansi_black, bright_black
  g.terminal_color_1, g.terminal_color_9 = p.red, p.red
  g.terminal_color_2, g.terminal_color_10 = p.green, p.green
  g.terminal_color_3, g.terminal_color_11 = p.yellow, p.yellow
  g.terminal_color_4, g.terminal_color_12 = p.blue, p.blue
  g.terminal_color_5, g.terminal_color_13 = p.magenta, p.magenta
  g.terminal_color_6, g.terminal_color_14 = p.cyan, p.cyan
  g.terminal_color_7, g.terminal_color_15 = white, bright_white
end

function M.load()
  local cfg = M.config
  local p = require("vitesse.palette").resolve(cfg)

  if vim.g.colors_name then
    vim.cmd.highlight("clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "vitesse"
  -- keep vim.o.background in sync so bg-reactive plugins agree
  vim.o.background = p.is_light and "light" or "dark"

  local groups = require("vitesse.theme").groups(p, cfg)
  if cfg.overrides then
    groups = vim.tbl_extend("force", groups, cfg.overrides)
  end
  local set = vim.api.nvim_set_hl
  for name, spec in pairs(groups) do
    set(0, name, spec)
  end

  terminal(p)
end

return M
