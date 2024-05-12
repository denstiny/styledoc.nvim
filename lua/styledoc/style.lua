local M = {}
local fn = vim.fn
local api = vim.api
local group = require("styledoc.info").group

function M.hl_line(bufnr, line, hl)
	local text = string.rep(" ", fn.winwidth(fn.bufwinnr(bufnr)))
	local opts = {
		virt_text = { { text, hl } },
		hl_eol = true,
		virt_text_pos = "overlay",
	}
	api.nvim_buf_add_highlight(bufnr, group, hl, line, 0, -1)
	pcall(api.nvim_buf_set_extmark, bufnr, group, line, fn.len(fn.getline(line + 1)), opts)
end

return M
