return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      -- 必须 true：你 iTerm2 开了「Only The Default BG Color Uses Transparency」，
      -- 只有 bg=none 的区域才会透出毛玻璃
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      custom_highlights = function(colors)
        return {
          -- 状态栏 / 标签栏：必须清空背景，否则不透明
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          StatusLineTerm = { bg = "none" },
          StatusLineTermNC = { bg = "none" },
          TabLine = { bg = "none" },
          TabLineFill = { bg = "none" },
          TabLineSel = { bg = "none" },
          WinBar = { bg = "none" },
          WinBarNC = { bg = "none" },
          -- 浮窗类
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          FloatFooter = { bg = "none" },
          -- snacks
          SnacksNormal = { bg = "none" },
          SnacksNormalNC = { bg = "none" },
          SnacksWinBar = { bg = "none" },
          SnacksWinBarNC = { bg = "none" },
          SnacksTitle = { bg = "none" },
          SnacksFooter = { bg = "none" },
          SnacksWinSeparator = { bg = "none" },
          SnacksBackdrop = { bg = "none" },
          SnacksPicker = { bg = "none" },
          SnacksPickerBorder = { bg = "none" },
          SnacksPickerTitle = { bg = "none" },
          -- which-key
          WhichKey = { bg = "none" },
          WhichKeyFloat = { bg = "none" },
          WhichKeyBorder = { bg = "none" },
          -- 光标行也全透明（仅保留行号高亮来定位光标）
          CursorLine = { bg = "none" },
          CursorColumn = { bg = "none" },
          -- 选中区域保持实色，保证可读性
          Visual = { bg = colors.surface0 },
          VisualNOS = { bg = colors.surface0 },
        }
      end,
    },
  },
}
