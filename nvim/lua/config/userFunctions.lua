
local M = {}

function M.Preserve_Window_Bdelete()
    vim.cmd("bnext")

    local alt = vim.fn.bufnr("#")
    if alt < 1
        and vim.fn.bufloaded(alt) == 1 then
        print("No alternate buffer")
    end

    if vim.fn.bufexists(alt) == 1
        and vim.fn.bufwinid(alt) == -1 then
        vim.cmd("bdelete " .. alt)
    else
        print("Alternate buffer in other window")
    end

end

--Scratch buffer
local scratch_buf = nil
local scratch_win = nil

local function toggle_scratch()
    -- Close the floating window if it's already open
    if scratch_win and vim.api.nvim_win_is_valid(scratch_win) then
        vim.api.nvim_win_close(scratch_win, true)
        scratch_win = nil
        vim.cmd("stopinsert")
        return
    end

    -- Create the buffer if it doesn't exist
    if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
        scratch_buf = vim.api.nvim_create_buf(false, true)

        vim.bo[scratch_buf].buftype = "nofile"
        vim.bo[scratch_buf].bufhidden = "hide"
        vim.bo[scratch_buf].swapfile = false
    end

    -- Calculate size
    local width = math.floor(vim.o.columns * 0.95)
    local height = math.floor(vim.o.lines * 0.9)

    -- Center the window
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    scratch_win = vim.api.nvim_open_win(scratch_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "",
        border = "rounded",
    })
    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Scratch", toggle_scratch, {})

return M
