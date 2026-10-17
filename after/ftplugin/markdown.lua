-- 关闭 Markdown 文件的拼写检查（消除中文以及英文专有名词下泛滥的红色波浪线）
vim.opt_local.spell = false

-- 关闭 Markdown buffer 的语法与代码规范诊断（消除 markdownlint / marksman 产生的波浪线）
if vim.diagnostic.enable then
  vim.diagnostic.enable(false, { bufnr = 0 })
else
  vim.diagnostic.disable(0)
end
