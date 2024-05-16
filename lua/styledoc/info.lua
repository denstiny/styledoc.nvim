local M = {
	group = vim.api.nvim_create_augroup("styledoc", { clear = true }),
	plugin_change = false,

	coment_change = function(self)
		self.plugin_change = true
	end,

	filtration_plugin_change = function(self)
		if self.plugin_change then
			self.plugin_change = false
			return true
		else
			return false
		end
	end,
}

return M
