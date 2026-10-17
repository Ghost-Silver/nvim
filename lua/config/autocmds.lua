-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- C/C++ 的缩进与编译运行快捷键已移至 ftplugin/cpp.lua（更规范的位置）

-- Markdown：彻底关闭拼写检查（消除中文和专有名词下的红色波浪线）及语法格式诊断
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(event)
    vim.opt_local.spell = false
    if vim.diagnostic.enable then
      vim.diagnostic.enable(false, { bufnr = event.buf })
    else
      vim.diagnostic.disable(event.buf)
    end
  end,
})

-- 清除 LazyVim 针对 markdown 自动开启 spell 的 autocmd
pcall(function()
  vim.api.nvim_clear_autocmds({ group = "lazyvim_wrap_spell", pattern = "markdown" })
end)

-- Markdown：标题、行内代码块强制透明背景（保留原本的前景色/加粗等样式）
-- 注意：@markup.* 组要等 treesitter 高亮建立后才完整，因此用 schedule 延迟重查
local md_transparent = {
  "@markup.heading", "@markup.heading.1", "@markup.heading.2",
  "@markup.heading.3", "@markup.heading.4", "@markup.heading.5", "@markup.heading.6",
  "@markup.heading.markdown", "@text.title",
  "@markup.raw", "@markup.raw.inline", "@markup.raw.markdown_inline",
  "@markup.raw.markdown", "@markup.raw.block", "@markup.fenced_code_block",
  "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
  "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
  "RenderMarkdownCode", "RenderMarkdownCodeInline", "RenderMarkdownCodeBorder",
  "RenderMarkdownTableHead", "RenderMarkdownTableRow", "RenderMarkdownQuote",
  "ColorColumn",
}

local function apply_md_transparent_once()
  for _, g in ipairs(md_transparent) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = true })
    -- 只要该组当前带背景就强制清掉；fg 用它的解析色保留，避免丢样式
    if hl and (hl.bg or hl.fg) then
      vim.api.nvim_set_hl(0, g, {
        fg = hl.fg,
        bg = "none",
        bold = hl.bold,
        italic = hl.italic,
        underline = hl.underline,
        undercurl = hl.undercurl,
      })
    end
  end
end

local function apply_md_transparent()
  apply_md_transparent_once()
  -- 第二次延迟再跑，确保在 treesitter 挂上高亮后仍覆盖
  vim.schedule(apply_md_transparent_once)
end

-- 主题切换时保持透明，并在每次进入 markdown 时再确保一遍
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_md_transparent })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = apply_md_transparent,
})
apply_md_transparent()