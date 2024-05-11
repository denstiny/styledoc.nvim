local utils = require("styledoc.utils")

local M = {
	config = {},
	_group = vim.api.nvim_create_augroup("styledoc"),
}

local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]

local default_config = {
	exclude = {},
	ui = {
		partingline = {
			enable = true,
			symbol = "─",
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
			symbol = "",
			hl_group = "md_list",
		},
		todolist = {
			enable = true,
			Undone = {
				match = "[=]",
				symbol = "□",
			},
			Done = {
				match = "[x]",
				symbol = "",
			},
		},
		title = {
			enable = true,
			symbol = { "○", " ○ ", "  ○ ", "   ○ ", "    ○ ", "     ○ ", "      ○ " },
		},
	},
}

M.hilinkghlights = {
	h1 = "style_h1",
	h2 = "style_h2",
	h3 = "style_h3",
	h4 = "style_h4",
	h5 = "style_h5",
	h6 = "style_h6",
	todolist_done = "style_todolist_done",
	todolist_undone = "style_todolist_udone",
	list = "style_list",
	codeblock = "style_codeblock",
	partingline = "style_partingline",
}

--- 返回插件配置
---@return table
function M:config()
	return self.config
end

--- 合并用户自定义配置
---@param opts string
---@return table
function M:merge_config(opts)
	self.config = vim.tbl_deep_extend("force", default_config, opts or {})
	return self.config
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
	utils.hi(self.highlights.todolist_done, "#d4fad4")
	utils.hi(self.highlights.todolist_udone, "#1a1918")
	-- list
	utils.hilink(self.highlights.list, "markdownListMarker")
	-- partingline
	utils.hilink(self.highlights.partingline, "Comment")
	-- codeblocks
	utils.hilink(self.highlights.codeblock, "markdownBlockquote")
end

return M
