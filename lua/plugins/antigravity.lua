return {
  -- 1. Which-Key: 注册 <leader>a 分组名称
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>a", group = "ai/antigravity", mode = { "n", "v" } })
    end,
  },

  -- 2. Antigravity 集成：绑定悬浮终端、选区提问与智能磁盘同步
  {
    "folke/snacks.nvim",
    init = function()
      -- 开启自动重载
      vim.opt.autoread = true

      local group = vim.api.nvim_create_augroup("AntigravityAutoSync", { clear = true })

      -- 焦点回归、进入 Buffer、光标停顿时主动 checktime
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        group = group,
        pattern = "*",
        callback = function()
          if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
          end
        end,
      })

      -- 磁盘文件被外部修改时的安全处理
      vim.api.nvim_create_autocmd("FileChangedShell", {
        group = group,
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].modified then
            vim.notify(
              "⚠️ [Antigravity] 磁盘文件已被外部更新，但当前 Buffer 有未保存的改动，已阻止自动覆盖！",
              vim.log.levels.WARN,
              { title = "文件冲突提醒" }
            )
            vim.v.fcs_choice = "ask"
          else
            vim.v.fcs_choice = "reload"
          end
        end,
      })
    end,
    keys = {
      -- <leader>as: 一键在屏幕右侧呼出/收起 Antigravity 侧栏对话
      -- 智能适配：若右侧存在 Lean 4 Infoview（证明状态），则与 Infoview 上下 50/50 均分右侧栏；
      --          若无 Lean Infoview，则作为标准独立右侧边栏（40% 宽度）
      {
        "<leader>as",
        function()
          local cmd = "agy -c --dangerously-skip-permissions"

          -- 查找当前标签页中是否存在 Lean Infoview (filetype = leaninfo)
          local function find_leaninfo_win()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "leaninfo" then
                  return win
                end
              end
            end
            return nil
          end

          local info_win = find_leaninfo_win()

          -- 如果当前在 Lean 文件中但 Infoview 尚未开启，优先开启 Infoview 形成右侧工作台
          if not info_win and vim.bo.filetype == "lean" then
            pcall(function()
              require("lean.infoview").open()
            end)
            info_win = find_leaninfo_win()
          end

          -- 动态构造窗口停靠配置
          local win_config = {}
          if info_win and vim.api.nvim_win_is_valid(info_win) then
            win_config = {
              win = info_win,
              relative = "win",
              position = "bottom",
              height = 0.5,
              wo = {
                winbar = " Antigravity CLI ",
              },
            }
          else
            win_config = {
              position = "right",
              width = 0.40,
              border = "left",
              wo = {
                winbar = " Antigravity CLI ",
              },
            }
          end

          -- 获取或创建终端实例
          local term, created = Snacks.terminal.get(cmd, {
            create = true,
            win = win_config,
          })

          local function balance_heights()
            if info_win and vim.api.nvim_win_is_valid(info_win) and term:win_valid() then
              local total = vim.api.nvim_win_get_height(info_win) + vim.api.nvim_win_get_height(term.win)
              local half = math.floor(total / 2)
              vim.api.nvim_win_set_height(info_win, half)
              vim.api.nvim_win_set_height(term.win, total - half)
            end
          end

          if created then
            vim.schedule(balance_heights)
            return
          end

          -- 已有终端实例：如果可见则隐藏，如果隐藏则根据最新状态重新停靠并显示
          if term:win_valid() then
            term:hide()
          else
            term.opts.win = win_config.win
            term.opts.relative = win_config.relative
            term.opts.position = win_config.position
            term.opts.height = win_config.height
            term.opts.width = win_config.width
            term.opts.border = win_config.border
            term.opts.wo = term.opts.wo or {}
            term.opts.wo.winbar = win_config.wo.winbar
            term:show()
            vim.schedule(balance_heights)
          end
        end,
        desc = "Toggle Antigravity Sidebar (50/50 with Lean Infoview)",
        mode = { "n", "t" },
      },
      -- <leader>ag: 一键唤起/隐藏 Antigravity CLI 悬浮终端（居中大弹窗）
      {
        "<leader>ag",
        function()
          Snacks.terminal.toggle("agy -c --dangerously-skip-permissions", {
            win = {
              position = "float",
              border = "rounded",
              width = 0.88,
              height = 0.88,
              title = " Antigravity CLI ",
              title_pos = "center",
            },
          })
        end,
        desc = "Toggle Antigravity Float Window",
        mode = { "n", "t" },
      },
      -- <leader>ai: 在 Visual 模式下选中代码，弹出输入框提问，并在底部打开 agy -p 分屏
      {
        "<leader>ai",
        function()
          -- 保证选区位置获取准确
          local vstart = vim.fn.getpos("'<")
          local vend = vim.fn.getpos("'>")
          local start_line, end_line = vstart[2], vend[2]
          if start_line > end_line then
            start_line, end_line = end_line, start_line
          end

          local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
          local code = table.concat(lines, "\n")
          if code:match("^%s*$") then
            vim.notify("选区为空，请先在 Visual 模式下选择有效代码片段", vim.log.levels.WARN)
            return
          end

          local filetype = vim.bo.filetype
          local filename = vim.fn.expand("%:t")

          vim.ui.input({
            prompt = "提问 Antigravity CLI: ",
            default = "审查并解释这段代码：",
          }, function(input)
            if not input or input:match("^%s*$") then
              return
            end

            local formatted_prompt = string.format(
              "%s\n\n文件: %s (%s)\n```%s\n%s\n```",
              input,
              filename,
              filetype,
              filetype,
              code
            )

            local tmpfile = vim.fn.tempname() .. ".txt"
            local f = io.open(tmpfile, "w")
            if f then
              f:write(formatted_prompt)
              f:close()
            end

            local cmd = string.format("agy -p \"$(cat '%s')\"; rm -f '%s'", tmpfile, tmpfile)
            Snacks.terminal.open(cmd, {
              win = {
                position = "bottom",
                height = 0.45,
                title = " Antigravity Review ",
                title_pos = "center",
              },
            })
          end)
        end,
        desc = "Ask Antigravity on Selection",
        mode = "v",
      },
    },
  },
}
