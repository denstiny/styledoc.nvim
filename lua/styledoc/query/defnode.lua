local M = {}
local utils = require("styledoc.query.utils")
function M.get_nodes(bufnr, start, end_)
	return utils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
    (inline) @inline
    ]]
	)
end

return M
