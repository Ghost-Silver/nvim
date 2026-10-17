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
      color_overrides = {
        mocha = {
          -- 将原版暗淡发灰的淡粉红（#f38ba8）替换为高亮、清晰醒目的珊瑚亮红（#ff6578）
          red = "#ff6578",
        },
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

          -- 显著调亮注释高亮（原 overlay0 在毛玻璃/深色背景下过于昏暗）
          -- 使 Lean 4 中大量 Markdown 文档注释（/-! ... -/）及行注释（--）清晰易读
          Comment = { fg = colors.subtext1, italic = true },
          ["@comment"] = { fg = colors.subtext1, italic = true },
          ["@comment.documentation"] = { fg = colors.subtext1, italic = true },
          ["@lsp.type.comment"] = { fg = colors.subtext1, italic = true },
          ["@lsp.type.comment.lean"] = { fg = colors.subtext1, italic = true },
          leanComment = { fg = colors.subtext1, italic = true },
          leanBlockComment = { fg = colors.subtext1, italic = true },

          -- Lean 4 Infoview 证明目标：横 T 符号（⊢）及目标类型表达式加粗且完全无背景
          -- 将原先暗淡发红的 peach 改为高对比度、清晰明朗的 sky 天青蓝
          leanInfoGoalPrefix = { fg = colors.sky, bold = true, bg = "none" },
          leanInfoExpectedType = { fg = colors.lavender, bold = true, bg = "none" },
          leanInfoGoals = { fg = colors.text, bold = true, bg = "none" },
          leanInfoGoalInserted = { fg = colors.green, bold = true, bg = "none" },
          leanInfoGoalRemoved = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
          leanInfoHypNameInserted = { fg = colors.green, bold = true, bg = "none" },
          leanInfoHypNameRemoved = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
          leanInfoDiffwasInserted = { fg = colors.green, bold = true, bg = "none" },
          leanInfoDiffwillChange = { fg = colors.yellow, bold = true, bg = "none" },
          leanInfoDiffwasChanged = { fg = colors.blue, bold = true, bg = "none" },
          leanInfoDiffwasDeleted = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
          leanInfoDiffwillDelete = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
          leanInfoSelected = { bold = true, bg = "none", underline = true },
          widgetChangedText = { bold = true, bg = "none" },
          widgetElementHighlight = { bold = true, bg = "none" },

          -- 提升所有语法错误、波浪线、报错文字对比度（彻底解决原版红色在毛玻璃透视下发暗看不清的问题）
          DiagnosticError = { fg = "#ff6578", bold = true },
          DiagnosticUnderlineError = { sp = "#ff6578", undercurl = true },
          DiagnosticSignError = { fg = "#ff6578" },
          DiagnosticFloatingError = { fg = "#ff6578" },
          DiagnosticVirtualTextError = { fg = "#ff6578", bg = "none" },
          Error = { fg = "#ff6578", bold = true },
          ErrorMsg = { fg = "#ff6578", bold = true },
          SpellBad = { sp = "#ff6578", undercurl = true },

          -- Markdown 渲染插件 (render-markdown.nvim) 完全透明化（消除大块底色色块）
          RenderMarkdownH1Bg = { bg = "none" },
          RenderMarkdownH2Bg = { bg = "none" },
          RenderMarkdownH3Bg = { bg = "none" },
          RenderMarkdownH4Bg = { bg = "none" },
          RenderMarkdownH5Bg = { bg = "none" },
          RenderMarkdownH6Bg = { bg = "none" },

          -- Markdown 标题与排版色彩优化：彻底消除 Markdown 中的刺眼红色
          -- 1. H1 大标题：改为优雅醒目的薰衣草紫/蓝（Lavender），不再使用刺眼红色
          RenderMarkdownH1 = { fg = colors.lavender, bold = true, bg = "none" },
          ["@markup.heading.1"] = { fg = colors.lavender, bold = true, bg = "none" },
          ["@markup.heading.1.markdown"] = { fg = colors.lavender, bold = true, bg = "none" },

          -- 2. Markdown 加粗文本（**...**）：改为温润明朗的金黄色（Yellow），彻底消除原本类似报错的红色
          ["@markup.strong"] = { fg = colors.yellow, bold = true },
          ["@markup.strong.markdown_inline"] = { fg = colors.yellow, bold = true },
          markdownBold = { fg = colors.yellow, bold = true },
          Bold = { fg = colors.yellow, bold = true },

          -- 3. Markdown 斜体文本（*...*）：改为柔和清雅的火烈鸟粉（Flamingo），不再使用红色
          ["@markup.italic"] = { fg = colors.flamingo, italic = true },
          ["@markup.italic.markdown_inline"] = { fg = colors.flamingo, italic = true },
          markdownItalic = { fg = colors.flamingo, italic = true },
          Italic = { fg = colors.flamingo, italic = true },
          RenderMarkdownCode = { bg = "none" },
          RenderMarkdownCodeInline = { bg = "none" },
          RenderMarkdownCodeBorder = { bg = "none" },
          RenderMarkdownTableHead = { bg = "none" },
          RenderMarkdownTableRow = { bg = "none" },
          RenderMarkdownQuote = { bg = "none" },
          RenderMarkdownPadding = { bg = "none" },
          ColorColumn = { bg = "none" },
        }
      end,
    },
  },
}
