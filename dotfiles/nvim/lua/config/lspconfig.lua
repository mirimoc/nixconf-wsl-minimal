local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <C-x><C-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on the available functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      -- gofumpt = true,
    },
  },
}

-- Option 1: Using pyright (Microsoft's static type checker)
-- Recommended for robust type checking and language features

lspconfig.pyright.setup {
  -- You can add more configuration options here if needed
  -- For example, to specify the python executable:
  -- cmd = {'pyright-langserver', '--stdio'},
  -- settings = {
  --   python = {
  --     pythonPath = '/path/to/your/python',
  --   },
  -- },
  -- on_attach = function(client, bufnr)
  --   -- You can define keybindings specific to this LSP client here
  --   -- For example, to map K to show documentation:
  --   vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  -- end,
}

-- Option 2: Using ruff-lsp (Fast linter and formatter)
-- Good for linting, formatting, and some basic language features

-- Ensure you have ruff and ruff-lsp installed (e.g., via pip install ruff ruff-lsp)

lspconfig.ruff_lsp.setup {
  -- You can add more configuration options here if needed
  -- For example, to configure ruff settings:
  -- settings = {
  --   ruff_lsp = {
  --     args = {
  --       "--line-length", "120",
  --       "--select", "E,F,W",
  --     },
  --   },
  -- },
  -- on_attach = function(client, bufnr)
  --   -- You can define keybindings specific to this LSP client here
  --   -- For example, to map <leader>lf to format the buffer:
  --   vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = bufnr })
  -- end,
}

-- Option 3: Using jedi-language-server (Another popular option)

-- Ensure you have jedi-language-server installed (e.g., via pip install jedi-language-server)

-- lspconfig.jedi_language_server.setup {
--   -- You can add more configuration options here if needed
--   -- For example, to specify the python executable:
--   -- cmd = {'jedi-language-server'},
--   -- settings = {
--   --   jedi = {
--   --     environment = '/path/to/your/virtualenv/bin/python',
--   --   },
--   -- },
--   -- on_attach = function(client, bufnr)
--   --   -- You can define keybindings specific to this LSP client here
--   --   -- Example: Go to definition
--   --   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
--   -- end,
-- }

-- Common setup for all Python language servers (optional)
-- This can be moved inside the individual setup functions if needed

-- Example of a general on_attach function
-- local on_attach = function(client, bufnr)
--   -- Enable completion triggered by <C-x><C-o>
--   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on the available functions
--   local bufopts = { noremap = true, silent = true, buffer = bufnr }
--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--   vim.keymap.set('n', '<space>wl', function()
--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   end, bufopts)
--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
--   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--   vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
--   vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, bufopts)
--   vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
-- end

-- To use the common on_attach function, you would add it to the setup like this:
-- lspconfig.pyright.setup {
--   on_attach = on_attach,
--   -- ... other options
-- }
--
-- lspconfig.ruff_lsp.setup {
--   on_attach = on_attach,
--   -- ... other options
-- }

-- Key points:
-- 1. You need to have the desired language server installed on your system (e.g., via pip).
-- 2. Ensure you have the 'nvim-lspconfig' plugin installed in your Neovim configuration.
-- 3. You can choose one or more language servers to configure.
-- 4. The `setup()` function takes a table of configuration options.
-- 5. The `on_attach` function is called when the language server attaches to a buffer. You can define keybindings specific to that language server within this function.
-- 6. You can customize the settings for each language server according to your preferences.

-- To use this configuration:
-- 1. Save this code in a Lua file (e.g., `lua/config/lsp/python.lua`).
-- 2. In your main Neovim configuration file (e.g., `init.lua`), require this file:
--    `require('config.lsp.python')`
-- 3. Make sure you have a way to manage your LSP servers (e.g., using a plugin like 'mason.nvim').

-- Recommendation:
-- For a good balance of features and performance, `pyright` and `ruff-lsp` are highly recommended for Python development in Neovim. You can even use them together. `pyright` for robust type checking and language features, and `ruff-lsp` for fast linting and formatting.
