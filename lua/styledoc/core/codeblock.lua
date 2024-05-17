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

		local user_conf = config:config()
		local symbol = user_conf.ui.codeblock.symbol

		if capture_name == "code_lang" then -- [ 代码块语言类型 ]
			--local lang = vim.treesitter.get_node_text(node, bufnr)
			--M.draw_code_lang(bufnr, start, lang)
		elseif
			capture_name == "code_block" and node:type() == "fenced_code_block"
		then -- [ 代码块 ]
			local lang = M.get_lang_type(bufnr, start)
			M.draw_code_end(bufnr, start, config.symbol(symbol.start, bufnr, lang))
			M.draw_code_block(bufnr, start + 1, end_ - 2) -- [ 代码块 ]
			M.draw_code_end(bufnr, end_ - 1, config.symbol(symbol.end_, bufnr))
		end
	end
end

function M.get_lang_type(bufnr, line)
	local str = utils.get_buf_line(bufnr, line)
	local lang = str:sub(4)
	return lang
end

function M.draw_code_end(bufnr, line, symbol)
	--local line, col = node:start()
	local pos = { line = line, col = 0 }
	utils.del_hl(bufnr, line, line)
	utils.set_extmark(bufnr, config.highlights.codeblock, pos, symbol)
end

function M.draw_code_lang(bufnr, start, lang)
	local user_conf = config:config()
	local symbol = user_conf.ui.codeblock.symbol.start
	symbol = config.symbol(symbol, bufnr, lang)
	local pos = { line = start, col = 0 }
	utils.del_hl(bufnr, start, start)
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
