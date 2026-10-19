return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        -- 关闭大标题整行实色背景色块，保留标题图标与彩色加粗字体，完美配合透明毛玻璃
        backgrounds = {},
      },
      code = {
        -- 关闭代码块整块实色背景底色，消除实色方块
        disable_background = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
    end,
  },
}
