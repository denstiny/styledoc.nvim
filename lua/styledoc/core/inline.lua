local M = {}
local utils = require("styledoc.utils")

-- scavenger
function M.draw(bufnr, captures)
	for capture_name, node in pairs(captures) do
		if capture_name == "scavenger_inline" then
			M.scavenger(bufnr, node)
		end
	end
end

function M.scavenger(bufnr, node)
	utils.del_hl(bufnr, node:start(), node:end_())
	--vim.notify(
	--	string.format("清道夫: line %d end_ %d", node:start(), node:end_())
	--)
end

function M.init(bufnr, captures) end
return M
