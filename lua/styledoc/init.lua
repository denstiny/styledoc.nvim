local M = {}
local config = require("styledoc.config")
local event = require("styledoc.event")
local info = require("styledoc.info")
local utils = require("styledoc.utils")
local ts = vim.treesitter

---@param config table
function init(config)
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = info.group,
		pattern = { "*.md" },
		callback = function(arg)
			event:emit_signal("StyleRefreshPre", arg)
			local parser = ts.get_parser(arg.buf)
			parser:register_cbs({
				on_changedtree = function(changes, languagetree)
					event:emit_signal("StyleTreeChanged", arg.buf)
				end,
			}, false)
		end,
	})
	local ui = config["ui"]
	for key, value in pairs(ui) do
		if value.enable then
			local modul = require("styledoc.core." .. key)
			modul.inti_signal()
			event:bind_signal("StyleRefreshPre", function(arg)
				modul.draw(arg)
			end)
		end
	end
end

function M.setup(opts)
	config:merge_config(opts)
	config:init_color()
	init(config:config())
end

return M
