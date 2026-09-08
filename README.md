# GhostFace's Nvim 配置

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人配置。主题 **catppuccin-mocha**，全透明（配合 iTerm2 毛玻璃）。

## 前提

- Neovim ≥ 0.10
- iTerm2 中：Profiles → Window 里**取消勾选「Keep background colors opaque」**，并设好 Transparency + Blur
- 终端配色建议深色，才能透出好看的纱罩效果

## 首次使用

```bash
nvim    # 首次启动会自动安装所有插件
```

## 快捷键速查

> `<leader>` 默认是 `空格键`

### 通用

| 按键 | 说明 |
|---|---|
| `<leader>ff` | 查找文件（fd） |
| `<leader>fg` | 全局文本搜索（rg） |
| `<leader>fr` | 最近文件 |
| `<leader>e` | 打开侧边文件树（Snacks Explorer） |
| `<leader>u` | 撤销会话树 |
| `<Esc>` | 关闭当前高亮 / 浮窗 |

### C++ 竞赛（在 `.cpp` 文件内）

| 按键 | 说明 |
|---|---|
| `<leader>cc` | 编译（g++ -std=c++17 -O2 -Wall -Wextra，异步） |
| `<leader>cr` | 编译并运行（弹出交互式终端，可 `cin`） |
| `<leader>cC` | Sanitize 调试版编译运行（ASan + UBSan） |
| `st` + Tab | 插入代码骨架片段（luasnip） |

编译失败时自动弹出 quickfix 窗口，回车跳转到出错行。

### DAP 可视化调试（codelldb）

| 按键 | 说明 |
|---|---|
| `<leader>dD` | **编译并调试当前文件**（带 `-g` 符号，停到入口） |
| `<leader>db` | 切换断点（当前行） |
| `<leader>dB` | 设置条件断点 |
| `<leader>dc` | 继续 / 启动调试 |
| `<leader>dl` | 运行上次调试 |
| `<leader>dg` | 光标跳转（不执行） |
| `<leader>di` / `<leader>do` / `<leader>dO` | 单步 进入 / 跳出 / 跳过 |
| `<leader>du` | 开关调试 UI 面板 |
| `<leader>de` | 求值表达式（可视模式选中变量） |
| `<leader>dr` | 调试 REPL |
| `<leader>dt` | 终止调试 |
| `<leader>dk` / `<leader>dj` | 调用栈 上 / 下 |
| `<leader>dw` | 变量悬浮预览 |

调试时 nvim-dap-ui 会自动展示：变量、监视、断点列表、调用栈。

## 目录结构

```
lua/
├── config/           # 全局配置与 lazy.nvim 引导
│   ├── options.lua
│   ├── autocmds.lua
│   ├── keymaps.lua
│   └── lazy.lua
├── plugins/          # 每个文件一个插件/功能
│   ├── catppuccin.lua   # 主题 + 全透明
│   ├── snacks.lua       # Snacks(终端/上传 等)
│   ├── luansnip.lua     # 代码片段
│   ├── dap.lua          # 调试器
│   └── navic.lua        # 面包屑
ftplugin/
└── cpp.lua           # C++ 缩进 + 编译/运行快捷键
snippets/
└── cpp.lua           # C++ 头部模板
```

> 注：`template.cpp` 是历史遗留的写满代码的文件，不属于配置，可自行清理。