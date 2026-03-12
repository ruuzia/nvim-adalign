local function callback(modname, fn_name) return function(...) return require(modname)[fn_name](...) end end

vim.api.nvim_create_user_command("Align", callback("adalign.align", "command"), {
    range = 1,
    nargs = 1,
    preview = callback("adalign.align", "preview"),
})
vim.api.nvim_create_user_command("Unalign", callback("adalign.unalign", "command"), {
    range = 1,
    preview = callback("adalign.unalign", "preview")
})

