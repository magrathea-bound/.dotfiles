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

return M
