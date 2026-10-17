-- 确保 ~/.elan/bin 在 Neovim 运行时的 PATH 中（供 Lean LSP / lake serve 使用）
local elan_bin = vim.fn.expand("~/.elan/bin")
if vim.fn.isdirectory(elan_bin) == 1 and not string.find(vim.env.PATH, elan_bin, 1, true) then
  vim.env.PATH = elan_bin .. ":" .. vim.env.PATH
end

return {
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "andrewradev/switch.vim",
    },
    opts = {
      -- 快捷键支持（<LocalLeader>i 开关 Infoview，<LocalLeader>p 暂停，<LocalLeader>x 固定状态等）
      mappings = true,
      -- 交互式证明窗口（Infoview）配置
      infoview = {
        autoopen = true,
        width = 55,
      },
      -- 启用 Unicode 缩写补全（\to -> →, \forall -> ∀, \lambda -> λ 等）
      abbreviations = {
        enable = true,
      },
      lsp = {
        enable = true,
      },
      -- 禁用 Kitty 图形探测，彻底消除终端向输入流泄露探针乱码（如 =99999;OK）
      graphics = {
        enabled = false,
      },
    },
    config = function(_, opts)
      -- lean.nvim 现代版本通过 vim.g.lean_config 读取配置
      vim.g.lean_config = opts

      -- 确保 Lean Infoview 中待证目标（⊢ 及类型表达式）加粗、鲜亮且完全无背景
      local leaninfo_group = vim.api.nvim_create_augroup("LeanInfoCustomHighlight", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        group = leaninfo_group,
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].filetype == "leaninfo" then
            local colors = require("catppuccin.palettes").get_palette("mocha")
            local hls = {
              -- 待证目标符号（⊢）由暗淡的 peach 改为清晰明亮的 sky 天青蓝，极高对比度
              leanInfoGoalPrefix = { fg = colors.sky, bold = true, bg = "none" },
              leanInfoGoalInserted = { fg = colors.green, bold = true, bg = "none" },
              leanInfoGoalRemoved = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
              leanInfoHypNameInserted = { fg = colors.green, bold = true, bg = "none" },
              leanInfoHypNameRemoved = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
              leanInfoDiffwasInserted = { fg = colors.green, bold = true, bg = "none" },
              leanInfoDiffwillChange = { fg = colors.yellow, bold = true, bg = "none" },
              leanInfoDiffwasChanged = { fg = colors.blue, bold = true, bg = "none" },
              leanInfoDiffwasDeleted = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
              leanInfoDiffwillDelete = { fg = "#ff6578", bold = true, bg = "none", strikethrough = true },
              leanInfoSelected = { fg = colors.lavender, bold = true, bg = "none", underline = true },
              leanInfoExpectedType = { fg = colors.lavender, bold = true, bg = "none" },
              widgetChangedText = { bold = true, bg = "none" },
              widgetElementHighlight = { bold = true, bg = "none" },
            }
            for group, spec in pairs(hls) do
              vim.api.nvim_set_hl(0, group, spec)
            end
          end
        end,
      })

      -- 离开或关闭所有 Lean buffer 后，自动关闭当前 tab 的 Infoview 证明状态区域
      local function check_infoview_autoclose()
        vim.schedule(function()
          local has_lean = false
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "lean" then
                has_lean = true
                break
              end
            end
          end

          local ok, infoview = pcall(require, "lean.infoview")
          if not ok then return end

          local iv = infoview.get_current_infoview()
          if not has_lean then
            -- 当前 tab 已经没有窗口在展示 lean 文件，自动关闭证明状态栏
            if iv and iv.window then
              pcall(function() iv:close() end)
            end
          else
            -- 当前正在聚焦 lean buffer，如果之前被关掉了，自动重新打开
            if iv and not iv.window and vim.bo.filetype == "lean" then
              pcall(function() iv:open() end)
            end
          end
        end)
      end

      local infoview_autoclose_group = vim.api.nvim_create_augroup("LeanInfoviewAutoClose", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "BufDelete", "BufWipeout", "WinClosed" }, {
        group = infoview_autoclose_group,
        pattern = "*",
        callback = check_infoview_autoclose,
      })
    end,
  },
}
