local ls = require "luasnip"
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local fmt = require("luasnip.extras.fmt").fmt
-- local m = require("luasnip.extras").m
-- local lambda = require("luasnip.extras").l
-- local postfix = require("luasnip.extras.postfix").postfix

ls.config.set_config {
    history = true,
    updateevents = "TextChanged", "TextChangedI",
}

-- luasnip
--
-- vim.keymap.set("i", "<C-u>", function()
--     require "luasnip.extras.select_choice"
-- end)
-- vim.keymap.set("i", "<c-l>", function()
--     if ls.choice_active() then
--         ls.change_choice(1)
--     end
-- end)
-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if ls.expand_or_jumpable() then
        ls.jump(-1)
    end
end, { silent = true })
