local fn = vim.fn

local function efeEnter()
    --vim.api.nvim_set_hl(0, 'LineNr', { bg = "#373b41", fg = "NONE" })
    vim.cmd('hi CursorLineNr guibg=#373b41 guifg=#373b41 | hi LineNr guibg=#373b41')
    vim.cmd("redraw")
end

local function efeLeave()
    --vim.api.nvim_set_hl(0, 'LineNr', { bg = "NONE", fg = "#373b41" })
    vim.cmd("hi LineNr guibg=NONE | hi CursorLineNR guibg=NONE guifg=#5f87af")
end
vim.g.efePreviousTarget = ''
local function repeat_last_efe_forward()
    local target = vim.g.efePreviousTarget
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    fn.search(target, '', cursor_pos[1])
end

local function repeat_last_efe_backward()
    local target = vim.g.efePreviousTarget
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    fn.search(target, 'b', cursor_pos[1])
end

local function efe_forward()
    --efeEnter()
    local current_line = vim.api.nvim_get_current_line()
    local first_char = fn.getcharstr()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    if (string.byte(first_char) == 27) then
        --efeLeave()
        return
    end
    local second_char = fn.getcharstr()
    if (string.byte(second_char) == 32 and
        string.sub(current_line, #current_line) == first_char)
    then
        vim.api.nvim_win_set_cursor(0, {cursor_pos[1], #current_line - 1})
        --efeLeave()
        return
    end
    local target = first_char .. second_char
    vim.g.efePreviousTarget = target
    fn.search(target, '', cursor_pos[1])
    --efeLeave()
end

local function efe_backward()
    --efeEnter()
    local first_char = fn.getcharstr()
    if (string.byte(first_char) == 27) then
        --efeLeave()
        return
    end
    local second_char = fn.getcharstr()
    local target = first_char .. second_char
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.g.efePreviousTarget = target
    fn.searchpos(target, 'b', cursor_pos[1])

    --efeLeave()
end



local function efe()
    vim.keymap.set(
        { 'n', 'v', 'o' },
        's',
        ':lua require"efe".efe_forward()<CR>',
        { silent = true }
    )
    --vim.keymap.set({ 'n', 'v', 'o' }, 'h', ':lua require"efe".efe_backward()<CR>')
    vim.keymap.set(
        { 'n', 'v', 'o' },
        'h',
        ':lua require"efe".efe_backward()<CR>',
        { silent = true }
    )
    vim.keymap.set(
        { 'n', 'v', 'o' },
        ';',
        ':lua require"efe".repeat_last_efe_forward()<CR>',
        { silent = true }
    )
    vim.keymap.set(
        { 'n', 'v', 'o' },
        ',',
        ':lua require"efe".repeat_last_efe_backward()<CR>',
        { silent = true }
    )
end

return {
    efe = efe,
    efe_backward = efe_backward,
    efe_forward = efe_forward,
    repeat_last_efe_forward = repeat_last_efe_forward,
    repeat_last_efe_backward = repeat_last_efe_backward,
}
