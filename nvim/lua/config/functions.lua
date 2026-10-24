
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
        print("Alternate buffer not hidden")
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
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local seen = {}
    local unique = {}

    for _, line in ipairs(lines) do
        if not seen[line] then
            seen[line] = true
            table.insert(unique, line)
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, unique)
end

vim.api.nvim_create_user_command(
    "BDDuplicateLines",
    M.remove_duplicate_lines,
    {}
)

function M.format_sql_list()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local items = {}

    for i, line in ipairs(lines) do
        items[i] = "'"..line.."',"
    end

    local last_item = items[#items]
    last_item = string.sub(last_item,0, -2)
    items[#items] = last_item

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, items)
end

vim.api.nvim_create_user_command(
    "BDSqlListFormat",
    M.format_sql_list,
    {}
)

return M
