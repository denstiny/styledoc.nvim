local event = require("styledoc.event")
local M = {}
local query = require("styledoc.query.codeblock")

function M.draw(arg)
	vim.notify(vim.inspect(arg))
end

function M.inti_signal()
	event:bind_signal("StyleTreeChanged", function(arg)
		local buf = unpack(arg.data)
	end)
end
return M
