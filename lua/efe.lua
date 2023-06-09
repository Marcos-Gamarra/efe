local fn = vim.fn

--global variable that holds the target of the previous search
vim.g.efePreviousTarget = ''

--Repeats the last search in the forward direction.
--the cursor_pos holds a table in which the first element is the number of the current line.
--this number is used to restrict the search to the line the cursor is currenly in.
local function repeat_forward()
    local target = vim.g.efePreviousTarget
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    fn.search(target, '', cursor_pos[1])
end

--Same as the forward function but backwards
local function repeat_backward()
    local target = vim.g.efePreviousTarget
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    fn.search(target, 'b', cursor_pos[1])
end

--Takes two characters as input, and in the current line and after the cursor,
--searches for the first occurrence of the inputted text. If an occurrence is found
--moves the cursor to the first character of the target text, if no occurrence is found
--does nothing
local function forward()
    local current_line = vim.api.nvim_get_current_line()
    local first_char = fn.getcharstr()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    if (string.byte(first_char) == 27) then
        return
    end

    local second_char = fn.getcharstr()
    if (string.byte(second_char) == 32 and
        string.sub(current_line, #current_line) == first_char)
    then
        vim.api.nvim_win_set_cursor(0, { cursor_pos[1], #current_line - 1 })
        return
    end

    local target = first_char .. second_char

    if (first_char == '.') then
        target = '\\' .. target
    end

    vim.g.efePreviousTarget = target
    fn.search(target, '', cursor_pos[1])
end

--Same as efe_forward() but backwards
local function backward()
    local first_char = fn.getcharstr()
    if (string.byte(first_char) == 27) then
        return
    end
    local second_char = fn.getcharstr()
    local target = first_char .. second_char
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.g.efePreviousTarget = target
    fn.searchpos(target, 'b', cursor_pos[1])
end

return {
    backward = backward,
    forward = forward,
    repeat_forward = repeat_forward,
    repeat_backward = repeat_backward,
}
