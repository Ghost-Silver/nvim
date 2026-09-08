-- DAP 可视化调试：codelldb 调试器 + 一键编译并调试当前文件
return {
  -- 通过 mason 安装 codelldb（C/C++/Rust 的调试适配器）
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "codelldb" },
    },
  },

  -- 编译当前 C++ 文件（带调试符号）并直接用 codelldb 起调试会话
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dD",
        function()
          local file = vim.fn.expand("%:p")
          local bin = vim.fn.expand("%:p:r")
          local flags = { "-std=c++17", "-g", "-O0", "-Wall", "-Wextra" }
          local cmd = { "g++" }
          vim.list_extend(cmd, flags)
          table.insert(cmd, file)
          table.insert(cmd, "-o")
          table.insert(cmd, bin)

          vim.notify("编译调试目标… " .. vim.fn.fnamemodify(file, ":t"))
          vim.system(cmd, { text = true }, function(res)
            vim.schedule(function()
              if res.code ~= 0 then
                vim.notify("编译失败：修正后重试", vim.log.levels.ERROR)
                return
              end
              require("dap").run({
                name = "Debug " .. vim.fn.fnamemodify(bin, ":t"),
                type = "codelldb",
                request = "launch",
                program = bin,
                cwd = vim.fn.expand("%:p:h"),
                args = {},
                stopOnEntry = true,
              })
            end)
          end)
        end,
        desc = "编译并调试当前文件",
      },
    },
  },
}