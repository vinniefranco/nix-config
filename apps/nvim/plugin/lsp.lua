local lsp_zero = require('lsp-zero')
require('neodev').setup({
  override = function(root_dir, library)
    if root_dir:find(".dotfiles", 1, true) == 1 then
      library.enabled = true
      library.plugins = true
    end
  end,
})

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
