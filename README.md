# GhostFace's Nvim 配置

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 深度定制的个人开发与定理证明环境。
主题采用 **Catppuccin Mocha**（定制冷冽黑底），全透明毛玻璃质感，完美适配 **Ghostty** (Metal + Display P3) 与 **iTerm2**。

---

## 核心特性

- 💎 **极客美学**：全局透明背景无边框，结合毛玻璃无缝透光，消除大标题与代码块实色色块。
- 📐 **Lean 4 定理证明**：开箱即用的 `lean.nvim` 集成、实时交互式 Infoview 证明状态视窗、高对比度目标高亮与 Unicode 数学符号补全（如 `\to` $\to$ `→`, `\forall` $\to$ `∀`, `\lambda` $\to$ `λ`）。
- 📝 **Markdown & LaTeX 实时预览**：
  - 终端 Buffer 内行内 Unicode 公式美化（`render-markdown.nvim` + `latex2text`）；
  - 浏览器端像素级 KaTeX / MathJax 实时双向滚动预览（`markdown-preview.nvim`）。
- 🤖 **AI 结对助手 (Antigravity CLI)**：内置 `<leader>a` 系列快捷键，支持智能右侧分屏（与 Lean Infoview 自动 50/50 均分）、悬浮窗口与选区代码即时重构。
- ⚡ **C++ 算法竞赛 & DAP 调试**：极速编译运行、Sanitizer 诊断、代码片段与基于 `codelldb` 的可视化单步调试。

---

## 运行环境

- **Neovim** $\ge$ 0.10
- **推荐终端**：[Ghostty](https://ghostty.org/)（原生 Metal 渲染，P3 广色域）或 iTerm2
- **依赖工具**：
  - Lean 4：`elan`（确保在 `~/.elan/bin`）
  - LaTeX 转文本：`pylatexenc` (`latex2text`)
  - 调试器：`codelldb` (Mason 自动管理)

---

## 快捷键速查

> `<leader>` 默认为 **`空格键 (Space)`**；`<LocalLeader>` 默认为 **`\` (反斜杠)**

### 1. 通用操作与导航

| 按键 | 说明 |
| :--- | :--- |
| `<leader>ff` | 模糊查找文件（Snacks Picker / fd） |
| `<leader>fg` | 全局文本搜索（ripgrep） |
| `<leader>fr` | 打开最近文件列表 |
| `<leader>e` | 打开 / 关闭侧边文件树（Snacks Explorer，按 `a` 新建，`r` 重命名，`d` 删除） |
| `Shift + h` / `Shift + l` | 快速在顶部标签栏左右切换 Buffer |
| `<leader>bd` | 关闭当前 Buffer（保持窗口布局） |
| `<leader>w` | 保存当前文件 |
| `<Esc>` | 关闭当前高亮 / 搜索提示 / 浮窗 |

---

### 2. Lean 4 交互式定理证明（在 `.lean` 文件内）

| 按键 | 说明 |
| :--- | :--- |
| `\i` 或 `<leader>li` | 打开 / 关闭 **Lean Infoview**（右侧证明状态与待证目标 Goals） |
| `\p` | 暂停 / 恢复 Infoview 目标更新 |
| `\x` | 固定（Pin）当前证明目标状态 |
| `\c` | 清除固定状态 |
| `\r` | 重新触发当前位置检查 |
| `\d` | 跳转到定义（Jump to Definition） |
| 输入 `\符号名` | 自动补全数学符号（如 `\to` $\to$ `→`, `\and` $\to$ `∧`, `\or` $\to$ `∨`, `\iff` $\to$ `↔`, `\cdot` $\to$ `·`） |

---

### 3. Markdown 与 LaTeX 排版（在 `.md` 文件内）

| 按键 | 说明 |
| :--- | :--- |
| `<leader>mp` 或 `<leader>cp` | **打开 / 关闭浏览器 KaTeX 实时同步预览**（基于 MathJax/KaTeX 毫秒级排版） |
| `:MarkdownPreviewStop` | 手动终止预览后台进程 |

---

### 4. AI 结对编程 (Antigravity CLI)

| 按键 | 模式 | 说明 |
| :--- | :--- | :--- |
| `<leader>as` | 普通模式 | **呼出 / 收起 Antigravity 侧边栏终端**（若右侧存在 Lean Infoview，自动 50/50 垂直对分） |
| `<leader>af` | 普通模式 | 弹出 / 隐藏 Antigravity 居中沉浸式浮窗终端 |
| `<leader>aa` | 可视模式 | 选中代码块后直接向 Antigravity 提问或请求重构 |

---

### 5. C++ 算法竞赛（在 `.cpp` 文件内）

| 按键 | 说明 |
| :--- | :--- |
| `<leader>cc` | 异步编译（`g++ -std=c++17 -O2 -Wall -Wextra`） |
| `<leader>cr` | 编译并弹出交互式运行终端（支持标准 `cin` / 交互调试） |
| `<leader>cC` | Sanitizer 调试版编译运行（开启 ASan + UBSan 内存越界检测） |
| `st` + `Tab` | 插入 C++ 竞赛头部模板（Luasnip） |

---

### 6. DAP 可视化调试（Codelldb）

| 按键 | 说明 |
| :--- | :--- |
| `<leader>dD` | **编译并启动当前文件调试**（带 `-g` 符号表，自动停在入口） |
| `<leader>db` | 切换当前行断点 |
| `<leader>dB` | 设置条件断点 |
| `<leader>dc` | 继续执行（Continue） |
| `<leader>di` / `<leader>do` / `<leader>dO` | 单步进入 (Step Into) / 跳出 (Step Out) / 单步跳过 (Step Over) |
| `<leader>du` | 切换调试 UI 面板（变量、调用栈、监视列表） |
| `<leader>de` | 快速计算表达式值 |
| `<leader>dt` | 终止调试会话 |

---

## 目录结构

```
~/.config/nvim/
├── lua/
│   ├── config/              # 全局配置与 LazyVim 核心
│   │   ├── options.lua      # 基础编辑器选项
│   │   ├── autocmds.lua     # 自动命令
│   │   ├── keymaps.lua      # 全局快捷键映射
│   │   └── lazy.lua         # Lazy.nvim 插件管理与 Extras 引入
│   └── plugins/             # 模块化插件配置
│       ├── antigravity.lua  # Antigravity CLI 侧边栏与浮窗智能停靠
│       ├── catppuccin.lua   # Catppuccin Mocha 主题定制、全透明与高亮增强
│       ├── lean.lua         # Lean 4 语言服务器与 Infoview 深度适配
│       ├── markdown.lua     # Markdown 渲染与浏览器 KaTeX 实时预览
│       ├── dap.lua          # Codelldb 调试器与 UI
│       ├── snacks.lua       # Snacks Explorer 文件树与终端增强
│       └── luasnip.lua      # 代码片段引擎
├── ftplugin/
│   └── cpp.lua              # C++ 编译与执行命令
└── snippets/
    └── cpp.lua              # 算法竞赛模版
```
