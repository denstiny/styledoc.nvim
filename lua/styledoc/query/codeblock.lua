local M = {}
local utils = require("styledoc.query.utils")

function M.get_nodes(bufnr, start, end_)
	return utils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
    (fenced_code_block) @code_block
    (language) @code_lang
    (fenced_code_block_delimiter) @code_end
    ]]
	)
end

return M
