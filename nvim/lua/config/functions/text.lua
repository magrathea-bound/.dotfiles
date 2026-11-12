local M = {}

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


function M.commas()
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
        items[i] = line .. ","
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
    "BDCommas",
    M.commas,
    {}
)

return M
