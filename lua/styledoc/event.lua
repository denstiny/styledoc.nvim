local M = {
	tasks = {},
}
local group = require("styledoc.info").group
---
---@param signal string
function M:emit_signal(signal, ...)
	vim.api.nvim_exec_autocmds("User", {
		group = group,
		pattern = signal,
		data = { ... },
	})
end

---@param signal string
---@param callback function
function M:bind_signal(signal, callback)
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = signal,
		group = group,
		callback = callback,
	})
end

return M
