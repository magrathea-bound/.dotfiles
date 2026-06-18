vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "tailwindcss" then
      -- Pass ONLY the bufnr to target the current file
      vim.lsp.document_color.enable(false, { bufnr = args.buf })
    end
  end,
})
