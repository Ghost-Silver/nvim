-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 窗口分屏更顺手
map("n", "<leader>w-", "<C-w>s", opts) -- 水平分屏（C-w s 的顺手指令）
map("n", "<leader>w|", "<C-w>v", opts) -- 垂直分屏
map("n", "<leader>wr", "<C-w>=", opts) -- 等分窗口尺寸
map("n", "<leader>w>", "<C-w>>", opts) -- 当前窗口加宽
map("n", "<leader>w<", "<C-w><", opts) -- 当前窗口变窄

-- 缓冲区的快捷操作
map("n", "[b", "<cmd>bprevious<cr>", opts) -- 上一个 buffer
map("n", "]b", "<cmd>bnext<cr>", opts) -- 下一个 buffer 文件
map("n", "<leader>bc", "<cmd>bd<cr>", opts) -- 关闭当前 buffer（保留窗口）
map("n", "<leader>bO", "<cmd>%bd|e#|bd#<cr>", opts) -- 关闭其它所有 buffer，保留当前

-- 快速插入日期
map("n", "<leader>td", function()
  local time = os.date("%Y-%m-%d")
  vim.api.nvim_put({ time }, "c", true, true)
end, opts)

-- Quickfix 上下条错误跳转
map("n", "[q", "<cmd>cprev<cr>", opts)
map("n", "]q", "<cmd>cnext<cr>", opts)
map("n", "<leader>cq", "<cmd>copen<cr>", opts) -- 打开 quickfix 窗口

-- 复制到系统剪贴板（macOS 专用）
map("n", "<leader>yc", function()
  vim.fn.setreg("+", vim.fn.getreg("*"))
  print("已复制到系统剪贴板")
end, opts)

-- 终端内快速退出到正常模式
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

-- 保留搜索高亮但有快捷清除
map("n", "<leader>nh", ":nohlsearch<cr>", opts) -- 清除搜索高亮

-- 整行上移 / 下移（普通 + 可视模式）
map("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
map("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)