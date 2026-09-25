return {
        {
            "l3mon4d3/luasnip",
            version = "v2.*", -- replace <currentmajor> by the latest released major (first number of latest release)
            build = "make install_jsregexp",

            dependencies = { "rafamadriz/friendly-snippets" },

            config = function()
                local ls = require("luasnip")

                require("luasnip.loaders.from_vscode").lazy_load()

                vim.keymap.set({ "i", "s" }, "<M-j>", function()
                    if ls.expand_or_jumpable() then
                        ls.expand_or_jump()
                    end
                end)

                vim.keymap.set({ "i", "s" }, "<M-k>", function()
                    if ls.jumpable(-1) then
                        ls.jump(-1)
                    end
                end)

                vim.keymap.set({"i", "s"}, "<M-h>", function()
                    if ls.choice_active() then
                        ls.change_choice(1)
                    end
                end, {silent = true})

                vim.keymap.set({"i", "s"}, "<M-l>", function()
                    if ls.choice_active() then
                        ls.change_choice(-1)
                    end
                end, {silent = true})
            end,
        }
    }
