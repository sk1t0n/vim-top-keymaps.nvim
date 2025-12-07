local M = {}

M.win_id = nil
M.win_width = vim.api.nvim_win_get_width(0)
M.win_height = vim.api.nvim_win_get_height(0)
M.default_opts = {
  modifiable = vim.o.modifiable,
  number = vim.o.number,
  relativenumber = vim.o.relativenumber,
  cursorline = vim.o.cursorline,
  guicursor = vim.o.guicursor,
  mousescroll = vim.o.mousescroll,
  wrap = vim.o.wrap,
}

function M.setup()
  vim.keymap.set("n", "<leader>H", function()
    require("vim-top-keymaps").toggle()
  end, { desc = "Toggle VimTopKeymaps" })
end

function M.show()
  local buf_number = vim.api.nvim_create_buf(false, true)
  local popup_width = 56
  local popup_height = 29
  M.win_id = vim.api.nvim_open_win(buf_number, true, {
    title = "Vim top keymaps",
    title_pos = "center",
    border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    relative = "editor",
    col = math.ceil(M.win_width / 2) - math.ceil(popup_width / 2),
    row = math.ceil(M.win_height / 2) - math.ceil(popup_height / 2),
    width = popup_width,
    height = popup_height,
  })

  local text = {
    "h/j/k/l - move the cursor left/down/up/right",
    "gg - go to the first line",
    "<number>gg - go to the nth line",
    "G - go to the last line",
    "0/$ - go to the first/last character of the line",
    "w - go to the next word",
    "e - go to the end of the word",
    "b - go to the previous word",
    "v - visual mode",
    "V - visual line mode",
    "vip - select the current paragraph",
    "y - copy selected text or character",
    "x - cut selected text or character",
    "r - replace selected text or character",
    "i - insert before the cursor",
    "a - insert after the cursor",
    "A - insert to the end of the current line",
    "o - insert a new line below the current line",
    "O - insert a new line above the current line",
    "cc/dd/yy - change/cut/copy the current line",
    "ciw/diw/yiw - change/cut/copy the current word",
    "p - paste from the clipboard after the cursor",
    "P - paste from the clipboard before the cursor",
    "u - undo the last change",
    "C-r - redo the last undo",
    "/ - search forward (n/N - next/previous)",
    ": - command mode",
  }
  vim.api.nvim_buf_set_lines(buf_number, 1, -1, false, text)

  vim.o.modifiable = false
  vim.o.number = false
  vim.o.relativenumber = false
  vim.o.cursorline = false
  vim.o.guicursor = "n:hor20"
  vim.o.mousescroll = "ver:0,hor:0"
  vim.o.wrap = true
end

local function is_zen_mode()
  local round = function(n)
    return math.floor(n + 0.5)
  end
  local w = vim.api.nvim_win_get_width(0)
  return w >= round(M.win_width * 0.75) and w <= round(M.win_width * 0.9)
end

local function show_error()
  vim.api.nvim_echo({ { "VimTopKeymaps: " }, { "in Zen mode, you can't close the window" } }, true, {})
end

local function reset_opts()
  for k, v in pairs(M.default_opts) do
    vim.o[k] = v
  end
end

function M.hide()
  if is_zen_mode() then
    show_error()
    return
  end

  if vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_win_close(M.win_id, true)
    M.win_id = nil
    reset_opts()
  end
end

function M.toggle()
  if M.win_id == nil then
    M.show()
  else
    M.hide()
  end
end

vim.api.nvim_create_user_command("VimTopKeymapsToggle", M.toggle, {})

return M
