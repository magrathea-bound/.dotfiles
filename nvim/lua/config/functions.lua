
local M = {}

function M.Preserve_Window_Bdelete()
    vim.cmd("bnext")

    local alt = vim.fn.bufnr("#")
    if alt < 1
        and vim.fn.bufloaded(alt) == 1 then
        print("No other buffers")
    end

    if vim.fn.bufexists(alt) == 1
        and vim.fn.bufwinid(alt) == -1 then
        vim.cmd("bdelete " .. alt)
    else
        print("Buffer not hidden")
    end

end

--Scratch buffer
local scratch_buf = nil
local scratch_win = nil

function M.toggle_scratch()
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
end

vim.api.nvim_create_user_command(
    "BDScratch",
    M.toggle_scratch,
    {}
)

function M.remove_duplicate_lines()
    local start_line, end_line

    if vim.fn.mode():match("[vV\22]") then
        local start_pos = vim.fn.getpos("v")
        local end_pos = vim.fn.getpos(".")

        start_line = math.min(start_pos[2], end_pos[2])
        end_line = math.max(start_pos[2], end_pos[2])
    else
        start_line = 1
        end_line = vim.api.nvim_buf_line_count(0)
    end

    local lines = vim.api.nvim_buf_get_lines(
        0,
        start_line - 1,
        end_line,
        false
    )

    local seen = {}
    local unique = {}

    for _, line in ipairs(lines) do
        if not seen[line] then
            seen[line] = true
            table.insert(unique, line)
        end
    end

    vim.api.nvim_buf_set_lines(
        0,
        start_line - 1,
        end_line,
        false,
        unique
    )
end

vim.api.nvim_create_user_command(
    "BDDuplicateLines",
    M.remove_duplicate_lines,
    {}
)

function M.format_sql_list()
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line, end_line

    if vim.fn.mode():match("[vV\22]") then
        local start_pos = vim.fn.getpos("v")
        local end_pos = vim.fn.getpos(".")

        start_line = math.min(start_pos[2], end_pos[2])
        end_line = math.max(start_pos[2], end_pos[2])
    else
        start_line = 1
        end_line = vim.api.nvim_buf_line_count(bufnr)
    end

    local lines = vim.api.nvim_buf_get_lines(
        bufnr,
        start_line - 1,
        end_line,
        false
    )

    local items = {}

    for i, line in ipairs(lines) do
        items[i] = "'" .. line .. "',"
    end

    if #items > 0 then
        items[#items] = string.sub(items[#items], 1, -2)
    end

    vim.api.nvim_buf_set_lines(
        bufnr,
        start_line - 1,
        end_line,
        false,
        items
    )
end

vim.api.nvim_create_user_command(
    "BDSqlListFormat",
    M.format_sql_list,
    {}
)

return M
