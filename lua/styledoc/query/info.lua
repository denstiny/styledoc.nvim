local M = {
	--codeblock = [[ ( (fenced_code_block) @code_block) ]],

	codeblock = [[
		(fenced_code_block) @code_block
		(language) @code_lang
		]],

	--inline = [[
	--	(inline) @inline
	--]],

	inline = [[
(section 
 (paragraph 
  (inline)@scavenger_inline
))
  ]],

	section = [[(section) @section ]],

	--	table = [[
	--  (
	-- pipe_table
	--  (pipe_table_header (pipe_table_cell)@table_header)
	--  (pipe_table_delimiter_row (pipe_table_delimiter_cell)@table_delimiter_cell)
	--  (pipe_table_row (pipe_table_cell) @table_cell)
	--)@table
	--  ]],
	table = [[ (pipe_table)@table ]],
}

return M
