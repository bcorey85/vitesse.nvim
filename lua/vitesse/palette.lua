-- Semantic palette, ported verbatim from antfu's Vitesse
-- (github.com/antfu/vscode-theme-vitesse, scripts/colors.ts). Each entry is
-- { dark, light }. resolve() picks a side, applies the soft/black variant
-- overrides, and flattens any #rrggbbaa over the background so every value
-- handed to nvim_set_hl is opaque #rrggbb.

local M = {}

-- { dark, light }
local raw = {
  primary = { "#4d9375", "#1c6b48" },

  fg = { "#dbd7caee", "#393a34" },
  fg_active = { "#bfbaaa", "#4e4f47" },
  fg_dim = { "#dedcd590", "#393a3490" },
  ignored = { "#dedcd550", "#393a3450" },
  faded = { "#dedcd510", "#393a3410" },
  border = { "#191919", "#f0f0f0" },

  bg = { "#121212", "#ffffff" },
  bg_active = { "#181818", "#f7f7f7" },
  selection = { "#eeeeee18", "#22222218" },

  comment = { "#758575dd", "#a0ada0" },
  string = { "#c98a7d", "#b56959" },
  variable = { "#bd976a", "#b07d48" },
  keyword = { "#4d9375", "#1e754f" },
  number = { "#4C9A91", "#2f798a" },
  boolean = { "#4d9375", "#1e754f" },
  operator = { "#cb7676", "#ab5959" },
  ["function"] = { "#80a665", "#59873a" },
  constant = { "#c99076", "#a65e2b" },
  class = { "#6872ab", "#5a6aa6" },
  interface = { "#5d99a9", "#2e808f" },
  type = { "#5DA994", "#2e8f82" },
  builtin = { "#cb7676", "#ab5959" },
  property = { "#b8a965", "#998418" },
  namespace = { "#db889a", "#b05a78" },
  punctuation = { "#666666", "#999999" },
  decorator = { "#bd8f8f", "#bd8f8f" },
  regex = { "#c4704f", "#ab5e3f" },

  green = { "#4d9375", "#1e754f" },
  cyan = { "#5eaab5", "#2993a3" },
  blue = { "#6394bf", "#296aa3" },
  red = { "#cb7676", "#ab5959" },
  orange = { "#d4976c", "#a65e2b" },
  yellow = { "#e6cc77", "#bda437" },
  magenta = { "#d9739f", "#a13865" },

  -- primer shades used by a few faithful scopes
  diff_range = { "#5a32a3", "#6f42c1" }, -- purple[6] / purple[5]
  invalid = { "#b31d28", "#b31d28" }, -- red[7]
}

-- flatten #rrggbb / #rrggbbaa over an opaque #rrggbb background
local function flatten(hex, bg)
  if #hex == 7 then
    return hex
  end
  local fr, fg, fb, fa = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16),
    tonumber(hex:sub(6, 7), 16), tonumber(hex:sub(8, 9), 16)
  local a = fa / 255
  local br, bgc, bb = tonumber(bg:sub(2, 3), 16), tonumber(bg:sub(4, 5), 16), tonumber(bg:sub(6, 7), 16)
  local function mix(f, b)
    return math.floor(f * a + b * (1 - a) + 0.5)
  end
  return string.format("#%02x%02x%02x", mix(fr, br), mix(fg, bgc), mix(fb, bb))
end

-- Resolve the palette for a config. opts: { style, transparent }.
-- style: nil follows vim.o.background; else one of
-- dark | light | dark-soft | light-soft | black.
function M.resolve(opts)
  opts = opts or {}
  local style = opts.style
  local bg_name, soft, black
  if style == "black" then
    bg_name, soft, black = "dark", false, true
  elseif style == "dark-soft" then
    bg_name, soft = "dark", true
  elseif style == "light-soft" then
    bg_name, soft = "light", true
  elseif style == "dark" or style == "light" then
    bg_name = style
  else
    bg_name = vim.o.background == "light" and "light" or "dark"
  end

  local i = bg_name == "light" and 2 or 1
  local p = { style = bg_name, is_light = bg_name == "light" }
  for k, pair in pairs(raw) do
    p[k] = pair[i]
  end

  -- variant background overrides
  if soft then
    p.bg = i == 1 and "#222222" or "#F1F0E9"
    p.bg_active = i == 1 and "#292929" or "#E7E5DB"
    p.border = i == 1 and "#252525" or "#E7E5DB"
  elseif black then
    p.bg = "#000000"
    p.bg_active = "#121212"
    p.fg = "#dbd7cacc"
    p.punctuation = "#444444"
  end

  -- flatten every alpha value over the resolved background
  for k, v in pairs(p) do
    if type(v) == "string" and v:sub(1, 1) == "#" then
      p[k] = flatten(v, p.bg)
    end
  end

  -- derived opaque surfaces for UI groups that VSCode does with runtime alpha
  p.visual = flatten(i == 1 and "#eeeeee22" or "#22222218", p.bg)
  p.pmenu_sel = flatten(i == 1 and "#eeeeee2a" or "#22222226", p.bg)
  p.match_paren = flatten(i == 1 and "#4d937540" or "#1c6b4830", p.bg)
  p.diff_add = flatten(i == 1 and "#4d937530" or "#1c6b4826", p.bg)
  p.diff_delete = flatten(i == 1 and "#ab595930" or "#ab595922", p.bg)
  p.diff_change = flatten(i == 1 and "#6394bf26" or "#296aa31c", p.bg)
  p.diff_text = flatten(i == 1 and "#6394bf40" or "#296aa330", p.bg)
  p.search = flatten(i == 1 and "#e6cc7744" or "#e6cc7788", p.bg)
  p.search_cur = flatten(i == 1 and "#e6cc7766" or "#e6cc77aa", p.bg)

  p.none = "NONE"
  if opts.transparent then
    p.bg = "NONE"
  end
  return p
end

return M
