return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {"williamboman/mason.nvim", }, --version = "^1.0.0"
            {"williamboman/mason-lspconfig.nvim", }, --version = "^1.0.0"
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls"},
                automatic_installation = true,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local opts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, opts)
                end,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")

            vim.lsp.config("svelte", {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        pattern = { "*.js", "*.ts" },
                        callback = function(ctx)
                            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                        end,
                    })
                end,
            })
            vim.lsp.enable("svelte")

            vim.lsp.config("tailwindcss",{
                capabilities = capabilities,
                filetypes = { "html", "svelte", "css", "javascript", "typescript" },
                settings = {
                    tailwindCSS = {
                        includeLanguages = {
                            svelte = "html",
                        },
                    },
                },
                on_attach = function(client, _)
                    -- Disable Tailwind color backgrounds
                    client.server_capabilities.colorProvider = false

                end,
            })
            vim.lsp.enable("tailwindcss")

        end},

        {
            "stevearc/conform.nvim",
            config = function()
                require("conform").setup({
                    formatters_by_ft = {
                        javascript = { "prettier" },
                        typescript = { "prettier" },
                        html = { "prettier" },
                        css = { "prettier" },
                        json = { "prettier" },
                        vue = { "prettier" },
                        svelte = { "prettier" },
                    },
                    formatters = {
                        prettier = {
                            prepend_args = function(self, ctx)
                                return {"--plugin", "prettier-plugin-svelte", "--plugin", "prettier-plugin-tailwindcss"}
                            end,
                        }
                    }
                })

                vim.api.nvim_create_autocmd("bufwritepre", {
                    pattern = "*",
                    callback = function(args)
                        require("conform").format({ bufnr = args.buf, async = false})
                    end,
                })
            end,
        },

        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                {"hrsh7th/cmp-nvim-lsp"}, --, commit ="0e6b2ed",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path", --maybe don't need? :e completeion...
                "hrsh7th/cmp-cmdline",
                "l3mon4d3/luasnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<tab>'] = cmp.mapping.select_next_item(),
                        ['<s-tab>'] = cmp.mapping.select_prev_item(),
                        ['<cr>'] = cmp.mapping.confirm(),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "path" },
                    }),
                })
            end,
        },

        {'windwp/nvim-autopairs', event = "insertenter", config = true},

        { "kylechui/nvim-surround",}
    }
