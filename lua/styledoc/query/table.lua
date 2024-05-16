local M = {}
local qutils = require("styledoc.query.utils")
local utils = require("styledoc.utils")

--	[[
--  (
-- pipe_table
--  (pipe_table_header (pipe_table_cell)@table_header)
--  (pipe_table_delimiter_row (pipe_table_delimiter_cell)@table_delimiter_cell)
--  (pipe_table_row (pipe_table_cell) @table_cell)
--)@table
--  ]],

function M.table_header(bufnr, start, end_)
	return qutils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
(pipe_table 
  (pipe_table_header (pipe_table_cell)@table_header)
)
  ]]
	)
end

function M.table_cell(bufnr, start, end_)
	return qutils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
( pipe_table
  (pipe_table_row (pipe_table_cell) @table_cell)
)
  ]]
	)
end

function M.table_delimiter_cell(bufnr, start, end_)
	return qutils.get_nodes_table(
		bufnr,
		start,
		end_,
		[[
(pipe_table
  (pipe_table_delimiter_row (pipe_table_delimiter_cell)@table_delimiter_cell)
)
  ]]
	)
end

return M
