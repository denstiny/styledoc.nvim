local M = {}
local utils = require("styledoc.utils")

function M.draw(bufnr, captures)
	for capture_name, node in pairs(captures) do
		M.scavenger(bufnr, node)
	end
end

function M.scavenger(bufnr, node)
	local start, end_ = node:start(), node:end_()
	for i = start, end_ do
		local res, n = utils.is_line_covered_by_node(bufnr, i, node)
		local n_lines = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)
		local n_line
		if #n_lines >= 1 then
			n_line = n_lines
		end
		if not res then
			utils.del_hl(bufnr, i, i)
		end
	end
	--vim.notify(string.format("清道夫: line %d end_ %d", start, end_))
end

return M
