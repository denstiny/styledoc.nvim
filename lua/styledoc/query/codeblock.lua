local M = {}
local utils = require("styledoc.query.utils")

function M.get_nodes(bufnr, start, end_)
	return utils.get_nodes_table(
		bufnr,
		start,
		end_,
		-- [[
		-- (fenced_code_block) @code_block
		-- (language) @code_lang
		-- (fenced_code_block_delimiter) @code_end
		-- ]]
		[[
    (fenced_code_block) @code_block
    ]]
	)
end

function M.get_code_lang_node(bufnr, start, end_)
	vim.notify(string.format("find: start %s end %s", start, end_))
	return utils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
    (language) @code_lang
    ]]
	)
end

return M
