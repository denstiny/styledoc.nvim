local M = {}
local qutile = require("styledoc.query.utils")
local info = require("styledoc.query.info")
local utils = require("styledoc.utils")
local config = require("styledoc.config")

function M.draw(bufnr, captures)
	local user_conf = config:config()
	local symbol = user_conf.ui.list.symbol

	for capture, node in pairs(captures) do
		local start, end_ = node:start()
		local pos = { line = start, col = end_ }
		local hl = config.highlights[capture]
		utils.del_hl(bufnr, start, start)
		utils.set_extmark(bufnr, hl, pos, config.symbol(symbol[capture], bufnr))
		if capture == "list_minus" then
		elseif capture == "task_undo" then
		elseif capture == "task_do" then
		end
	end
end

function M.init(bufnr, captures)
	qutile.get_nodes_table(bufnr, 0, -1, info.list):for_each(M.draw)
end
return M
