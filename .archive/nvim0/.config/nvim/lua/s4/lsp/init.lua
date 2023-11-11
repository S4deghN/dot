local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "s4.lsp.lsp-installer"
require("s4.lsp.handlers").setup()
require "s4.lsp.null-ls"
