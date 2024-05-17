local M = {}
local qutile = require("styledoc.query.utils")
local info = require("styledoc.query.info")
local utils = require("styledoc.utils")
local config = require("styledoc.config")

function M.draw(bufnr, captures)
	local user_conf = config:config()
	local symbol = user_conf.ui.breakline.symbol
	symbol = config.symbol(symbol, bufnr)
	local hl = config.highlights.breakline

	for capture, node in pairs(captures) do
		local start, end_ = node:start(), node:end_()
		local pos = { line = start, col = 0 }
		utils.del_hl(bufnr, start, start)
		utils.set_extmark(bufnr, hl, pos, symbol)
	end
end

function M.init(bufnr, captures)
	qutile.get_nodes_table(bufnr, 0, -1, info.breakline):for_each(M.draw)
end
return M
