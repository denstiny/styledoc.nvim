local event = require("styledoc.event")
local info = require("styledoc.query.info")
local M = {}
--local query = require("styledoc.query.codeblock")
local utils = require("styledoc.utils")
local qutils = require("styledoc.query.utils")
local config = require("styledoc.config")

---@param bufnr
---@param captures
function M.draw(bufnr, captures)
	for capture_name, node in pairs(captures) do
		--vim.notify(
		--	string.format(
		--		"node: %s: %s start: %s, end: %s \ntext: %s",
		--		node:symbol() .. "",
		--		capture_name,
		--		vim.inspect({ node:start() }),
		--		vim.inspect({ node:end_() }),
		--		vim.treesitter.get_node_text(node, bufnr)
		--	)
		--)
		local start, end_ = node:start(), node:end_()

		if capture_name == "code_lang" then -- [ 代码块语言类型 ]
			local lang = vim.treesitter.get_node_text(node, bufnr)
			M.draw_code_lang(bufnr, start, lang)
		elseif capture_name == "code_block" then -- [ 代码块 ]
			M.draw_code_block(bufnr, start + 1, end_ - 2) -- [ 代码块 ]
			M.draw_code_end(bufnr, end_ - 1)
		end
	end
end

function M.draw_code_end(bufnr, line)
	local user_conf = config:config()
	local symbol = user_conf.ui.codeblock.symbol.end_
	symbol = config.symbol(symbol)
	--local line, col = node:start()
	local pos = { line = line, col = 0 }
	utils.set_extmark(bufnr, config.highlights.codeblock, pos, symbol)
end

function M.draw_code_lang(bufnr, start, lang)
	local user_conf = config:config()
	local symbol = user_conf.ui.codeblock.symbol.start
	symbol = config.symbol(symbol, lang)
	local pos = { line = start, col = 0 }
	utils.set_extmark(bufnr, config.highlights.codeblock, pos, symbol)
end

function M.draw_code_block(bufnr, start, end_)
	for i = start, end_ do
		utils.hi_line(bufnr, i, config.highlights.codeblock)
	end
end

function M.repair_draw(bufnr, node)
	qutils.get_nodes_table(bufnr, 0, -1, info.codeblock)
end

function M.init(bufnr)
	--query.get_nodes(bufnr, 0, -1):for_each(M.draw)
	qutils.get_nodes_table(bufnr, 0, -1, info.codeblock):for_each(M.draw)
end

function M.init_signal()
	event:bind_signal("StyleTreeChanged", function(arg)
		local buf, changes = unpack(arg.data)
	end)
end
return M
