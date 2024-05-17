local utils = require("styledoc.utils")

local M = {
	_config = {},
}

local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]

local default_config = {
	exclude = {},
	ui = {
		breakline = {
			enable = true,
			symbol = "─",
		},
		block = {
			enable = true,
			symbol = "█",
		},
		codeblock = {
			enable = true,
			symbol = {
				start = ">",
				end_ = "<",
			},
		},
		list = {
			enable = true,
			symbol = {
				list_minus = "",
				task_undo = " 󰄱 ",
				task_do = "  ",
			},
		},
		title = {
			enable = true,
			symbol = {
				h1 = "○",
				h2 = " ○ ",
				h3 = "  ○ ",
				h4 = "   ○ ",
				h5 = "    ○ ",
				h6 = "     ○ ",
				h7 = "      ○ ",
			},
		},
		table = {
			enable = true,
			symbol = {
				leftalign = "󰘟",
				rightalign = "󰘠",
				line = "│",
			},
		},
	},
}

M.highlights = {
	h1 = "style_h1",
	h2 = "style_h2",
	h3 = "style_h3",
	h4 = "style_h4",
	h5 = "style_h5",
	h6 = "style_h6",
	task_do = "style_todolist_done",
	task_undo = "style_todolist_udone",
	list_minus = "style_list",
	codeblock = "style_codeblock",
	breakline = "style_partingline",
	block = "style_block",
}

--- 返回插件配置
---@return table
function M:config()
	return self._config
end

--- 合并用户自定义配置
---@param opts string
---@return table
function M:merge_config(opts)
	self._config = vim.tbl_deep_extend("force", default_config, opts or {})
	return self._config
end

--- 初始化高亮组
function M:init_color()
	-- Titile
	utils.hilink(self.highlights.h1, "markdownH1")
	utils.hilink(self.highlights.h2, "markdownH2")
	utils.hilink(self.highlights.h3, "markdownH3")
	utils.hilink(self.highlights.h4, "markdownH4")
	utils.hilink(self.highlights.h5, "markdownH5")
	utils.hilink(self.highlights.h6, "markdownH6")
	-- toodlist
	--utils.hi(self.highlights.task_do, "#d4fad4", "none")
	--utils.hi(self.highlights.todolist_udone, "#1a1918", "none")
	utils.hilink(self.highlights.task_do, "TodoSignTODO")
	utils.hilink(self.highlights.task_undo, "TodoSignPERF")
	-- list
	utils.hilink(self.highlights.list_minus, "markdownListMarker")
	-- partingline
	utils.hilink(self.highlights.breakline, "Comment")
	-- codeblocks
	utils.hilink(self.highlights.codeblock, "CursorLine")
	-- block
	utils.hilink(self.highlights.block, "CursorLineNr")
end

--- 获取符号，如果是函数则执行函数返回符号
---@param symbol string|function
---@return string
function M.symbol(symbol, ...)
	local symbol_type = type(symbol)
	if symbol_type == "string" then
		return symbol
	elseif symbol_type == "function" then
		return symbol(...)
	else
		return ""
	end
end
return M
