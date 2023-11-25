vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local path = vim.fn.expand("%")

    if vim.fn.isdirectory(path) ~= 0 then vim.fn.chdir(path) end
  end,
})
