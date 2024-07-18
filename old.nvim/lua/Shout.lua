local W_THRESHOLD = 160
local shout_job

local function Vertical()
    local result = ""
    if vim.o.columns >= W_THRESHOLD and vim.fn.winlayout()[1] ~= 'row' then
        result = "vertical"
    end
    return result
end

local function FindOtherWin()
    local current_winid = vim.fn.win_getid()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if winid ~= current_winid then
            return winid
        end
    end
    return -1
end

local function ShoutWinId()
    local buffers = vim.fn.getbufinfo()
    for _, buffer in ipairs(buffers) do
        if vim.fn.fnamemodify(buffer.name, ":t") == '[shout]' and #buffer.windows > 0 then
            return buffer.windows[1]
        end
    end
    return -1
end

local function PrepareBuffer(shell_cwd)
    local bufname = '[shout]'
    local buffers = vim.fn.getbufinfo()
    local bufnr = -1

    for _, buffer in ipairs(buffers) do
        if vim.fn.fnamemodify(buffer.name, ":t") == bufname then
            bufnr = buffer.bufnr
            break
        end
    end

    if bufnr == -1 then
        bufnr = vim.fn.bufadd(bufname)
    end

    local windows = vim.fn.win_findbuf(bufnr)
    local initial_winid = vim.fn.win_getid()

    if #windows == 0 then
        vim.cmd("botright " .. Vertical() .. " sbuffer " .. bufnr)
        vim.b.shout_initial_winid = initial_winid
        vim.bo.filetype = 'shout'
    else
        vim.fn.win_gotoid(windows[1])
    end

    vim.cmd("silent :%d _")
    vim.b.shout_cwd = shell_cwd
    vim.cmd("silent lcd " .. shell_cwd)
    vim.bo.undolevels = -1

    return bufnr
end

local function CaptureOutput(command, follow)
    local cwd = vim.fn.getcwd()
    local bufnr = PrepareBuffer(cwd:gsub('#', '\\&'))

    vim.fn.setbufvar(bufnr, "shout_exit_code", "")

    local job_command
    if vim.fn.has("win32") then
        job_command = command
    else
        job_command = {vim.o.shell, vim.o.shellcmdflag, vim.fn.escape(command, '\\')}
    end

    if shout_job and shout_job:status() == "run" then
        shout_job:stop()
    end

    shout_job = vim.fn.jobstart(job_command, {
        cwd = cwd,
        pty = 1,
        on_stdout = function(_, data, _)
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {data})
        end,
        on_exit = function(_, exit_code, _)
            if vim.api.nvim_buf_is_valid(bufnr) then
                local winid = vim.fn.bufwinid(bufnr)
                if vim.g.shout_print_exit_code ~= false then
                    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"Exit code: " .. exit_code})
                end
                if follow then
                    vim.fn.win_execute(winid, "normal! G")
                end
                vim.fn.setbufvar(bufnr, "shout_exit_code", exit_code)
                vim.fn.win_execute(winid, "setl undolevels&")
            end
        end
    })

    _G.t.shout_cmd = command

    if follow then
        vim.cmd("normal! G")
    end

    vim.cmd("wincmd p")
end

-- Define other functions similarly as per the Vim9 script

return {
    CaptureOutput = CaptureOutput,
    -- define other exported functions here
}
