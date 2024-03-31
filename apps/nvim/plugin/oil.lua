require("oil").setup {
  win_options = {
    signcolumn = "yes:2",
  },
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
