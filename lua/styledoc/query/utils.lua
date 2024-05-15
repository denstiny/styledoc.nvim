local ts_utils = vim.treesitter
local M = {}

--- query bufnr treesitter parse node
---@param bufnr integer
---@param start_line integer
---@param end_line integer
---@param parse_query_text string
---@return table
function M.get_nodes_table(bufnr, start_line, end_line, parse_query_text)
	local filetype = vim.bo[bufnr].filetype
	local language_tree = vim.treesitter.get_parser(bufnr, filetype)
	local query = vim.treesitter.query.parse(filetype, parse_query_text)

	local nodes = {
		list = {},
		bufnr = bufnr,
		for_each = function(self, callback)
			for _, node in pairs(self.list) do
				callback(self.bufnr, node)
			end
		end,
		count = function(self)
			return #self.list
		end,
	}
	language_tree:for_each_tree(function(tree, ltree)
		local query_iter =
			query:iter_matches(tree:root(), bufnr, start_line, end_line)

		for id, captures, _ in query_iter do
			local n_root = captures[id]
			--vim.notify(query.captures[id])
			--vim.notify(id .. "")
			table.insert(nodes.list, { [query.captures[id]] = n_root })
		end
	end)
	return nodes
end

return M
