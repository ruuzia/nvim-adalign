local M = {}
local api = vim.api
local adalign = require "adalign.util"


api.nvim_set_hl(0, "AdalignInsertSpace",  { link = "Substitute", default = true })
api.nvim_set_hl(0, "AdalignMatch",        { link = "Search",     default = true })
api.nvim_set_hl(0, "AdalignLeadingMatch", { link = "IncSearch",  default = true })
api.nvim_set_hl(0, "AdalignDeleteSpace",  { link = "Substitute", default = true })

function M.command(ctx)
    local startline = ctx.line1 - 1 --to 0-based index
    local buffer = 0

    -- lines must exist if it's a valid range, right?
    local lines = assert(api.nvim_buf_get_lines(buffer, startline, ctx.line2, false))


    local matches, err = adalign.get_matches(lines, ctx.args)
    if not matches then
        return api.nvim_err_writeln(err)
    end
    local inserts = adalign.get_inserts(lines, matches)
    local new_lines = adalign.apply_inserts(lines, inserts)
    api.nvim_buf_set_lines(buffer, startline, ctx.line2, false, new_lines)
end

function M.preview(ctx, preview_ns, preview_buf)
    print("PREVIEW", ctx, preview_ns, preview_buf)
    local startline = ctx.line1 - 1 --to 0-based index
    local buffer = 0

    -- lines must exist if it's a valid range, right?
    local lines = assert(api.nvim_buf_get_lines(buffer, startline, ctx.line2, false))

    local matches, err = adalign.get_matches(lines, ctx.args)
    if matches then
        local inserts = adalign.get_inserts(lines, matches)
        local new_lines = adalign.apply_inserts(lines, inserts)

        -- set lines
        api.nvim_buf_set_lines(buffer, startline, ctx.line2, false, new_lines)

        local targetcol = adalign.get_target_column(matches)

        for i = 1, #lines do
            -- highlight inserts
            if inserts[i] then
                vim.hl.range(
                    buffer,
                    preview_ns,
                    'AdalignInsertSpace',
                    { startline + i-1, inserts[i].start-1 },
                    { startline + i-1, inserts[i].start-1 + #inserts[i].text }
                )
            end

            -- highlight matches
            local is_leading = matches.columns[i] == targetcol
            if matches.indices[i] then
                local chars_inserted = inserts[i] and #inserts[i].text or 0
                vim.hl.range(
                    buffer,
                    preview_ns,
                    is_leading and 'AdalignLeadingMatch' or 'AdalignMatch',
                    -- matches indices don't take into account new inserts
                    { startline + i-1, matches.indices[i] + chars_inserted },
                    { startline + i-1, matches.ends[i] + chars_inserted }
                )
            end
        end
    end
    return 1
end

return M
