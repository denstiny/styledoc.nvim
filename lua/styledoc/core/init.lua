local M = {}
local query = require("styledoc.query.utils")
local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("styledoc.utils")
local config = require("styledoc.config")

---@param bufnr integer
---@param changes table
---@param refresh boolean | nil
function M.assignTasksBasedOnNodeChange(bufnr, changes, refresh)
	if require("styledoc.info"):filtration_plugin_change() then
		return
	end
	-- 如果changes为空的时候，说明用户只触发的修改节点内的数据，但是并没有增加或者删除节点
	-- 在这种情况下，重绘光标所在的节点
	if #changes == 0 then
		--vim.notify("no have")
		-- 查找光标所在的节点，没有找到则将光标所在的位置视为修改位置
		local cursor_node = ts_utils.get_node_at_cursor(0)
		if not cursor_node then
			local cursor = vim.api.nvim_win_get_cursor(0)
			local _changes = { { cursor[1] - 1, 0, 0, cursor[1], 0, 0 } }
			return M.assignTasksBasedOnNodeChange(bufnr, _changes)
		end
		local node = cursor_node
		local start, end_ = node:start(), node:end_()
		local _changes = { { start, 0, 0, end_, 0, 0 } }
		return M.assignTasksBasedOnNodeChange(bufnr, _changes)
	else
		--vim.notify("have")
		-- 查询修改的节点所匹配的draw函数
		for _, change in pairs(changes) do
			local start = change[1]
			local end_ = change[4]
			local query_texts = require("styledoc.query.info")
			for key, query_text in pairs(query_texts) do
				if
					config:config()["ui"][key] and not config:config()["ui"][key].enable
				then
					return
				end
				--vim.notify(string.format("查询 %s: %d %d", key, start, end_))
				local query_nodes =
					query.get_nodes_table(bufnr, start, end_ + 1, query_text)
				if query_nodes:count() > 0 then
					local modu = require("styledoc.core." .. key)
					query_nodes:for_each(modu.draw)
				end
			end
		end
	end
end

return M
