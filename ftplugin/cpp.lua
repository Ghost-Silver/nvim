-- C/C++ 本地配置（仅对 cpp 缓冲区生效）
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.cindent = true

-- 在独立终端里运行二进制，跑完后停留等待回车，避免结果一闪而过
local function run_terminal(bin)
  local dir = vim.fn.expand("%:p:h")
  local keep = vim.fn.shellescape(bin)
    .. "\necho ''\necho '====== 程序已结束，按回车关闭此终端 ======'\nread _"
  -- auto_close=false：即使程序/包装 shell 退出，终端 pane 也不会自动关闭
  Snacks.terminal({ "sh", "-c", keep }, { cwd = dir, auto_close = false })
end

-- 编译当前文件，失败时输出进 quickfix（:copen 跳错误），成功可选择在终端运行
local function build(run, extra_flags)
  local file = vim.fn.expand("%:p")
  local bin = vim.fn.expand("%:p:r")
  local cmd = { "g++", "-std=c++17", "-O2", "-Wall", "-Wextra" }
  vim.list_extend(cmd, extra_flags or {})
  table.insert(cmd, file)
  table.insert(cmd, "-o")
  table.insert(cmd, bin)

  vim.notify("编译中… " .. vim.fn.fnamemodify(file, ":t"))
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code == 0 then
        vim.notify("编译成功 ✓ " .. vim.fn.fnamemodify(bin, ":t"))
        if run then
          run_terminal(bin)
        end
      else
        vim.notify("编译失败 ✗ 详见 quickfix", vim.log.levels.ERROR)
        vim.fn.setqflist({}, " ", {
          title = "C++ build: " .. vim.fn.fnamemodify(file, ":t"),
          lines = vim.split(res.stderr or "", "\n", { trimempty = true }),
        })
        vim.cmd("copen")
      end
    end)
  end)
end

vim.keymap.set("n", "<leader>cc", function()
  build(false)
end, { buffer = true, desc = "C++ 编译" })

vim.keymap.set("n", "<leader>cr", function()
  build(true)
end, { buffer = true, desc = "C++ 编译并运行" })

vim.keymap.set("n", "<leader>cC", function()
  build(true, { "-O0", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer" })
end, { buffer = true, desc = "C++ Sanitize 编译运行" })
