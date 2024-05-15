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
		if not res then
			utils.del_hl(bufnr, i, i + 1)
		end
	end
end

return M
