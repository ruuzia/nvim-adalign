local M = {}
local api = vim.api

local function unalign(lines)
    local modified = false
    for i,s in ipairs(lines) do
        lines[i] = s:gsub("(%S) +", "%1 ")
        modified = modified or lines[i] ~= s
    end
    return modified
end

function M.preview(ctx, preview_ns, preview_buf)
    local startline = ctx.line1 - 1 --to 0-based index
    local buffer = 0
    local lines = assert(api.nvim_buf_get_lines(buffer, startline, ctx.line2, false))

    for i, l in ipairs(lines) do
        for start_idx, end_idx in l:gmatch("%S()  +()") do
            api.nvim_buf_add_highlight(buffer, preview_ns, 'AdalignDeleteSpace', startline + i-1, start_idx-1, end_idx-1)
        end
    end
    return 1
end

function M.command(ctx)
    local startline = ctx.line1 - 1 --to 0-based index
    local buffer = 0
    local lines = assert(api.nvim_buf_get_lines(buffer, startline, ctx.line2, false))
    if unalign(lines) then api.nvim_buf_set_lines(buffer, startline, ctx.line2, false, lines) end
end
return M
