local M = {
	--codeblock = [[ ( (fenced_code_block) @code_block) ]],
	title = [[
  (atx_h6_marker) @h6
  (atx_h5_marker) @h5
  (atx_h4_marker) @h4
  (atx_h3_marker) @h3
  (atx_h2_marker) @h2
  (atx_h1_marker) @h1
]],
	codeblock = [[
		(fenced_code_block) @code_block
		]],

	--inline = [[
	--	(inline) @inline
	--]],

	inline = [[ (section (paragraph (inline)@scavenger_inline)) ]],

	section = [[(section) @section ]],

	breakline = "(thematic_break) @break_line",

	block = [[(block_quote(block_quote_marker) @block)]],
	--	table = [[
	--  (
	-- pipe_table
	--  (pipe_table_header (pipe_table_cell)@table_header)
	--  (pipe_table_delimiter_row (pipe_table_delimiter_cell)@table_delimiter_cell)
	--  (pipe_table_row (pipe_table_cell) @table_cell)
	--)@table
	--  ]],
	table = [[ (pipe_table)@table ]],

	list = [[
  (list_marker_minus) @list_minus
  (task_list_marker_unchecked) @task_undo
  (task_list_marker_checked) @task_do
]],
}

return M
