return {
  "folke/snacks.nvim",
  opts = {
    explorer = {},
  },
  keys = {
    -- 覆盖默认的 root dir 模式，将 <leader>e 统一改为永远在启动目录（cwd）打开文件树
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
  },
}
