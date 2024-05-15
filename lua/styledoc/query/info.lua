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
(section (paragraph (inline)@inline))
  ]],
	section = [[(section) @section ]],
}

return M
