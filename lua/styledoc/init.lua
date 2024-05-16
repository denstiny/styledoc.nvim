local M = {}
local config = require("styledoc.config")
local event = require("styledoc.event")
local info = require("styledoc.info")
local utils = require("styledoc.utils")
local ts = vim.treesitter
local core = require("styledoc.core")

---@param config table
function init(config)
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = info.group,
		pattern = { "*.md" },
		callback = function(arg)
			local bufnr = arg.buf
			-- 注册，当markdown的bufnr所在的窗口发生改变，发送刷新信号
			vim.api.nvim_create_autocmd("WinResized", {
				callback = function(_arg)
					if _arg.buf == bufnr then
						event:emit_signal("StyleRefreshPre", arg)
					end
				end,
			})

			-- 监听treesitter node 的变化
			event:emit_signal("StyleRefreshPre", arg)
			local parser = ts.get_parser(bufnr)
			parser:register_cbs({
				on_changedtree = function(changes, languagetree)
					--event:emit_signal("StyleTreeChanged", arg.buf, changes)
					vim.defer_fn(function()
						core.assignTasksBasedOnNodeChange(bufnr, changes)
					end, 0)
				end,
			}, false)
		end,
	})
	--local timer = vim.uv.new_timer()
	--timer:start(
	--	0,
	--	100,
	--	vim.schedule_wrap(function()
	--		event:emit_signal("StyleRefreshPre", arg)
	--		--vim.notify("刷新")
	--	end)
	--)

	-- 在初始化阶段，发送刷新指令
	local ui = config["ui"]
	for key, value in pairs(ui) do
		if value.enable then
			local modul = require("styledoc.core." .. key)
			--modul.init_signal()
			event:bind_signal("StyleRefreshPre", function(arg)
				local data = unpack(arg.data)
				modul.init(data.buf)
			end)
		end
	end
end

function M.setup(opts)
	config:merge_config(opts)
	config:init_color()
	init(config:config())
end

function M.format_table(bufnr)
	require("styledoc.core.table").format_table_all(bufnr)
end

function M.format_change_table(bufnr)
	require("styledoc.core.table").format_change_table(bufnr)
end

return M
