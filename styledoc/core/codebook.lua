local M = {}
local query = require("styledoc.query.codeblock")

function M.draw(arg)
	vim.notify(vim.inspect(arg))
end
return M
