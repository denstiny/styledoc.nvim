local M = {
	tasks = {},
}
local group = require("styledoc.info").group
---
---@param signal string
function M:emit_signal(signal, ...)
	vim.api.nvim_exec_autocmds("User", {
		group = group,
		pattern = "Style" .. signal,
		data = { ... },
	})
end

function M:bind_signal(signal, callback)
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "Style" .. signal,
		group = group,
		callback = callback,
	})
end

---@param config table
function M:init(config)
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedI", "TextChangedT" }, {
		group = group,
		callback = function(arg)
			self:emit_signal("StyleRefreshPro", arg)
		end,
	})
	local ui = config["ui"]
	for key, value in ipairs(ui) do
		if value.enable then
			self:bind_signal("StyleRefreshPro", function(arg)
				require("styledoc.core." .. key).draw(arg)
			end)
		end
	end
end
return M
