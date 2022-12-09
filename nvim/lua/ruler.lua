-- -----------------------------------------------
-- ruler
-- -----------------------------------------------

function GetDiag()
    local str = ""
    if vim.api.nvim_get_mode()["mode"] == 'n' then
        local err  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

        if err ~= 0 then
            str = str .. "%#DiagnosticError# E:" .. err .. "%*"
        end
        if warn ~= 0 then
            str = str .. "%#DiagnosticWarn# W:" .. warn .. "%*"
        end
        if hint ~= 0 then
            str = str .. "%#DiagnosticHint# H:" .. hint .. "%*"
        end
        if info ~= 0 then
            str = str .. "%#DiagnosticInfo# I:" .. info .. "%*"
        end
    end
    return str
end

function GetRunningLsp()
    local str = ""
    vim.lsp.for_each_buffer_client(0, function(client, client_id, bufnr)
        str = str .. "[%#PreProc#" .. client.name .. "%*]"
    end)
    return str
end

-- function LeftRuler(hold)
--     local diagMsg = vim.diagnostic.get(0, {lnum = vim.fn.line('.') - 1})
--     if (#diagMsg ~= 0) then
--         print(diagMsg[1].message)
--     elseif (hold) then
--         vim.cmd[[echo expand('%:p:~')]]
--     end
-- end

-- augroup LeftRuler
--     autocmd!
--     autocmd CursorMoved,InsertLeave * :lua LeftRuler()
--     autocmd CursorHold * :lua LeftRuler(1)
-- augroup end

-- set ruf=%30(%=%#LineNr#%.50F\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %p%%%)
-- set rulerformat=%36(%5l,%-6(%c%V%)\ %y%)%*
-- set rulerformat=%50(%=[%l,%c/%L]\ %m\ %{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}\ [%Y]%)

vim.cmd [[ set rulerformat=%45(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %m%q%w\ %y%) ]]

